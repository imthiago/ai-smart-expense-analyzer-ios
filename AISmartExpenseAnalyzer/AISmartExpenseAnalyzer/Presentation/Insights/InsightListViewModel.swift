//
//  InsightListViewModel.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

@MainActor
final class InsightListViewModel {
    // MARK: - Published States
    @Published private(set) var insights: [Insight] = []
    @Published private(set) var isLoading = false

    // MARK: - Dependencies
    private let expenses: [Expense]
    private let generateInsightsUseCase: GenerateInsightsUseCaseProtocol

    // MARK: - Init
    init(
        expenses: [Expense],
        generateInsightsUseCase: GenerateInsightsUseCaseProtocol
    ) {
        self.expenses = expenses
        self.generateInsightsUseCase = generateInsightsUseCase
    }

    func viewDidLoad() {
        Task {
            await generateInsights()
        }
    }

    private func generateInsights() async {
        isLoading = true
        defer { isLoading = false }
        insights = (try? await generateInsightsUseCase.execute(for: expenses)) ?? []
    }
}
