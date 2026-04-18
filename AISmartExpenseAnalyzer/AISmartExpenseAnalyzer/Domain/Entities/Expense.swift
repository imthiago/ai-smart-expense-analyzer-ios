//
//  Expense.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Entidade de domínio principal que representa uma única despesa
///
/// `Expense` entidade de valor sem dependência externa ou camada de rede
/// A ser utilizada pelo mapper da camada de dados
struct Expense: Identifiable, Equatable {
    let id: UUID

    /// Valor monetário da despesa
    var amount: Decimal

    /// Descrição breve da despesa fornecida pelo usuário
    var description: String

    /// Data da despesa
    var date: Date

    /// Categoria a ser resolvida. Por padrão é `.other` até ser categorizada pelo provedor
    var category: Category

    /// Rastreamento da justificativa de categorização pelo provedor, quando disponível
    /// `nil` para quando a despesa não foi categorizada manualmente ou ainda não foi processada
    var aiDecision: AIDecision?

    /// Indica que a despesa foi salva localmente, mas a categorização pelo provedor ainda não foi concluída
    var isCategorizationPending: Bool

    init(
        id: UUID = .init(),
        amount: Decimal,
        description: String,
        date: Date = .init(),
        category: Category = .other,
        aiDecision: AIDecision? = nil,
        isCategorizationPending: Bool = false
    ) {
        self.id = id
        self.amount = amount
        self.description = description
        self.date = date
        self.category = category
        self.aiDecision = aiDecision
        self.isCategorizationPending = isCategorizationPending
    }
}

extension Expense {
    /// Retorna `true` se a categoria foi atribuída pelo provedor
    var wasAICategorized: Bool { aiDecision != nil }
}
