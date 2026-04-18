//
//  CoreDataStack.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import CoreData

/// Configura `NSPersistentContainer` para o app, de forma a envolver o container no próprio app para injetá-lo via `AppContainer` ao invés de inicializa-lo no `AppDelegate`/
/// Além de suportar armazenamento em memória para testes e tratar erros de carregamento.
/// ## Nos testes
/// let stack = try CoreDataStack(inMemory: true)
/// let repo = CoreDataExpenseRepository(context: stack.viewContext)
/// ```
final class CoreDataStack {
    // MARK: - Properties
    private let container: NSPersistentContainer

    /// Uso do contexto para leituras na thread principal
    /// Para escrita, os repositórios utilizam `perform(_:)` para ficar fora da thread principal
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Init
    init(inMemory: Bool = false) throws {
        container = NSPersistentContainer(name: "AISmartExpenseAnalyzer")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }

        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        if let error = loadError {
            throw error
        }

        // Aplica automaticamente mudanças do contexto em background ao contexto visualizado
        container.viewContext.automaticallyMergesChangesFromParent = true

        // Configura a ultima escrita como principal
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Background Context

    /// Cria um novo contexto em background para operações de escrita
    /// Mudanças salvas são automaticamente megeadas no `viewContext`
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}
