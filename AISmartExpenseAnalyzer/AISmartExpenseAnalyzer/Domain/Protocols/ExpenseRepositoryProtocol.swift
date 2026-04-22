//
//  ExpenseRepositoryProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// /// @mockable
protocol ExpenseRepositoryProtocol {
    func save(_ expense: Expense) async throws
    func fetchAll() async throws -> [Expense]
    func fetch(filter: ExpenseFilter) async throws -> [Expense]
    func fetch(id: UUID) async throws -> Expense?
    func update(_ expense: Expense) async throws
    func delete(id: UUID) async throws
    func fetchPendingCategorization() async throws -> [Expense]
}
