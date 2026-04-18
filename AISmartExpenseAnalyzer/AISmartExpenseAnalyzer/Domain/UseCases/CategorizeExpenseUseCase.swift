//
//  CategorizeExpenseUseCase.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Realiza a classificação da despesa pelo provider e persiste o resultado
final class CategorizeExpenseUseCase: CategorizeExpenseUseCaseProtocol {
    // MARK: - Dependencies
    private let aiProvider: AIProviderProtocol
    private let expenseRepository: ExpenseRepositoryProtocol

    // MARK: - Init
    init(aiProvider: AIProviderProtocol, expenseRepository: ExpenseRepositoryProtocol) {
        self.aiProvider = aiProvider
        self.expenseRepository = expenseRepository
    }

    // MARK: - CategorizeExpenseUseCaseProtocol
    func execute(expense: Expense) async throws -> Expense {
        let decision = try await aiProvider.categorize(description: expense.description, amount: expense.amount)

        var updated = expense
        updated.category = decision.suggestedCategory
        updated.aiDecision = decision
        updated.isCategorizationPending = false

        try await expenseRepository.update(updated)
        return updated
    }
}
