//
//  InsightListViewModel.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

@MainActor
final class InsightListViewModel {
    var onInsightsChanged: (([Insight]) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?

    private(set) var insights: [Insight] = [] {
        didSet { onInsightsChanged?(insights) }
    }

    private(set) var isLoading: Bool = false {
        didSet {
            guard isLoading != oldValue else { return }
            onLoadingChanged?(isLoading)
        }
    }

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
