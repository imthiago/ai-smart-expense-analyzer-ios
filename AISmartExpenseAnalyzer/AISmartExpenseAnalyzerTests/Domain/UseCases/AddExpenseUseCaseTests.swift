//
//  AddExpenseUseCaseTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class AddExpenseUseCaseTests: XCTestCase {
    private var repositoryMock: ExpenseRepositoryProtocolMock?
    private var categorizeUseCaseMock: CategorizeExpenseUseCaseProtocolMock?
    private var sut: AddExpenseUseCase?

    override func setUp() {
        repositoryMock = ExpenseRepositoryProtocolMock()
        categorizeUseCaseMock = CategorizeExpenseUseCaseProtocolMock()

        guard let repositoryMock, let categorizeUseCaseMock else {
            XCTFail("Sut dependencies cannot be nil")
            return
        }
        sut = AddExpenseUseCase(
            expenseRepository: repositoryMock,
            categorizeExpenseUseCase: categorizeUseCaseMock,
            tracer: ExecutionTracer(logger: .init())
        )
    }

    override func tearDown() {
        repositoryMock = nil
        categorizeUseCaseMock = nil
        sut = nil
    }

    func testExecute_withZeroAmount_throwsInvalidAmount() async {
        do {
            _ = try await sut?.execute(amount: 0, description: "Café", date: .init())
            XCTFail("Expected AddExpenseError.invalidAmount")
        } catch let error as AddExpenseError {
            XCTAssertEqual(error, .invalidAmount)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testExecute_withNegativeAmount_throwsInvalidAmount() async {
        do {
            _ = try await sut?.execute(amount: -10, description: "Café", date: .init())
            XCTFail("Expected AddExpenseError.invalidAmount")
        } catch let error as AddExpenseError {
            XCTAssertEqual(error, .invalidAmount)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testExecute_withEmptyDescription_throwsEmptyDescription() async {
        do {
            _ = try await sut?.execute(amount: 10, description: "", date: .init())
            XCTFail("Expected AddExpenseError.emptyDescription")
        } catch let error as AddExpenseError {
            XCTAssertEqual(error, .emptyDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testExecute_withWhitespaceOnlyDescription_throwsEmptyDescription() async {
        do {
            _ = try await sut?.execute(amount: 10, description: "   ", date: .init())
            XCTFail("Expected AddExpenseError.emptyDescription")
        } catch let error as AddExpenseError {
            XCTAssertEqual(error, .emptyDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testExecute_validInput_persistsBeforeCategorizing() async throws {
        categorizeUseCaseMock?.executeHandler = { expense in expense }

        _ = try await sut?.execute(amount: 50, description: "Almoço", date: .init())

        XCTAssertEqual(repositoryMock?.saveCallCount, 1)
    }

    func testExecute_validInput_returnsExpenseFromCategorization() async throws {
        var categorized = TestFixtures.makeExpense(category: .food)
        categorized.isCategorizationPending = false
        categorizeUseCaseMock?.executeHandler = { _ in categorized }

        guard let result = try await sut?.execute(amount: 50, description: "Almoço", date: .init()) else {
            XCTFail("Use case result cannot be nil")
            return
        }

        XCTAssertEqual(result.category, .food)
        XCTAssertFalse(result.isCategorizationPending)
    }

    func testExecute_whenCategorizationFails_stillReturnsExpense() async throws {
        categorizeUseCaseMock?.executeHandler = { _ in
            throw AIProviderError.networkUnavailable
        }

        guard let result = try await sut?.execute(amount: 50, description: "Almoço", date: .init()) else {
            XCTFail("Use case result cannot be nil")
            return
        }

        XCTAssertEqual(repositoryMock?.saveCallCount, 1)
        XCTAssertTrue(result.isCategorizationPending)
    }
}
