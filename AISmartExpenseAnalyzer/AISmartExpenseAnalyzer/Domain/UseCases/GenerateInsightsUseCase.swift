//
//  GenerateInsightsUseCase.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

final class GenerateInsightsUseCase: GenerateInsightsUseCaseProtocol {
    // MARK: - Configuration

    /// Número de vezes que uma determinada descrição de aparecer para ser considerada recorrente
    private let recurringThreshold: Int

    // MARK: - Init
    init(recurringThreshold: Int = 3) {
        self.recurringThreshold = recurringThreshold
    }

    // MARK: - GenerateInsightsUseCaseProtocol
    func execute(for expenses: [Expense]) async throws -> [Insight] {
        guard !expenses.isEmpty else { return [] }

        var insights: [Insight] = []

        if let dominant = detectDominantCategory(in: expenses) {
            insights.append(dominant)
        }

        insights.append(contentsOf: detectRecurringExpenses(in: expenses))

        return insights
    }
}

// MARK: - Dominant Category Rule
extension GenerateInsightsUseCase {
    private func detectDominantCategory(in expenses: [Expense]) -> Insight? {
        let totals = Dictionary(grouping: expenses, by: \.category)
            .mapValues { group in group.reduce(Decimal.zero) { $0 + $1.amount} }

        guard let (topCategory, topAmount) = totals.max(by: { $0.value < $1.value}) else {
            return nil
        }

        let relevantIds = expenses
            .filter { $0.category == topCategory }
            .map(\.id)

        let formattedAmount = topAmount.formatted(.currency(code: "BRL"))

        return .init(type: .dominantCategory(topCategory),
                     message: "Você gastou mais com \(topCategory.displayName) neste período (\(formattedAmount)).",
                     relevantExpenseIds: relevantIds)
    }
}

// MARK: - Recurring Expenses Rule
extension GenerateInsightsUseCase {
    private func detectRecurringExpenses(in expenses: [Expense]) -> [Insight] {
        let groups = Dictionary(grouping: expenses) { expense -> String in
            expense.description.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return groups
            .filter { $0.value.count >= recurringThreshold }
            .map { _, group in
                let displayName = group.first?.description ?? ""
                let count = group.count
                return .init(type: .recurringExpense(description: displayName),
                             message: "\"\(displayName)\" aparece \(count) vezes — possível despesa recorrente.",
                             relevantExpenseIds: group.map(\.id))
            }
    }
}
