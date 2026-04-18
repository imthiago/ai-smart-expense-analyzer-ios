//
//  FeatureFlags.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Controla o comportamentos que podem ser alterados, como uso de um provider real de AI e a exibição de insights.
///
/// Os valores são lidos a partir de variáveis de ambiente em:
/// Product -> Scheme -> Edit Scheme -> Run -> Arguments -> Environment Variables
/// O objetivo dessa struct é isolar a switch de funcionalidades, podem até ser substituído por um provider externo (como Firebase).
///
struct FeatureFlags {
    // MARK: - Flags

    /// Quando `true`,  `OpenAIProvider` é usado na classificação
    /// Quando `false`, `MockAIProvider` é utilizado
    let useRealAI: Bool

    // Quando `true`, a seção de insights é mostrada na interface do usuário
    let insightsEnabled: Bool

    // MARK: - Init
    init(useRealAI: Bool = ProcessInfo.processInfo.environment["USE_REAL_AI"] == "1",
         insightsEnabled: Bool = ProcessInfo.processInfo.environment["INSIGHTS_ENABLED"] != "0") {
        self.useRealAI = useRealAI
        self.insightsEnabled = insightsEnabled
    }
}
