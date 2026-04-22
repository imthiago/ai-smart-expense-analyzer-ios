//
//  ExpenseTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class ExpenseTests: XCTestCase {
    func testWasAICategorized_whenAIDecisionIsNil_returnsFalse() {
        let expense = TestFixtures.makeExpense(aiDecision: nil)
        XCTAssertFalse(expense.wasAICategorized)
    }

    func testWasAICategorized_whenAIDecisionIsPresent_returnsTrue() {
        let decision = TestFixtures.makeAIDecision()
        let expense = TestFixtures.makeExpense(aiDecision: decision)
        XCTAssertTrue(expense.wasAICategorized)
    }

    func testDefaultCategory_isOther() {
        let expense = TestFixtures.makeExpense()
        XCTAssertEqual(expense.category, .other)
    }

    func testEquality_sameId_returnsEqual() {
        let id = UUID()
        let expense1 = TestFixtures.makeExpense(id: id)
        let expense2 = TestFixtures.makeExpense(id: id)
        XCTAssertEqual(expense1, expense2)
    }
}
