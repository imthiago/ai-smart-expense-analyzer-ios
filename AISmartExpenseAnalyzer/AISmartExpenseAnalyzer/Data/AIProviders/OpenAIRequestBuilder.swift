//
//  OpenAIRequestBuilder.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

enum OpenAIRequestBuilder {
    static let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!

    static func build(description: String, amount: Decimal, apiKey: String) throws -> URLRequest {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ChatCompletionRequest(
            model: "gpt-4o-mini",
            messages: [
                .init(role: "system", content: systemPrompt),
                .init(role: "user", content: userPrompt(description: description, amount: amount))
            ],
            temperature: 0.1,
            responseFormat: .init(type: "json_object")
        )

        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
    
    /// Instrui o modelo a agir como um categorizador financeiro e sempre
    /// responder com um schema JSON estrito — sem prosa, sem markdown.
    private static let systemPrompt = """
    Você é um categorizador de despesas financeiras. Seu trabalho é classificar descrições de despesas \
    em exatamente uma destas categorias: alimentação, transporte, saúde, entretenimento, compras, serviços, outros.

    Sempre responda com um JSON válido seguindo exatamente este esquema:
    {
      "category": "<uma das categorias acima>",
      "confidence": <float entre 0.0 e 1.0>,
      "reasoning": "<uma frase explicando por que você escolheu esta categoria>",
      "alternatives": [
        { "category": "<categoria>", "confidence": <float> }
      ]
    }

    O array "alternatives" deve conter até 2 categorias alternativas, ordenadas por confiança decrescente. \
    Se não houver alternativas aplicáveis, retorne um array vazio.
    """

    private static func userPrompt(description: String, amount: Decimal) -> String {
        "Categorize essa despesa — descrição: \"\(description)\", quantia: \(amount)"
    }
}

// MARK: - Request Models
extension OpenAIRequestBuilder {
    struct ChatCompletionRequest: Encodable {
        let model: String
        let messages: [Message]
        let temperature: Double
        let responseFormat: ResponseFormat

        struct Message: Encodable {
            let role: String
            let content: String
        }

        struct ResponseFormat: Encodable {
            let type: String
        }

        enum CodingKeys: String, CodingKey {
            case model, messages, temperature
            case responseFormat = "response_format"
        }
    }
}

// MARK: - Response Models
struct OpenAIChatCompletionResponse: Decodable {
    let choices: [Choice]

    struct Choice: Decodable {
        let message: Message
    }

    struct Message: Decodable {
        let content: String
    }
}

struct OpenAICategorizePayload: Decodable {
    let category: String
    let confidence: Double
    let reasoning: String
    let alternatives: [AlternativeCategory]

    struct AlternativeCategory: Decodable {
        let category: String
        let confidence: Double
    }
}
