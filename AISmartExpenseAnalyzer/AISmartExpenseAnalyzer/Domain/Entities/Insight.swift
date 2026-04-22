//
//  Insight.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

struct Insight: Identifiable, Equatable {
    let id: UUID
    let type: InsightType
    let message: String
    let relevantExpenseIds: [UUID]
    let generatedAt: Date

    init(
        id: UUID = .init(),
        type: InsightType,
        message: String,
        relevantExpenseIds: [UUID] = [],
        generatedAt: Date = .init()
    ) {
        self.id = id
        self.type = type
        self.message = message
        self.relevantExpenseIds = relevantExpenseIds
        self.generatedAt = generatedAt
    }
}

enum InsightType: Equatable {
    case dominantCategory(Category)
    case recurringExpense(description: String)
    case spendingIncrease(category: Category, percentageIncrease: Double)
    case spendingDecrease(category: Category, percentageDecrease: Double)
    case custom(identifier: String)
}
