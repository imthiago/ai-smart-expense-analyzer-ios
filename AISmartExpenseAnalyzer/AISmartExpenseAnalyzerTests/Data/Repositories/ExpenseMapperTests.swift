//
//  ExpenseMapperTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
import CoreData
@testable import AISmartExpenseAnalyzer

final class ExpenseMapperTests: XCTestCase {
    private var context: NSManagedObjectContext?

    override func setUp() {
        guard let stack = try? CoreDataStack(inMemory: true) else {
            XCTFail("In memory context cannot be nil")
            return
        }
        context = stack.viewContext
    }

    override func tearDown() {
        context = nil
    }

    func testToDomain_validEntity_returnsExpense() throws {
        guard let context else {
            XCTFail("Context cannot be nil")
            return
        }
        let entity = ExpenseEntity(context: context)
        entity.id = UUID()
        entity.amount = NSDecimalNumber(value: 99.0)
        entity.expenseDescription = "Steam"
        entity.date = .init()
        entity.categoryRawValue = Category.shopping.rawValue
        entity.isCategorizationPending = false

        let expense = try ExpenseMapper.toDomain(entity)

        XCTAssertEqual(expense.description, "Steam")
        XCTAssertEqual(expense.category, .shopping)
        XCTAssertFalse(expense.isCategorizationPending)
    }

    func testToDomain_missingId_throwsMappingError() {
        guard let context else {
            XCTFail("Context cannot be nil")
            return
        }
        let entity = ExpenseEntity(context: context)
        entity.amount = NSDecimalNumber(value: 10)
        entity.date = Date()

        XCTAssertThrowsError(try ExpenseMapper.toDomain(entity))
    }

    func testToDomain_unknownCategoryRawValue_defaultsToOther() throws {
        guard let context else {
            XCTFail("Context cannot be nil")
            return
        }
        let entity = ExpenseEntity(context: context)
        entity.id = UUID()
        entity.amount = NSDecimalNumber(value: 10)
        entity.date = Date()
        entity.categoryRawValue = "categoria_inexistente"

        let expense = try ExpenseMapper.toDomain(entity)
        XCTAssertEqual(expense.category, .other)
    }

    func testPopulate_setsAllFields() {
        guard let context else {
            XCTFail("Context cannot be nil")
            return
        }
        let expense = TestFixtures.makeExpense(
            amount: 50,
            description: "Farmácia",
            category: .health
        )
        let entity = ExpenseEntity(context: context)

        ExpenseMapper.populate(entity: entity, from: expense)

        XCTAssertEqual(entity.id, expense.id)
        XCTAssertEqual(entity.expenseDescription, "Farmácia")
        XCTAssertEqual(entity.categoryRawValue, Category.health.rawValue)
    }

    func testPopulate_withAIDecision_encodesData() {
        guard let context else {
            XCTFail("Context cannot be nil")
            return
        }
        let decision = TestFixtures.makeAIDecision()
        let expense = TestFixtures.makeExpense(aiDecision: decision)
        let entity = ExpenseEntity(context: context)

        ExpenseMapper.populate(entity: entity, from: expense)

        XCTAssertNotNil(entity.aiDecisionData)
    }
}
