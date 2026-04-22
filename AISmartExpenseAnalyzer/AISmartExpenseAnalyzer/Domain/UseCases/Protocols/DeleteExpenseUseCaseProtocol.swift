//
//  DeleteExpenseUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// @mockable
protocol DeleteExpenseUseCaseProtocol {
    /// Remove a despesa com o id fornecido do armazenamento
    /// - Throws: `RepositoryError.notFound` se nenhuma despesa correspondente existir
    func execute(id: UUID) async throws
}
