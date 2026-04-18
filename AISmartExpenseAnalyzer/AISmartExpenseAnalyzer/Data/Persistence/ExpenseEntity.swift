//
//  ExpenseEntity.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import CoreData

/// Objeto gerenciado pelo CoreData que representa uma despesa persistida.
///
/// `codeGenerationType="none"` foi definido no modelo para que o Xcode não auto-gere uma classe conflitante.
/// Todas as propriedades mapeiam `1-para-1` para os atributos definidos em `AISmartExpenseAnalyzer.xcdatamodel`
///
/// A conversão Domain <-> CoreData é tratada no `ExpenseMapper` que não tem lógica de negócio
///
@objc(ExpenseEntity)
final class ExpenseEntity: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var amount: NSDecimalNumber
    @NSManaged var expenseDescription: String?
    @NSManaged var date: Date?
    @NSManaged var categoryRawValue: String?
    @NSManaged var isCategorizationPending: Bool
    @NSManaged var aiDecisionData: Data?
}

extension ExpenseEntity {
    @nonobjc
    static func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }
}
