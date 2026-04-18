//
//  AIDecision.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

struct AIDecision: Equatable, Codable {
    /// Categoria sugerida pela IA
    let suggestedCategory: Category
    /// Nível de confiança entre 0.0 a 1.0
    let confidence: Double
    /// Razão pela qual uma categoria foi escolhida
    let reasoning: String
    /// Outras categorias consideradas válidas, ordenadas por confiança em ordem decrescente
    let alternativeCategories: [CategoryConfidence]
    /// Identifica o provider que categorizou a despesa
    let providerName: String
    /// Data de processamento da despesa no provedor
    let processedAt: Date
}

/// Pareamento de uma categoria com sua pontuação de confiança associada
struct CategoryConfidence: Equatable, Codable {
    let category: Category
    let confidence: Double
}

extension AIDecision {
    /// Retorna `true` quando a confiança é alta o suficiente para ser exibida em verde
    var isHighConfidence: Bool { confidence >= 0.80 }

    /// Retorna `true` quando a confiança é baixa o suficiente para ser exibida em vermelho
    var isLowConfidence: Bool { confidence < 0.50 }

    /// Confiança formatada como string de percentual
    var confidencePercentage: String {
        let value = Int((confidence * 100).rounded())
        return "\(value)"
    }
}
