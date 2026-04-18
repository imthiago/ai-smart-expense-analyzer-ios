//
//  Category.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

enum Category: String, CaseIterable, Codable, Equatable {
    case food           = "food"
    case transport      = "transport"
    case health         = "health"
    case entertainment  = "entertainment"
    case shopping       = "shopping"
    case utilities      = "utilities"
    case other          = "other"

    var displayName: String {
        switch self {
        case .food:             return "Food & Drinks"
        case .transport:        return "Transport"
        case .health:           return "Health"
        case .entertainment:    return "Entertainment"
        case .shopping:         return "Shopping"
        case .utilities:        return "Utilities"
        case .other:            return "Other"
        }
    }

    var symbolName: String {
        switch self {
        case .food:             return "fork.knife"
        case .transport:        return "car.fill"
        case .health:           return "heart.fill"
        case .entertainment:    return "tv.fill"
        case .shopping:         return "bag.fill"
        case .utilities:        return "bolt.fill"
        case .other:            return "square.grid.2x2.fill"
        }
    }
}
