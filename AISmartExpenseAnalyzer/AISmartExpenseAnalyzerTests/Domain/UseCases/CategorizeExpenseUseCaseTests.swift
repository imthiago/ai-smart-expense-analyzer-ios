//
//  CategorizeExpenseUseCaseTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class CategorizeExpenseUseCaseTests: XCTestCase {
    private var aiProviderMock: AIProviderProtocolMock?
    private var repositoryMock: ExpenseRepositoryProtocolMock?
    private var sut: CategorizeExpenseUseCase?

    override func setUp() {
        aiProviderMock = AIProviderProtocolMock()
        repositoryMock = ExpenseRepositoryProtocolMock()
        guard let aiProviderMock, let repositoryMock else {
            XCTFail("Sut dependencies cannot be nil")
            return
        }
        sut = CategorizeExpenseUseCase(aiProvider: aiProviderMock, expenseRepository: repositoryMock)
    }

    override func tearDown() {
        aiProviderMock = nil
        repositoryMock = nil
        sut = nil
    }

    func testExecute_updatesExpenseWithAIDecision() async throws {
        let decision = TestFixtures.makeAIDecision(category: .transport)
        aiProviderMock?.categorizeHandler = { _, _ in decision }
        let expense = TestFixtures.makeExpense(isCategorizationPending: true)

        guard let result = try await sut?.execute(expense: expense) else {
            XCTFail("Sut result cannot be nil")
            return
        }

        XCTAssertEqual(result.category, .transport)
        XCTAssertNotNil(result.aiDecision)
        XCTAssertFalse(result.isCategorizationPending)
    }

    func testExecute_persistsUpdatedExpense() async throws {
        let decision = TestFixtures.makeAIDecision()
        aiProviderMock?.categorizeHandler = { _, _ in decision }

        let expense = TestFixtures.makeExpense()
        _ = try await sut?.execute(expense: expense)

        XCTAssertEqual(repositoryMock?.updateCallCount, 1)
    }

    func testExecute_whenProviderFails_throwsError() async {
        aiProviderMock?.categorizeHandler = { _, _ in throw AIProviderError.networkUnavailable }

        do {
            _ = try await sut?.execute(expense: TestFixtures.makeExpense())
            XCTFail("Expected provider error")
        } catch {
            XCTAssertEqual(repositoryMock?.updateCallCount, 0)
        }
    }
}
