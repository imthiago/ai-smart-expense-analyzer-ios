//
//  AddExpenseUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// @mockable
protocol AddExpenseUseCaseProtocol {
    func execute(amount: Decimal, description: String, date: Date) async throws -> Expense
}

enum AddExpenseError: Error, Equatable {
    case invalidAmount
    case emptyDescription
    case futureDate
}
