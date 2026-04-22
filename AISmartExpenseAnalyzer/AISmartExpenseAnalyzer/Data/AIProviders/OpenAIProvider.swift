//
//  OpenAIProvider.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

struct OpenAIProvider: AIProviderProtocol {
    // MARK: - Properties
    var providerName: String = "OpenAI GPT-4o mini"

    // MARK: - Dependencies
    private let apiKey: String
    private let httpClient: HTTPClientProtocol
    private let retryPolicy: RetryPolicy

    // MARK: - Init
    init(
        apiKey: String,
        httpClient: HTTPClientProtocol = HTTPClient(),
        retryPolicy: RetryPolicy = .init(maxAttempts: 3, baseDelay: 1.0)
    ) {
        self.apiKey = apiKey
        self.httpClient = httpClient
        self.retryPolicy = retryPolicy
    }

    // MARK: - AIProviderProtocol
    func categorize(description: String, amount: Decimal) async throws -> AIDecision {
        guard !apiKey.isEmpty else {
            throw AIProviderError.unauthorized
        }

        do {
            return try await retryPolicy.execute {
                try await performRequest(description: description, amount: amount)
            }
        } catch let error as AIProviderError {
            throw error
        } catch let error as HTTPClientError {
            throw mapHTTPError(error)
        } catch {
            throw AIProviderError.unknown(reason: error.localizedDescription)
        }
    }

    private func performRequest(description: String, amount: Decimal) async throws -> AIDecision {
        let request = try OpenAIRequestBuilder.build(
            description: description,
            amount: amount,
            apiKey: apiKey
        )

        let chatResponse: OpenAIChatCompletionResponse = try await httpClient.send(request)

        guard let contentString = chatResponse.choices.first?.message.content,
              let contentData = contentString.data(using: .utf8) else {
            throw AIProviderError.invalidResponse(reason: "Empty or missing content in response.")
        }

        let payload: OpenAICategorizePayload
        do {
            payload = try JSONDecoder().decode(OpenAICategorizePayload.self, from: contentData)
        } catch {
            throw AIProviderError.invalidResponse(reason: "Could not parse AI payload: \(error.localizedDescription)")
        }

        return try mapToDomain(payload)
    }

    private func mapToDomain(_ payload: OpenAICategorizePayload) throws -> AIDecision {
        guard let category = Category(rawValue: payload.category) else {
            throw AIProviderError.invalidResponse(reason: "Unknown category value: '\(payload.category)'")
        }

        let alternatives = payload.alternatives.compactMap { alternative -> CategoryConfidence? in
            guard let category = Category(rawValue: alternative.category) else { return nil }
            return CategoryConfidence(category: category, confidence: alternative.confidence)
        }

        return AIDecision(
            suggestedCategory: category,
            confidence: max(0, min(payload.confidence, 1.0)),
            reasoning: payload.reasoning,
            alternativeCategories: alternatives,
            providerName: providerName,
            processedAt: .init()
        )
    }

    private func mapHTTPError(_ error: HTTPClientError) -> AIProviderError {
        switch error {
        case .unauthorized:
            return .unauthorized
        case .networkUnavailable, .timedOut:
            return .networkUnavailable
        case .rateLimited:
            return .retriesExhausted(underlyingError: "Rate limited by OpenAI")
        default:
            return .unknown(reason: error.localizedDescription)
        }
    }
}
