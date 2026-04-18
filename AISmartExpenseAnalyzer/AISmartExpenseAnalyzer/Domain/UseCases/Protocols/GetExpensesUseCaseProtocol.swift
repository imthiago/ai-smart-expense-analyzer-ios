//
//  GetExpensesUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Contrato para recuperar uma lista de despesas,
/// podendo ser filtradas de forma opcional,
/// mantendo aqui uma possível lógica de filtro, tirando a responsabilidade da ViewModel.
protocol GetExpensesUseCaseProtocol {
    /// Busca por despesas de acordo com o filtro fornecido
    ///
    /// - Parameter filter: Critério a ser utilizado como filtro. Utilizar `.empty` para recuperar todas as despesas
    /// - Returns: Uma lista de despesas correspondentes, ordenadas por data.
    /// - Throws: Um erro de repositório caso a busca falhe
    func execute(filter: ExpenseFilter) async throws -> [Expense]
}
