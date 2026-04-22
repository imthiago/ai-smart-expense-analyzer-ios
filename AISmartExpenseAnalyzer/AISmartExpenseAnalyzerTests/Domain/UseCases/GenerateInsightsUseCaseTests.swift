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

    func testExecute_detectsDominantCategory() async throws {
        let expenses = [
            TestFixtures.makeExpense(amount: 200, category: .food),
            TestFixtures.makeExpense(amount: 50, category: .transport),
            TestFixtures.makeExpense(amount: 100, category: .food)
        ]

        guard let result = try await sut?.execute(for: expenses) else {
            XCTFail("Sut result cannot be nil")
            return
        }

        let dominant = result.first {
            if case .dominantCategory = $0.type { return true }
            return false
        }

        XCTAssertNotNil(dominant)
        if case .dominantCategory(let category) = dominant?.type {
            XCTAssertEqual(category, .food)
        }
    }

    func testExecute_detectsRecurringExpense_whenDescriptionAppears3Times() async throws {
        let expenses = (0..<3).map { _ in
            TestFixtures.makeExpense(description: "Netflix")
        }

        guard let result = try await sut?.execute(for: expenses) else {
            XCTFail("Sut result cannot be nil")
            return
        }

        let recurring = result.first {
            if case .recurringExpense = $0.type { return true }
            return false
        }

        XCTAssertNotNil(recurring)
    }

    func testExecute_doesNotDetectRecurring_whenDescriptionAppearsLessThan3Times() async throws {
        let expenses = (0..<2).map { _ in
            TestFixtures.makeExpense(description: "Netflix")
        }

        guard let result = try await sut?.execute(for: expenses) else {
            XCTFail("Sut result cannot be nil")
            return
        }

        let recurring = result.first {
            if case .recurringExpense = $0.type { return true }
            return false
        }

        XCTAssertNil(recurring)
    }
}
