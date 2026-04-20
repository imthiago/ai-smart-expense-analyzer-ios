//
//  ExpenseListViewModel.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation
import Combine

@MainActor
final class ExpenseListViewModel {
    // MARK: - Published States
    @Published private(set) var expenses: [Expense] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Coordinator Callbacks
    var onAddExpense: (() -> Void)?
    var onSelectExpense: ((Expense) -> Void)?
    var onShowInsights: (([Expense]) -> Void)?

    // MARK: - Dependencies
    private let getExpensesUseCase: GetExpensesUseCaseProtocol
    private let deleteExpenseUseCase: DeleteExpenseUseCaseProtocol
    private let generateInsightUseCase: GenerateInsightsUseCaseProtocol

    private(set) var activeFilter: ExpenseFilter = .empty

    // MARK: - Init
    init(
        getExpensesUseCase: GetExpensesUseCaseProtocol,
        deleteExpenseUseCase: DeleteExpenseUseCaseProtocol,
        generateInsightsUseCase: GenerateInsightsUseCaseProtocol
    ) {
        self.getExpensesUseCase = getExpensesUseCase
        self.deleteExpenseUseCase = deleteExpenseUseCase
        self.generateInsightUseCase = generateInsightsUseCase
    }

    func viewDidLoad() {
        Task { await loadExpenses() }
    }

    func refresh() {
        Task { await loadExpenses() }
    }

    func applyFilter(_ filter: ExpenseFilter) {
        activeFilter = filter
        Task { await loadExpenses() }
    }

    func addExpenseTapped() {
        onAddExpense?()
    }

    func insightsTapped() {
        onShowInsights?(expenses)
    }

    func selectExpense(_ expense: Expense) {
        onSelectExpense?(expense)
    }

    func deleteExpense(id: UUID) {
        Task {
            do {
                try await deleteExpenseUseCase.execute(id: id)
                await loadExpenses()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func loadExpenses() async {
        isLoading = true
        defer { isLoading = false }

        do {
            expenses = try await getExpensesUseCase.execute(filter: activeFilter)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
