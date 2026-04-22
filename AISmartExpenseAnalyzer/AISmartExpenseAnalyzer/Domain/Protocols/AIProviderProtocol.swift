//
//  AIProviderProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// @mockable
protocol AIProviderProtocol {
    var providerName: String { get }

    func categorize(description: String, amount: Decimal) async throws -> AIDecision
}

enum AIProviderError: Error, Equatable {
    case networkUnavailable
    case invalidResponse(reason: String)
    case unauthorized
    case retriesExhausted(underlyingError: String)
    case unknown(reason: String)
}
