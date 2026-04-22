//
//  ExpenseRepositoryProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Contrato para qualquer backend de armazenamento que gerencia registros de `Expense`
///
/// A camada de `Domain` depende apenas deste protocolo afim de manter a testabilidade e ser agnóstico ao tipo de armazenamento.
/// Todos os métodos são `async throws` para dar suporte a armazenamento local ou sync remoto sem alteração do contrato
/// /// @mockable
protocol ExpenseRepositoryProtocol {
    /// Persiste uma nova despesa
    /// - Throws: Se a persistência falhar
    func save(_ expense: Expense) async throws

    /// Retorna todas as despesas armazenadas, não filtradas e não classificadas
    func fetchAll() async throws -> [Expense]

    /// Retorna despesas filtradas pelos critérios especificados em `ExpenseFilter`
    func fetch(filter: ExpenseFilter) async throws -> [Expense]

    /// Retorna uma despesa com o id fornecido, ou `nil` se não encontrar
    func fetch(id: UUID) async throws -> Expense?

    /// Atualiza uma despesa específica
    /// - Throws: Se uma despesa não existir ou falhar na atualização
    func update(_ expense: Expense) async throws

    /// Remove uma despesa armazenada
    /// - Throws: Se a despesa não existir ou a exclusão falhar
    func delete(id: UUID) async throws

    /// Retorna todas as despesas pendentes de classificação onde `isCategorizationPending == true`
    func fetchPendingCategorization() async throws -> [Expense]
}
