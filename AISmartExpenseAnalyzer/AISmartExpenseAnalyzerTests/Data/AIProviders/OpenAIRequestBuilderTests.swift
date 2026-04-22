//
//  OpenAIRequestBuilderTests.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 22/04/26.
//

import XCTest
@testable import AISmartExpenseAnalyzer

final class OpenAIRequestBuilderTests: XCTestCase {
    func testBuild_setsCorrectHTTPData() throws {
        let request = try OpenAIRequestBuilder.build(
            description: "Almoço",
            amount: 35,
            apiKey: "test-key"
        )
        
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer test-key")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.url?.host, "api.openai.com")
        XCTAssertNotNil(request.httpBody)
    }
}
