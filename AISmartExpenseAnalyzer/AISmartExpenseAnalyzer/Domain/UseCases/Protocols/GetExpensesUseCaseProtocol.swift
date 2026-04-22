//
//  GetExpensesUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation
/// @mockable
protocol GetExpensesUseCaseProtocol {
    func execute(filter: ExpenseFilter) async throws -> [Expense]
}
