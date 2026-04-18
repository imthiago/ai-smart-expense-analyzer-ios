//
//  DeleteExpenseUseCase.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

final class DeleteExpenseUseCase: DeleteExpenseUseCaseProtocol {
    // MARK: - Dependencies
    private let expenseRepository: ExpenseRepositoryProtocol

    // MARK: - Init
    init(expenseRepository: ExpenseRepositoryProtocol) {
        self.expenseRepository = expenseRepository
    }

    // MARK: - DeleteExpenseUseCaseProtocol
    func execute(id: UUID) async throws {
        try await expenseRepository.delete(id: id)
    }
}
