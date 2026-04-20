//
//  Category+Presentation.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

extension Category {
    var color: UIColor {
        switch self {
        case .food:
            return .systemOrange
        case .transport:
            return .systemBlue
        case .health:
            return .systemGreen
        case .entertainment:
            return .systemPurple
        case .shopping:
            return .systemPink
        case .utilities:
            return .systemYellow
        case .other:
            return .systemGray
        }
    }
}

extension AddExpenseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Please enter a valid amount greater than zero."
        case .emptyDescription:
            return "Please add a description."
        case .futureDate:
            return "The date cannot be in the future."
        }
    }
}
