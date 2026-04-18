//
//  GetExpensesUseCase.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

final class GetExpensesUseCase: GetExpensesUseCaseProtocol {
    // MARK: - Dependencies
    private let expenseRepository: ExpenseRepositoryProtocol

    // MARK: - Init
    init(expenseRepository: ExpenseRepositoryProtocol) {
        self.expenseRepository = expenseRepository
    }

    // MARK: - GetExpensesUseCaseProtocol
    func execute(filter: ExpenseFilter) async throws -> [Expense] {
        let expenses = try await expenseRepository.fetch(filter: filter)
        return expenses.sorted { $0.date > $1.date }
    }
}
