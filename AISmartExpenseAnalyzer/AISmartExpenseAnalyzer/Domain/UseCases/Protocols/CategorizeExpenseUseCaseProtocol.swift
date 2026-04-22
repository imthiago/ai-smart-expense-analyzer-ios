//
//  CategorizeExpenseUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// @mockable
protocol CategorizeExpenseUseCaseProtocol {
    func execute(expense: Expense) async throws -> Expense
}
