//
//  Secrets.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

enum Secrets {
    static var openAIKey: String {
        ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
    }

    static var hasOpenAIKey: Bool {
        !openAIKey.isEmpty
    }
}
