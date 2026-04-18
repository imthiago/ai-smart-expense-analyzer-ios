//
//  AddExpenseUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Contrato para adicionar uma nova despesa
/// Responsabilidades do use case:
/// 1. Validação da entrada pelo usuário (amount >0, description preenchida)
/// 2. Persistir a despesa localmente
/// 3. Adicionar categorização de IA de forma async
protocol AddExpenseUseCaseProtocol {
    /// Cria e persiste uma nova despesa
    ///
    /// - Parameters:
    ///  - amount: Valor monetário maior que zero
    ///  - description: Descrição da despesa válida (preenchida)
    ///  - date: Data da despesa, data atual por padrão
    /// - Returns: `Expense` criada e persistida com a propriedade `isCategorizationPending == true` a classificação pelo provider estiver pendente
    /// - Throws: `AddExpenseError` para entrada inválida ou erro no repositório
    func execute(amount: Decimal, description: String, date: Date) async throws -> Expense
}

enum AddExpenseError: Error, Equatable {
    case invalidAmount
    case emptyDescription
    case futureDate
}
