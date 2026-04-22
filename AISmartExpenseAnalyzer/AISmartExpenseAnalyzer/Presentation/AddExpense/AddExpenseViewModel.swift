//
//  AddExpenseViewModel.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

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

    var onStateChanged: ((State) -> Void)?
    var onFormValidChanged: ((Bool) -> Void)?

    private(set) var state: State = .idle {
        didSet { onStateChanged?(state) }
    }

    private(set) var isFormValid: Bool = false {
        didSet {
            guard isFormValid != oldValue else { return }
            onFormValidChanged?(isFormValid)
        }
    }

    var amountText: String = "" { didSet { revalidate() } }
    var descriptionText: String = "" { didSet { revalidate() } }
    var date: Date = .init()

    // MARK: - Coordinator Callbacks
    var onDismiss: (() -> Void)?
    var onExpenseAdded: ((Expense) -> Void)?

    // MARK: - Dependencies
    private let addExpenseUseCase: AddExpenseUseCaseProtocol

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

    private func revalidate() {
        let normalized = amountText.replacingOccurrences(of: ".", with: ",")
        guard let value = Decimal(string: normalized), value > 0 else {
            isFormValid = false
            return
        }

        isFormValid = !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
