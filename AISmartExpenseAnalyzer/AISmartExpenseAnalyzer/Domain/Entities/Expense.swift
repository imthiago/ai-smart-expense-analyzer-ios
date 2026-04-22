//
//  Expense.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

struct Expense: Identifiable, Equatable {
    let id: UUID
    var amount: Decimal
    var description: String
    var date: Date
    var category: Category
    var aiDecision: AIDecision?
    var isCategorizationPending: Bool

    init(
        id: UUID = .init(),
        amount: Decimal,
        description: String,
        date: Date = .init(),
        category: Category = .other,
        aiDecision: AIDecision? = nil,
        isCategorizationPending: Bool = false
    ) {
        self.id = id
        self.amount = amount
        self.description = description
        self.date = date
        self.category = category
        self.aiDecision = aiDecision
        self.isCategorizationPending = isCategorizationPending
    }
}

extension Expense {
    var wasAICategorized: Bool { aiDecision != nil }
}
