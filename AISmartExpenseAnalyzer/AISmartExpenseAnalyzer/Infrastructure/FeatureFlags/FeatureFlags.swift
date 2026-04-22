//
//  FeatureFlags.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

struct FeatureFlags {
    // MARK: - Flags
    let useRealAI: Bool
    let insightsEnabled: Bool

    // MARK: - Init
    init(useRealAI: Bool = ProcessInfo.processInfo.environment["USE_REAL_AI"] == "1",
         insightsEnabled: Bool = ProcessInfo.processInfo.environment["INSIGHTS_ENABLED"] != "0") {
        self.useRealAI = useRealAI
        self.insightsEnabled = insightsEnabled
    }
}
