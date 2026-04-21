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
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(InsightCell.self, forCellReuseIdentifier: InsightCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.dataSource = self
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

    private var insights: [Insight] = []

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

// MARK: - Binding
extension InsightListViewController {
    private func bindViewModel() {
        viewModel.$insights
            .receive(on: RunLoop.main)
            .sink { [weak self] insights in
                self?.updateInsights(insights)
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

// MARK: - Update Insights
extension InsightListViewController {
    private func updateInsights(_ newInsights: [Insight]) {
        insights = newInsights
        emptyLabel.isHidden = !insights.isEmpty
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension InsightListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        insights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InsightCell.reuseIdentifier,
            for: indexPath
        ) as? InsightCell else {
            return UITableViewCell()
        }
        cell.configure(with: insights[indexPath.row])
        return cell
    }
}

