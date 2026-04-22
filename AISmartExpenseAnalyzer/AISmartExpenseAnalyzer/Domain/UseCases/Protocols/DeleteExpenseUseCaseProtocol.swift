//
//  DeleteExpenseUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// @mockable
protocol DeleteExpenseUseCaseProtocol {
    func execute(id: UUID) async throws
}
