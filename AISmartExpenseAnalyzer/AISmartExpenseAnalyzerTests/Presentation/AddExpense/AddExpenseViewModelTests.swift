//
//  AddExpenseViewModelTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

@MainActor
final class AddExpenseViewModelTests: XCTestCase {
    private var useCaseMock: AddExpenseUseCaseProtocolMock?
    private var sut: AddExpenseViewModel?

    override func setUp() {
        useCaseMock = AddExpenseUseCaseProtocolMock()
        guard let useCaseMock else {
            XCTFail("Sut dependencies cannot be nil")
            return
        }
        sut = AddExpenseViewModel(addExpenseUseCase: useCaseMock)
    }

    override func tearDown() {
        useCaseMock = nil
        sut = nil
    }

    func testOnFormValidChanged_firesWhenValidityChanges() {
        let exp = expectation(description: "wait onFormValidChanged")
        sut?.onFormValidChanged = { _ in
            exp.fulfill()
        }

        sut?.amountText = "50"
        sut?.descriptionText = "any-description-text"

        wait(for: [exp], timeout: 1.0)
    }

    func testSubmitTapped_whenFormInvalid_doesNotCallUseCase() {
        sut?.amountText = ""
        sut?.submitTapped()
        XCTAssertEqual(useCaseMock?.executeCallCount, 0)
    }

    func testSubmitTapped_whenFormValid_setsLoadingState() {
        let exp = expectation(description: "wait for state")
        sut?.onStateChanged = { state in
            if state == .loading {
                exp.fulfill()
            }
        }

        useCaseMock?.executeHandler = { _, _, _ in
            try await Task.sleep(nanoseconds: 50_000_000)
            return TestFixtures.makeExpense()
        }

        sut?.amountText = "10"
        sut?.descriptionText = "any-description-text"
        sut?.submitTapped()

        wait(for: [exp], timeout: 2.0)
    }
}
