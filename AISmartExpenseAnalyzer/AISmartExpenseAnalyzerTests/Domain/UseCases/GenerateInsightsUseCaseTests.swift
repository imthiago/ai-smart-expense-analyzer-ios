//
//  GenerateInsightsUseCaseTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class GenerateInsightsUseCaseTests: XCTestCase {
    private var sut: GenerateInsightsUseCase?

    override func setUp() {
        sut = GenerateInsightsUseCase(recurringThreshold: 3)
    }

    override func tearDown() {
        sut = nil
    }

    func testExecute_withEmptyExpenses_returnsEmptyInsights() async throws {
        guard let result = try await sut?.execute(for: []) else {
            XCTFail("Sut result cannot be nil")
            return
        }
        XCTAssertTrue(result.isEmpty)
    }
}
