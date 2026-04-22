//
//  ExpenseFilterTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class ExpenseFilterTests: XCTestCase {
    func testIsEmpty_whenAllFieldsNil_returnsTrue() {
        let filter = ExpenseFilter.empty
        XCTAssertTrue(filter.isEmpty)
    }

    func testIsEmpty_whenCategoryIsSet_returnsFalse() {
        var filter = ExpenseFilter.empty
        filter.category = .food
        XCTAssertFalse(filter.isEmpty)
    }

    func testIsEmpty_whenSearchTextIsEmpty_returnsTrue() {
        var filter = ExpenseFilter.empty
        filter.searchText = ""
        XCTAssertTrue(filter.isEmpty)
    }

    func testIsEmpty_whenSearchTextIsSet_returnsFalse() {
        var filter = ExpenseFilter.empty
        filter.searchText = "uber"
        XCTAssertFalse(filter.isEmpty)
    }
}
