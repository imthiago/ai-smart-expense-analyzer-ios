//
//  TestFixtures.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import Foundation
@testable import AISmartExpenseAnalyzer

enum TestFixtures {
    static func makeExpense(
        id: UUID = UUID(),
        amount: Decimal = 100,
        description: String = "any-description",
        category: AISmartExpenseAnalyzer.Category = .other,
        aiDecision: AIDecision? = nil,
        isCategorizationPending: Bool = false
    ) -> Expense {
        Expense(
            id: id,
            amount: amount,
            description: description,
            date: Date(timeIntervalSince1970: 1_700_000_000),
            category: category,
            aiDecision: aiDecision,
            isCategorizationPending: isCategorizationPending
        )
    }

    static func makeAIDecision(
        category: AISmartExpenseAnalyzer.Category = .food,
        confidence: Double = 0.90,
        reasoning: String = "any-reasoning"
    ) -> AIDecision {
        AIDecision(
            suggestedCategory: category,
            confidence: confidence,
            reasoning: reasoning,
            alternativeCategories: [],
            providerName: "any-provider-name",
            processedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )
    }
}
