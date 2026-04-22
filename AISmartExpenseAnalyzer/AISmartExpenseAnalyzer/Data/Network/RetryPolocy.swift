//
//  RetryPolocy.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

/// Implementação das retentativas de chamadas HTTP
/// Regras de retry implementadas
/// 1. 1ª falha --> 1s
/// 2. 2ª falha --> 2s
/// 3. 3ª falha --> aborta e lança um erro `AIProviderError.retriesExhausted`
///
/// A lógica de implementação leva em conta o erro retornado da API.
/// Por ex.: Erro 401 (não autorizado)
///
struct RetryPolicy {
    let maxAttempts: Int
    let baseDelay: TimeInterval

    init(maxAttempts: Int = 3, baseDelay: TimeInterval = 1.0) {
        self.maxAttempts = maxAttempts
        self.baseDelay = baseDelay
    }

    func execute<T>(_ operation: () async throws -> T) async throws -> T {
        var lastError: Error?

        for attempt in 0..<maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error

                guard shouldRetry(error) else { throw error }

                if attempt < maxAttempts - 1 {
                    let delay = baseDelay * pow(2.0, Double(attempt))
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }

        throw AIProviderError.retriesExhausted(
            underlyingError: lastError?.localizedDescription ?? "Unknown error"
        )
    }

    // MARK: - Retry Policy Rule
    private func shouldRetry(_ error: Error) -> Bool {
        if let aiError = error as? AIProviderError {
            switch aiError {
            case .unauthorized, .invalidResponse:
                return false
            default:
                return true
            }
        }

        if let httpError = error as? HTTPClientError {
            switch httpError {
            case .unauthorized, .decodingFailed:
                return false
            default:
                return true
            }
        }

        return true
    }
}
