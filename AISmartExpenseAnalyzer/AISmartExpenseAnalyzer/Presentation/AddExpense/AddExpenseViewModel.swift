//
//  AddExpenseViewModel.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Combine
import Foundation

@MainActor
final class AddExpenseViewModel {
    // MARK: - State
    enum State: Equatable {
        case idle
        case loading
        case success
        case failure(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var isFormValid = false
    @Published var amountText: String = ""
    @Published var descriptionText: String = ""
    @Published var date: Date = .init()

    // MARK: - Coordinator Callbacks
    var onDismiss: (() -> Void)?
    var onExpenseAdded: ((Expense) -> Void)?

    // MARK: - Dependencies
    private let addExpenseUseCase: AddExpenseUseCaseProtocol
    private var cancellabled = Set<AnyCancellable>()

    init(addExpenseUseCase: AddExpenseUseCaseProtocol) {
        self.addExpenseUseCase = addExpenseUseCase
    }

    func submitTapped() {
        guard isFormValid else { return }

        let normalized = amountText.replacingOccurrences(of: ",", with: ".")
        guard let amount = Decimal(string: normalized) else { return }

        state = .loading

        Task {
            do {
                let expense = try await addExpenseUseCase.execute(
                    amount: amount,
                    description: descriptionText,
                    date: date
                )
                state = .success
                onExpenseAdded?(expense)
            } catch {
                state = .failure(error.localizedDescription)
            }
        }
    }

    func cancelTapped() {
        onDismiss?()
    }

    private func bindValidation() {
        Publishers.CombineLatest($amountText, $descriptionText)
            .map { amount, description in
                let normalized = amount.replacingOccurrences(of: ",", with: ".")
                guard let value = Decimal(string: normalized), value > 0 else { return false }
                return !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .assign(to: &$isFormValid)
    }
}
