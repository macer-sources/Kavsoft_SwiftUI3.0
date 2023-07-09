//
//  ExpenseViewModel.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/6/23.
//

import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses:[Expense] = sample_expenses
    
    
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    @Published var currentMonthStartDate: Date = .now
    
    // MARK: DetailsView Properties
    @Published var tabName: ExpenseType = .expense
    @Published var showFilterView: Bool = false 
    
    // MARK: New Expense Properties
    @Published var addNewExpense: Bool = false
    @Published var amount: String = ""
    @Published var type: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var remark: String = ""
    
    
    init() {
        // MARK: Fetching current month starting date
        let calender = Calendar.current
        
        let components = calender.dateComponents([.year, .month], from: Date())
        startDate = calender.date(from: components)!
        currentMonthStartDate = calender.date(from: components)!
    }
}


extension ExpenseViewModel {
    // MARK: Fetching current month date string
    func currentMonthDateString() -> String {
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + "-" + Date().formatted(date: .abbreviated, time: .omitted)
    }
}


extension ExpenseViewModel {
    func convertExpensesToCurrency(expenses:[Expense], type: ExpenseType = .all) -> String {
        var value: Double = 0
        value = expenses.reduce(0, { partialResult, expense in
            return partialResult + (expense.type == .income ? expense.amount : -expense.amount)
        })
        
       return convertNumberToPrice(value: value)
    }
}


extension ExpenseViewModel {
    // MARK: Converting number to price
    func convertNumberToPrice(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: value)) ?? "$0.00"
    }
}


// MARK: Converting selected dates to string
extension ExpenseViewModel {
    func contvertDateToString() -> String {
        return startDate.formatted(date: .abbreviated, time: .omitted) + "-" + endDate.formatted(date: .abbreviated, time: .omitted)
    }
}


extension ExpenseViewModel {
    // MARK: Clearing All Data
    func clearData() {
        date = Date()
        type = .all
        remark = ""
        amount = ""
    }
    
    func saveData() {
        debugPrint("Save")
    }
}
