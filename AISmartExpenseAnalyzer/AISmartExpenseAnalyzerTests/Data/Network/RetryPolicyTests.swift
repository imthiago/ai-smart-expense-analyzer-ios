//
//  RetryPolicyTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class RetryPolicyTests: XCTestCase {
    private var sut: RetryPolicy?

    override func setUp() {
        sut = RetryPolicy(maxAttempts: 3, baseDelay: 0)
    }

    override func tearDown() {
        sut = nil
    }

    func testExecute_successOnFirstAttempt_returnsValue() async throws {
        var callCount = 0
        let result = try await sut?.execute {
            callCount += 1
            return "success"
        }
        XCTAssertEqual(result, "success")
        XCTAssertEqual(callCount, 1)
    }

    func testExecute_failsOnFirstThenSucceeds_retriesAndReturnsValue() async throws {
        var callCount = 0
        let result = try await sut?.execute {
            callCount += 1
            if callCount < 2 { throw AIProviderError.networkUnavailable }
            return 42
        }
        XCTAssertEqual(result, 42)
        XCTAssertEqual(callCount, 2)
    }

    func testExecute_exhaustsAllAttempts_throwsRetriesExhausted() async {
        do {
            _ = try await sut?.execute { throw AIProviderError.networkUnavailable }
            XCTFail("expected retriesExhausted")
        } catch AIProviderError.retriesExhausted {
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testExecute_unauthorizedError_doesNotRetry() async {
        var callCount = 0
        do {
            _ = try await sut?.execute {
                callCount += 1
                throw AIProviderError.unauthorized
            }
        } catch AIProviderError.unauthorized {
            XCTAssertEqual(callCount, 1)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
