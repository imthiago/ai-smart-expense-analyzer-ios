//
//  AIProviderProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Contrato para qualquer backend de IA para a categorização de despesas.
///
/// A implementação concreta é resolvida pelo container de injeção de dependência com base na feature flag ativa.
/// As camadas de `Domain` e `Presentation` nunca importam um provider completo seguindo o strategy pattern aplicado.
///
/// - Note: `providerName` é parte da interface pública de forma intencional
/// para que `AIDecision` possa registrar qual provider gerou determinado resultado e exibindo na UI.
protocol AIProviderProtocol {
    /// Identificador para o provider (Ex: "OpenAI GPT-4o", "Mock")
    var providerName: String { get }

    /// Analisa a descrição da despesa inserida, retornando a categorização definida pelo provider
    /// - Parameters:
    ///  - description: Descrição da despesa inserida pelo usuário
    ///  - amount: Valor monetário da despesa
    /// - Returns: Uma `AIDecision` com a categoria sugerida e seu raciocínio
    /// - Throws: `AIProviderError`em caso de falha, timeout ou resposta inválida
    func categorize(description: String, amount: Decimal) async throws -> AIDecision
}

/// Erros que podem ser lançados por qualquer implementação de `AIProviderProtocol`
enum AIProviderError: Error, Equatable {
    case networkUnavailable
    case invalidResponse(reason: String)
    case unauthorized
    case retriesExhausted(underlyingError: String)
    case unknown(reason: String)
}
