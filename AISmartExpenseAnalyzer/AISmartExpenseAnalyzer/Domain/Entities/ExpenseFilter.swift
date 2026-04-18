//
//  ExpenseFilter.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Objeto de valor que encapsula todos os critérios de filtro para consulta de despesas
///
/// `ExpenseFilter` é passado para `GetExpensesUseCaseProtocol` até a camada de repositório.
struct ExpenseFilter: Equatable {
    /// Filtra por uma categoria específica, onde `nil` significa todas as categorias disponíveis
    var category: Category?

    /// Retorna apenas despesas de uma data específica ou posteriores, onde `nil` significa sem limite inferior
    var startDate: Date?

    /// Retorna apenas despesas de uma data específica ou posteriores, onde `nil` significa sem limite superior
    var endDate: Date?

    /// Retorna apenas despesas com um valor maior ou igual ao especificado
    var minAmount: Decimal?

    /// Retorna apenas despesas com um valor menor ou igual ao especificado
    var maxAmount: Decimal?

    /// Retorna despesas a partir de um trecho de texto especificado
    var searchText: String?

    /// Filtro sem critérios específicos, retornando todas as despesas
    static let empty = ExpenseFilter()

    /// Retorna `true` quando nenhum critério está definido
    var isEmpty: Bool {
        category == nil
            && startDate == nil
            && endDate == nil
            && minAmount == nil
            && maxAmount == nil
            && (searchText == nil) || searchText?.isEmpty == true
    }
}
