//
//  FeatureFlagsTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class FeatureFlagsTests: XCTestCase {
    func testInit_withExplicitValues_usesThem() {
        let flags = FeatureFlags(useRealAI: true, insightsEnabled: false)
        XCTAssertTrue(flags.useRealAI)
        XCTAssertFalse(flags.insightsEnabled)
    }
}
