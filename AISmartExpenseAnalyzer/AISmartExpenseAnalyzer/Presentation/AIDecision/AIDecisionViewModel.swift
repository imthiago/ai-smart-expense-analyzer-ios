//
//  AIDecisionViewModel.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

@MainActor
final class AIDecisionViewModel {
    // MARK: - Properties
    let expense: Expense

    // MARK: - Expense primary data
    var expenseDescription: String { expense.description }
    var expenseAmount: String { expense.amount.formatted(.currency(code: "BRL")) }

    // MARK: - Category
    var categoryDisplayName: String { expense.category.displayName }
    var categorySymbolName: String { expense.category.symbolName }

    // MARK: - AI Decision
    var hasAIDecision: Bool { expense.aiDecision != nil }
    var confidence: Double { expense.aiDecision?.confidence ?? 0 }
    var confidencePercentage: String { expense.aiDecision?.confidencePercentage ?? "-" }
    var reasoning: String { expense.aiDecision?.reasoning ?? "Esta despesa foi categorizada manualmente" }
    var providerName: String { expense.aiDecision?.providerName ?? "-" }
    var alternativeCategories: [CategoryConfidence] { expense.aiDecision?.alternativeCategories ?? [] }

    var processedAt: String {
        guard let date = expense.aiDecision?.processedAt else { return "-" }
        return date.formatted(date: .abbreviated, time: .shortened)
    }

    // MARK: - Init
    init(expense: Expense) {
        self.expense = expense
    }
}
