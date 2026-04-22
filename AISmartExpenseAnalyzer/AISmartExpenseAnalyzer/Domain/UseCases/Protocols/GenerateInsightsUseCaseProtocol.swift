//
//  GenerateInsightsUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// @mockable
protocol GenerateInsightsUseCaseProtocol {
    func execute(for expenses: [Expense]) async throws -> [Insight]
}
