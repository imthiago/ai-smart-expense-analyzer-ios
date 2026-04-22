//
//  MockAIProvider.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

/// Implementação de um provider mockado com classificação de despesas baseado na descrição
/// A implementação tem dois objetivos:
/// 1. Uso do app quando não houver uma conexão ativa
/// 2. Possíveis testes de integração
///
/// Para testes unitários, usa-se um stub definido como `StubAIProvider` no target de testes
struct MockAIProvider: AIProviderProtocol {
    var providerName: String = "Mock"

    private static let keywordMap: [String: Category] = [
        // Comidas e Bebidas
        "Restaurante": .food, "lunch": .food, "Jantar": .food,
        "Café": .food, "coffee": .food, "pizza": .food,
        "Hamburguer": .food, "sushi": .food, "delivery": .food,
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
        let lowercased = description.lowercased()

        // Acumula pontuações de correspondência por categoria
        var scores: [Category: Int] = [:]
        var matchedKeywords: [String] = []

        for (keyword, category) in Self.keywordMap {
            if lowercased.contains(keyword) {
                scores[category, default: 0] += 1
                matchedKeywords.append(keyword)
            }
        }

        // Resolve categoria vencedora e confiança
        let sorted = scores.sorted { $0.value > $1.value }
        let topCategory = sorted.first?.key ?? .other
        let topScore = Double(sorted.first?.value ?? 0)
        let totalMatches = Double(scores.values.reduce(0, +))

        let confidence: Double
        if totalMatches == 0 {
            confidence = 0.30   // Nenhuma palavra-chave correspondida
        } else {
            // Escala de 0.40 (correspondência única) a 0.95 (múltiplas correspondências fortes)
            confidence = min(0.40 + (topScore / totalMatches) * 0.55, 0.95)
        }

        let reasoning: String
        if matchedKeywords.isEmpty {
            reasoning = "Nenhuma palavra-chave foi identificada em \"\(description)\". Categoria '\(Category.other.displayName)' atribuída por padrão."
        } else {
            let keywordList = matchedKeywords.prefix(3).joined(separator: ", ")
            reasoning = "Palavra(s)-chave detectada(s): \(keywordList). Melhor correspondência: \(topCategory.displayName) (\(Int(confidence * 100))% de confiança)."
        }

        // Constrói categorias alternativas (top 2 segundos colocados)
        let alternatives = sorted.dropFirst().prefix(2).map { entry -> CategoryConfidence in
            let altConfidence = totalMatches > 0
            ? min(Double(entry.value) / totalMatches * 0.45, 0.80)
            : 0.10
            return CategoryConfidence(category: entry.key, confidence: altConfidence)
        }

        return AIDecision(
            suggestedCategory: topCategory,
            confidence: confidence,
            reasoning: reasoning,
            alternativeCategories: Array(alternatives),
            providerName: providerName,
            processedAt: Date()
        )
    }
}
