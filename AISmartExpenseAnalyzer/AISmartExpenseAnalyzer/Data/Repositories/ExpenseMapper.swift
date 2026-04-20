//
//  ExpenseMapper.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import CoreData
import Foundation

/// Mapper responsável por converter entidade de `Domain` `Expense` e o objeto `CoreData` `ExpenseEntity
/// Objetivo desse mapper ter sido criado, é manter a lógica isolada para que camada de `Domain` nunca importe `CoreData`
/// Possibilitar que a camada de persistência seja agnóstica ao armazenamento utilizado
enum ExpenseMapper {
    // MARK: - CoreData -> Domain

    /// Converte um objeto do `CoreData` para uma entidade de `Domain` `Expense`
    /// - Throws: `MappingError.missingRequiredField` se um atributo não opcional não for informado
    static func toDomain(_ entity: ExpenseEntity) throws -> Expense {
        guard let id = entity.id else {
            throw MappingError.missingRequiredField("id")
        }

        guard let date = entity.date else {
            throw MappingError.missingRequiredField("date")
        }

        let category = Category(rawValue: entity.categoryRawValue ?? "") ?? .other
        let description = entity.expenseDescription ?? ""
        // TODO: Tratar force unwrap
        let amount = entity.amount!.decimalValue

        var aiDecision: AIDecision?
        if let data = entity.aiDecisionData {
            aiDecision = try? JSONDecoder().decode(AIDecision.self, from: data)
        }

        return .init(
            id: id,
            amount: amount,
            description: description,
            date: date,
            category: category,
            aiDecision: aiDecision,
            isCategorizationPending: entity.isCategorizationPending
        )
    }

    // MARK: - Domain -> CoreData

    /// Popula um objeto CoreData a partir de um objeto de `Domain`
    static func populate(entity: ExpenseEntity, from expense: Expense) {
        entity.id = expense.id
        entity.amount = NSDecimalNumber(decimal: expense.amount)
        entity.expenseDescription = expense.description
        entity.date = expense.date
        entity.categoryRawValue = expense.category.rawValue
        entity.isCategorizationPending = expense.isCategorizationPending
        entity.aiDecisionData = try? JSONEncoder().encode(expense.aiDecision)
    }
}

// MARK: - Errors
extension ExpenseMapper {
    enum MappingError: Error, LocalizedError {
        case missingRequiredField(String)

        var errorDescription: String? {
            switch self {
            case .missingRequiredField(let field):
                return "CoreData entity is missing required field: '\(field)'"
            }
        }
    }
}
