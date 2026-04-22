//
//  AIDecision.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

struct AIDecision: Equatable, Codable {
    let suggestedCategory: Category
    let confidence: Double
    let reasoning: String
    let alternativeCategories: [CategoryConfidence]
    let providerName: String
    let processedAt: Date
}

struct CategoryConfidence: Equatable, Codable {
    let category: Category
    let confidence: Double
}

extension AIDecision {
    var isHighConfidence: Bool { confidence >= 0.80 }

    var isLowConfidence: Bool { confidence < 0.50 }

    var confidencePercentage: String {
        let value = Int((confidence * 100).rounded())
        return "\(value)"
    }
}
