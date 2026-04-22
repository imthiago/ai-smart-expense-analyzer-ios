//
//  CoreDataExpenseRepository.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import CoreData
import Foundation

final class CoreDataExpenseRepository: ExpenseRepositoryProtocol {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext

    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ expense: Expense) async throws {
        try await context.perform {
            let entity = ExpenseEntity(context: self.context)
            ExpenseMapper.populate(entity: entity, from: expense)
            try self.context.save()
        }
    }
    
    func fetchAll() async throws -> [Expense] {
        try await context.perform {
            let request = ExpenseEntity.fetchRequest()
            let entities = try self.context.fetch(request)
            return try entities.map { try ExpenseMapper.toDomain($0) }
        }
    }
    
    func fetch(filter: ExpenseFilter) async throws -> [Expense] {
        try await context.perform {
            let request = ExpenseEntity.fetchRequest()
            request.predicate = self.makePredicate(from: filter)
            let entities = try self.context.fetch(request)
            return try entities.map { try ExpenseMapper.toDomain($0) }
        }
    }
    
    func fetch(id: UUID) async throws -> Expense? {
        try await context.perform {
            let request = ExpenseEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            let entity = try self.context.fetch(request).first
            return try entity.map { try ExpenseMapper.toDomain($0) }
        }
    }
    
    func update(_ expense: Expense) async throws {
        try await context.perform {
            let request = ExpenseEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)
            request.fetchLimit = 1

            guard let entity = try self.context.fetch(request).first else {
                throw RepositoryError.notFound(expense.id)
            }

            ExpenseMapper.populate(entity: entity, from: expense)
            try self.context.save()
        }
    }
    
    func delete(id: UUID) async throws {
        try await context.perform {
            let request = ExpenseEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            guard let entity = try self.context.fetch(request).first else {
                throw RepositoryError.notFound(id)
            }

            self.context.delete(entity)
            try self.context.save()
        }
    }
    
    func fetchPendingCategorization() async throws -> [Expense] {
        try await context.perform {
            let request = ExpenseEntity.fetchRequest()
            request.predicate = NSPredicate(format: "isCategorizationPending == YES")
            let entities = try self.context.fetch(request)
            return try entities.map { try ExpenseMapper.toDomain($0) }
        }
    }
}

// MARK: - Predicate Constructor
extension CoreDataExpenseRepository {
    private func makePredicate(from filter: ExpenseFilter) -> NSPredicate? {
        guard !filter.isEmpty else { return nil }

        var predicates: [NSPredicate] = []

        if let category = filter.category {
            predicates.append(
                NSPredicate(format: "categoryRawValue == %@", category.rawValue)
            )
        }

        if let start = filter.startDate {
            predicates.append(
                NSPredicate(format: "date >= %@", start as NSDate)
            )
        }

        if let end = filter.endDate {
            predicates.append(
                NSPredicate(format: "date <= %@", end as NSDate)
            )
        }

        if let min = filter.minAmount {
            predicates.append(
                NSPredicate(format: "amount >= %@", NSDecimalNumber(decimal: min))
            )
        }

        if let max = filter.maxAmount {
            predicates.append(
                NSPredicate(format: "amount <= %@", NSDecimalNumber(decimal: max))
            )
        }

        if let text = filter.searchText, !text.isEmpty {
            predicates.append(
                NSPredicate(format: "expenseDescription CONTAINS[cd] %@", text)
            )
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}

// MARK: - Repository Errors
enum RepositoryError: Error, LocalizedError {
    case notFound(UUID)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Expense with id \(id) was not found in the store."
        }
    }
}
