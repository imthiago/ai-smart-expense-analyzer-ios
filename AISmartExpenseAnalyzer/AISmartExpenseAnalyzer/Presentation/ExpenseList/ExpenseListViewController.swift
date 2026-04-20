//
//  ExpenseListViewController.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Combine
import UIKit

final class ExpenseListViewController: UIViewController {
    // MARK: - ViewModel
    private let viewModel: ExpenseListViewModel
    private let insightsEnabled: Bool

    // MARK: - Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: ExpenseCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "expense_list_table"
        return tableView
    }()

    private let refreshControl = UIRefreshControl()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var filterView: FilterView = {
        let view = FilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "expense_list_filter_view"
        return view
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhuma despesa adicionada.\nClique em + para adicionar sua primeira despesa."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "expense_list_empty_state"
        return label
    }()

    // MARK: - Data Source
    private enum Section { case main }
    private typealias DataSource = UITableViewDiffableDataSource<Section, UUID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UUID>

    private var dataSource: DataSource!
    private var expenseIndex: [UUID: Expense] = [:]

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ExpenseListViewModel, insightsEnabled: Bool = true) {
        self.viewModel = viewModel
        self.insightsEnabled = insightsEnabled
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupDataSource()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    private func setupNavigationBar() {
        title = "Despesas"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )

        if insightsEnabled {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Insights",
                style: .plain,
                target: self,
                action: #selector(insightsTapped)
            )
        }

        loadingIndicator.hidesWhenStopped = true
        navigationItem.titleView = loadingIndicator
    }

    private func setupLayout() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(filterView)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])

        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    // TODO: Tratar force unwrap
    private func setupDataSource() {
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, id in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ExpenseCell.reuseIdentifier,
                for: indexPath
            ) as! ExpenseCell
            if let expense = self?.expenseIndex[id] {
                cell.configure(with: expense)
            }
            return cell
        }
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$expenses
            .receive(on: RunLoop.main)
            .sink { [weak self] expenses in
                self?.applySnapshot(expenses: expenses)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating()
                          : self?.loadingIndicator.stopAnimating()
                if !isLoading { self?.refreshControl.endRefreshing() }
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showError(message)
            }
            .store(in: &cancellables)

        filterView.selectedCategory
            .map { category in
                category.map { ExpenseFilter(category: $0) } ?? .empty
            }
            .sink { [weak self] filter in
                self?.viewModel.applyFilter(filter)
            }
            .store(in: &cancellables)
    }

    // MARK: - Snapshot
    private func applySnapshot(expenses: [Expense]) {
        expenseIndex = Dictionary(uniqueKeysWithValues: expenses.map { ($0.id, $0) })
        emptyStateLabel.isHidden = !expenses.isEmpty

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(expenses.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Actions
    @objc private func addTapped() {
        viewModel.addExpenseTapped()
    }

    @objc private func insightsTapped() {
        viewModel.insightsTapped()
    }

    @objc private func handleRefresh() {
        viewModel.refresh()
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ExpenseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = dataSource.itemIdentifier(for: indexPath),
              let expense = expenseIndex[id] else { return }
        viewModel.selectExpense(expense)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let id = dataSource.itemIdentifier(for: indexPath) else { return nil }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, done in
            self?.viewModel.deleteExpense(id: id)
            done(true)
        }

        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
