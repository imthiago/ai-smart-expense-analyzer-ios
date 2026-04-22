//
//  CategorizeExpenseUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Contrato para realizar a categorização de uma despesa pelo provider
///
/// Use case responsável por encapsular a interação com `IAProviderProtocol` e separado de `AddExpenseUseCaseProtocol`
/// de forma intencional, para que a categorização possa ser re-adicionada
/// @mockable
protocol CategorizeExpenseUseCaseProtocol {
    /// Executa a categorização de uma despesa fornecida e persiste o resultado.
    ///
    /// - Parameter expense: Despesa a ser categorizada. Onde as propriedades `description` e `amount` são usadas para classificação.
    /// - Returns: `Expense` atualizada com a propriedade `aiDecision` populada e `isCategorization` definida como false
    /// - Throws: `AIProviderError` se o provider falhar ou erro no repositório caso a despesa atualizada não possa ser persistida
    func execute(expense: Expense) async throws -> Expense
}
