//
//  MockAIProvider.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

struct MockAIProvider: AIProviderProtocol {
    var providerName: String = "Mock"

    private enum Threshold {
        static let noMatchConfidence: Double = 0.30
        static let baseConfidence: Double = 0.40
        static let confidenceScale: Double = 0.55
        static let maxConfidence: Double = 0.95
        static let alternativeScale: Double = 0.45
        static let maxAlternativeConfidence: Double = 0.45
        static let fallbackAlternativeConfidence: Double = 0.10
        static let maxAlternatives = 2
        static let maxKeywordsInReasoning = 3
    }

    private static let keywordMap: [String: Category] = [
        // Comidas e Bebidas
        "restaurante": .food, "lunch": .food, "jantar": .food,
        "café": .food, "coffee": .food, "pizza": .food,
        "hamburguer": .food, "sushi": .food, "delivery": .food,
        "ifood": .food, "rappi": .food, "uber eats": .food,
        "snack": .food, "padaria": .food, "cafe": .food,

        // Transporte
        "uber": .transport, "taxi": .transport, "onibus": .transport,
        "metro": .transport, "trem": .transport, "abastecimento": .transport,
        "posto de gasolina": .transport, "pedágio": .transport, "estacionamento": .transport,
        "corrida": .transport, "voo": .transport,

        // Saúde
        "médico": .health, "farmácia": .health, "hospital": .health,
        "remédio": .health, "academia": .health, "dentista": .health,
        "terapia": .health, "clínica": .health,

        // Entretenimento
        "netflix": .entertainment, "spotify": .entertainment,
        "cinema": .entertainment, "filme": .entertainment,
        "jogos": .entertainment, "concerto": .entertainment,
        "teatro": .entertainment, "streaming": .entertainment,
        "youtube": .entertainment, "disney": .entertainment,

        // Compras
        "amazon": .shopping, "mercado": .shopping, "loja": .shopping,
        "supermercado": .shopping, "roupas": .shopping, "sapatos": .shopping,
        "livro": .shopping, "eletronicos": .shopping,

        // Utilidades
        "eletricidade": .utilities, "conta de água": .utilities,
        "internet": .utilities, "aluguel": .utilities, "conta de telefone": .utilities,
        "seguro": .utilities, "assinatura": .utilities,
    ]

    func categorize(description: String, amount: Decimal) async throws -> AIDecision {
        let result = matchKeywords(in: description)
        let (category, confidence) = resolveCategory(from: result)
        let reasoning = buildReasoning(for: description, category: category, confidence: confidence, matchedKeywords: result.matchedKeywords)
        let alternatives = buildAlternatives(from: result)

        return AIDecision(
            suggestedCategory: category,
            confidence: confidence,
            reasoning: reasoning,
            alternativeCategories: alternatives,
            providerName: providerName,
            processedAt: .init()
        )
    }

    private struct MatchResult {
        let scores: [Category: Int]
        let matchedKeywords: [String]

        var totalMatches: Double {
            Double(scores.values.reduce(0, +))
        }

        var rankedCategories: [(key: Category, value: Int)] {
            scores.sorted { $0.value > $1.value }
        }
    }

    // MARK: - Keyword Matching
    private func matchKeywords(in description: String) -> MatchResult {
        let lowercased = description.lowercased()
        var scores: [Category: Int] = [:]
        var matchedKeywords: [String] = []

        for (keyword, category) in Self.keywordMap where lowercased.contains(keyword) {
            scores[category, default: 0] += 1
            matchedKeywords.append(keyword)
        }

        return MatchResult(scores: scores, matchedKeywords: matchedKeywords)
    }

    // MARK: - Category
    private func resolveCategory(from result: MatchResult) -> (Category, Double) {
        guard let top = result.rankedCategories.first, result.totalMatches > 0 else {
            return (.other, Threshold.noMatchConfidence)
        }

        let dominance = Double(top.value) / result.totalMatches
        let confidence = min(Threshold.baseConfidence + dominance * Threshold.confidenceScale, Threshold.maxConfidence)

        return (top.key, confidence)
    }

    // MARK: - Reasoning
    private func buildReasoning(for description: String, category: Category, confidence: Double, matchedKeywords: [String]) -> String {
        guard !matchedKeywords.isEmpty else {
            return "Nenhuma palavra chave foi identificada em \"\(description)\". Categoria '\(Category.other.displayName)' atribuída por padrão."
        }

        let keywordList = matchedKeywords.prefix(Threshold.maxKeywordsInReasoning).joined(separator: ", ")
        return  "Palavra(s) chave detectada(s): \(keywordList). Melhor correspondência: \(category.displayName) (\(Int(confidence * 100))% de confiança)."
    }

    // MARK: - Alternatives
    private func buildAlternatives(from result: MatchResult) -> [CategoryConfidence] {
        result.rankedCategories
            .dropFirst()
            .prefix(Threshold.maxAlternatives)
            .map { entry in
                let confidence = result.totalMatches > 0
                ? min(Double(entry.value) / result.totalMatches + Threshold.alternativeScale, Threshold.maxAlternativeConfidence)
                : Threshold.fallbackAlternativeConfidence
                return CategoryConfidence(category: entry.key, confidence: confidence)
            }
    }
}
