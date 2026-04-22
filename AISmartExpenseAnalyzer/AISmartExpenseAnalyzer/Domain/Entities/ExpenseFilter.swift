//
//  ExpenseFilter.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

struct ExpenseFilter: Equatable {
    var category: Category?
    var startDate: Date?
    var endDate: Date?
    var minAmount: Decimal?
    var maxAmount: Decimal?
    var searchText: String?
    
    static let empty = ExpenseFilter()

    var isEmpty: Bool {
        category == nil
            && startDate == nil
            && endDate == nil
            && minAmount == nil
            && maxAmount == nil
            && (searchText == nil) || searchText?.isEmpty == true
    }
}
