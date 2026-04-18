//
//  Insight.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Observação gerada após análise a partir de um conjunto de despesas
///
/// Insights serão produzidos pelo use case `GenerateInsightUseCase`.
/// Dados de insights serão sempre computados por demanda a partir do estado atual das despesas e não armazenados de forma persistente
struct Insight: Identifiable, Equatable {
    let id: UUID
    /// Tipo de padrão detectado
    let type: InsightType
    /// Mensagem formatada para exibição em linguagem natural
    ///
    let message: String
    /// Ids das despesas que compõem este insight
    /// Utilizado para análise mais completa de um insight e suas despesas originais
    ///
    let relevantExpenseIds: [UUID]
    let generatedAt: Date

    init(
        id: UUID = .init(),
        type: InsightType,
        message: String,
        relevantExpenseIds: [UUID] = [],
        generatedAt: Date = .init()
    ) {
        self.id = id
        self.type = type
        self.message = message
        self.relevantExpenseIds = relevantExpenseIds
        self.generatedAt = generatedAt
    }
}

/// Enum para tipagem de padrões que o motor de insights pode detectar
enum InsightType: Equatable {
    /// Uma única categoria de gasto no período analisado.
    case dominantCategory(Category)

    /// Uma determinada categoria que aparece múltiplas vezes e que pode ser considerada recorrente
    case recurringExpense(description: String)

    /// Gasto de uma determinada categoria aumentou de forma significativa em comparação com o período anterior
    case spendingIncrease(category: Category, percentageIncrease: Double)

    /// Gasto de uma determinada categoria diminuiu de forma significativa em comparação com o período anterior
    case spendingDecrease(category: Category, percentageDecrease: Double)

    /// Para tipos de insights personalizados ou futuros
    case custom(identifier: String)
}
