//
//  AIDecisionTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class AIDecisionTests: XCTestCase {
    // MARK: - IsHightConfidence
    func testIsHighConfidence_whenConfidenceIs080_returnsTrue() {
        let decision = TestFixtures.makeAIDecision(confidence: 0.80)
        XCTAssertTrue(decision.isHighConfidence)
    }

    func testIsHighConfidence_whenConfidenceIs079_returnsFalse() {
        let decision = TestFixtures.makeAIDecision(confidence: 0.79)
        XCTAssertFalse(decision.isHighConfidence)
    }

    // MARK: - isLowConfidence
    func testIsLowConfidence_whenConfidenceIs049_returnsTrue() {
        let decision = TestFixtures.makeAIDecision(confidence: 0.49)
        XCTAssertTrue(decision.isLowConfidence)
    }

    func testIsLowConfidence_whenConfidenceIs050_returnsFalse() {
        let decision = TestFixtures.makeAIDecision(confidence: 0.50)
        XCTAssertFalse(decision.isLowConfidence)
    }

    // MARK: - confidencePercentage
    func testConfidencePercentage_formatsToIntegerString() {
        let decision = TestFixtures.makeAIDecision(confidence: 0.876)
        XCTAssertEqual(decision.confidencePercentage, "88")
    }

    func testConfidencePercentage_withExactValue() {
        let decision = TestFixtures.makeAIDecision(confidence: 0.90)
        XCTAssertEqual(decision.confidencePercentage, "90")
    }
}
