//
//  InsightType+Presentation.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

extension InsightType {
    var symbolName: String {
        switch self {
        case .dominantCategory:  
            return "chart.bar.fill"
        case .recurringExpense:  
            return "repeat"
        case .spendingIncrease:  
            return "arrow.up.right"
        case .spendingDecrease:  
            return "arrow.down.right"
        case .custom:            
            return "lightbulb.fill"
        }
    }

    var color: UIColor {
        switch self {
        case .dominantCategory:
            return .systemIndigo
        case .recurringExpense:
            return .systemOrange
        case .spendingIncrease:
            return .systemRed
        case .spendingDecrease:
            return .systemGreen
        case .custom:
            return .systemYellow
        }
    }
}
