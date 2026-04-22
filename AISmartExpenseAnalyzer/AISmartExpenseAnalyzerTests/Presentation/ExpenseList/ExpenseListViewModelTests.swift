//
//  ExpenseListViewModelTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

@MainActor
final class ExpenseListViewModelTests: XCTestCase {
    private var getExpensesMock: GetExpensesUseCaseProtocolMock?
    private var deleteExpenseMock: DeleteExpenseUseCaseProtocolMock?
    private var generateInsightsMock: GenerateInsightsUseCaseProtocolMock?
    private var sut: ExpenseListViewModel?

    override func setUp() {
        getExpensesMock = GetExpensesUseCaseProtocolMock()
        deleteExpenseMock = DeleteExpenseUseCaseProtocolMock()
        generateInsightsMock = GenerateInsightsUseCaseProtocolMock()
        guard let getExpensesMock, let deleteExpenseMock, let generateInsightsMock else {
            XCTFail("Sut dependencies cannot be nil")
            return
        }

        sut = ExpenseListViewModel(
            getExpensesUseCase: getExpensesMock,
            deleteExpenseUseCase: deleteExpenseMock,
            generateInsightsUseCase: generateInsightsMock
        )
    }

    func testViewDidLoad_loadsExpenses() {
        let exp = expectation(description: "wait callback")
        let expectedExpenses = [TestFixtures.makeExpense()]
        getExpensesMock?.executeHandler = { _ in expectedExpenses }

        sut?.onExpensesChanged = { _ in
            exp.fulfill()
        }

        sut?.viewDidLoad()

        wait(for: [exp], timeout: 2.0)
        XCTAssertEqual(sut?.expenses.count, 1)
    }

    func testAddExpenseTapped_callsOnAddExpense() {
        var called = false
        sut?.onAddExpense = { called = true }
        sut?.addExpenseTapped()
        XCTAssertTrue(called)
    }


    func testSelectExpense_callsOnSelectExpense() {
        let expense = TestFixtures.makeExpense()
        var received: Expense?
        sut?.onSelectExpense = { received = $0 }
        sut?.selectExpense(expense)
        XCTAssertEqual(received, expense)
    }

    func testInsightsTapped_callsOnShowInsights() {
        var called = false
        sut?.onShowInsights = { _ in called = true }
        sut?.insightsTapped()
        XCTAssertTrue(called)
    }

    func testDeleteExpense_onSuccess_reloadsExpenses() {
        let exp = expectation(description: "wait reload after delete")
        exp.expectedFulfillmentCount = 2
        getExpensesMock?.executeHandler = { _ in [] }

        sut?.onExpensesChanged = { _ in
            exp.fulfill()
        }
        sut?.viewDidLoad()
        sut?.deleteExpense(id: .init())

        wait(for: [exp], timeout: 2.0)
    }
}
