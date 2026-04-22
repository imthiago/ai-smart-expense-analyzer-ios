//
//  GetExpensesUseCaseTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class GetExpensesUseCaseTests: XCTestCase {
    private var repositoryMock: ExpenseRepositoryProtocolMock?
    private var sut: GetExpensesUseCase?

    override func setUp() {
        repositoryMock = ExpenseRepositoryProtocolMock()
        guard let repositoryMock else {
            XCTFail("Sut dependencies cannot be nil")
            return
        }
        sut = GetExpensesUseCase(expenseRepository: repositoryMock)
    }

    override func tearDown() {
        repositoryMock = nil
        sut = nil
    }

    func testExecute_returnsExpensesFromRepository() async throws {
        let expected = [TestFixtures.makeExpense(), TestFixtures.makeExpense()]
        repositoryMock?.fetchHandler = { _ in expected }

        guard let result = try await sut?.execute(filter: .empty) else {
            XCTFail("Sut result cannot be nil")
            return
        }

        XCTAssertEqual(result.count, 2)
    }

    func testExecute_passesFilterToRepository() async throws {
        var expectedFilter: ExpenseFilter?
        repositoryMock?.fetchHandler = { filter in
            expectedFilter = filter
            return []
        }

        var filter = ExpenseFilter.empty
        filter.category = .food
        _ = try await sut?.execute(filter: filter)

        XCTAssertEqual(expectedFilter?.category, .food)
    }
}
