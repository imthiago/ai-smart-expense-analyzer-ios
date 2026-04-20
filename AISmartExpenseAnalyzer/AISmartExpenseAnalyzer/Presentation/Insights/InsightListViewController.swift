//
//  InsightListViewController.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Combine
import UIKit

final class InsightListViewController: UIViewController {
    // MARK: - ViewModel
    private let viewModel: InsightListViewModel

    // MARK: - Components
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InsightCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Sem insights por enquanto :)\nAdicione mais despesas💰"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Data Source
    private enum Section { case main }
    private typealias DataSource = UITableViewDiffableDataSource<Section, UUID>
    // TODO: Remover force unwrap
    private var dataSource: DataSource!
    private var insightIndex: [UUID: Insight] = [:]

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: InsightListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Insights"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupDataSource()
        bindViewModel()
        viewModel.viewDidLoad()
    }
}

// MARK: - Configuration
extension InsightListViewController {
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }
}

// MARK: - Data Source
extension InsightListViewController {
    private func setupDataSource() {
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, id in
            var cell = tableView.dequeueReusableCell(withIdentifier: "InsightCell", for: indexPath)
            if let insight = self?.insightIndex[id] {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.textLabel?.text = insight.message
                cell.textLabel?.numberOfLines = 0
                cell.imageView?.image = UIImage(systemName: insight.type.symbolName)
                cell.imageView?.tintColor = insight.type.color
                cell.selectionStyle = .none
            }
            return cell
        }
    }
}

// MARK: - Binding
extension InsightListViewController {
    private func bindViewModel() {
        viewModel.$insights
            .receive(on: RunLoop.main)
            .sink { [weak self] insights in
                self?.applySnapshot(insights: insights)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating()
                          : self?.loadingIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Snapshot
extension InsightListViewController {
    private func applySnapshot(insights: [Insight]) {
        insightIndex = Dictionary(uniqueKeysWithValues: insights.map { ($0.id, $0) })
        emptyLabel.isHidden = !insights.isEmpty

        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(insights.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
