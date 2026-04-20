//
//  AddExpenseUseCase.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Valida, persiste e inicializa a classificação pelo provider para uma nova despesa
///
/// Este use case tem por objetivo realizar primeiro a persistência local da despesa antes da classificação pelo provider
/// Isso significa que uma falha de rede nunca resulta em perda de dados.
/// Uma vez que o registro é salvo como `isCategorizationPending = true`, um mecanismo de
/// retry em background é responsável por categorizar despesas pendentes quando a conexão for restaurada
final class AddExpenseUseCase: AddExpenseUseCaseProtocol {
    // MARK: - Dependencies
    private let expenseRepository: ExpenseRepositoryProtocol
    private let categorizeExpenseUseCase: CategorizeExpenseUseCaseProtocol
    private let tracer: ExecutionTracer

    // MARK: - Init
    init(
        expenseRepository: ExpenseRepositoryProtocol,
        categorizeExpenseUseCase: CategorizeExpenseUseCaseProtocol,
        tracer: ExecutionTracer
    ) {
        self.expenseRepository = expenseRepository
        self.categorizeExpenseUseCase = categorizeExpenseUseCase
        self.tracer = tracer
    }

    // MARK: - AddExpenseUseCaseProtocol
    func execute(amount: Decimal, description: String, date: Date) async throws -> Expense {
        return try await tracer.trace("AddExpense", category: .useCase, metadata: ["valor": "\(amount)", "descrição": description]) {
            guard amount > 0 else { throw AddExpenseError.invalidAmount }

            let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedDescription.isEmpty else { throw AddExpenseError.emptyDescription }

            var expense = Expense(amount: amount,
                                  description: trimmedDescription,
                                  date: date,
                                  isCategorizationPending: true)

            try await expenseRepository.save(expense)

            do {
                expense = try await categorizeExpenseUseCase.execute(expense: expense)
            } catch {
                // Caso a persistência falhe, a categorização é adiada e esta será adicionada ao mecanismo de retry
            }

            return expense
        }
    }
}
