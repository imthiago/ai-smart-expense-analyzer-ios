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
        tableView.dataSource = self
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
    private var expenses: [Expense] = []

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ExpenseListViewModel, insightsEnabled: Bool = true) {
        self.viewModel = viewModel
        self.insightsEnabled = insightsEnabled
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
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

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$expenses
            .receive(on: RunLoop.main)
            .sink { [weak self] expenses in
                self?.updateExpenses(expenses)
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

    // MARK: - Update TableView
    private func updateExpenses(_ newExpenses: [Expense]) {
        expenses = newExpenses
        emptyStateLabel.isHidden = !expenses.isEmpty
        tableView.reloadData()
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
        guard indexPath.row < expenses.count else { return }
        viewModel.selectExpense(expenses[indexPath.row])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < expenses.count else { return nil }
        let expense = expenses[indexPath.row]

        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, done in
            self?.viewModel.deleteExpense(id: expense.id)
            done(true)
        }

        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - UITableViewDataSource
extension ExpenseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExpenseCell.reuseIdentifier,
            for: indexPath
        ) as? ExpenseCell else {
            return UITableViewCell()
        }
        cell.configure(with: expenses[indexPath.row])
        return cell
    }
}
