//
//  DeleteExpenseUseCaseTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class DeleteExpenseUseCaseTests: XCTestCase {
    private var repositoryMock: ExpenseRepositoryProtocolMock?
    private var sut: DeleteExpenseUseCase?

    override func setUp() {
        repositoryMock = ExpenseRepositoryProtocolMock()
        guard let repositoryMock else {
            XCTFail("Sut dependencies cannot be nil")
            return
        }
        sut = DeleteExpenseUseCase(expenseRepository: repositoryMock)
    }

    override func tearDown() {
        repositoryMock = nil
        sut = nil
    }

    func testExecute_callsRepositoryDelete() async throws {
        let id = UUID()
        try await sut?.execute(id: id)
        XCTAssertEqual(repositoryMock?.deleteCallCount, 1)
    }

    func testExecute_whenRepositoryFails_throwsError() async {
        repositoryMock?.deleteHandler = { _ in throw RepositoryError.notFound(.init()) }

        do {
            try await sut?.execute(id: UUID())
            XCTFail("Expected repository error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
