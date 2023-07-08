//
//  ExpenseCardView.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/8/23.
//

import SwiftUI

struct ExpenseCardView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    var isFilter: Bool = false
    var body: some View {
        _ExpenseCardView()
    }
}

// MARK: Expense Gradient Cardview
extension ExpenseCardView {
    @ViewBuilder
    func _ExpenseCardView() -> some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    .linearGradient(colors: [
                        Color("gradient1"),
                        Color("gradient2"),
                        Color("gradient3")
                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                )
            
            
            VStack(spacing: 15) {
                VStack(spacing: 15) {
                    // MARK: Currently going month date string
                    Text(isFilter ? viewModel.contvertDateToString() : viewModel.currentMonthDateString())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    // MARK: Current Month Expenses Price
                    Text(viewModel.convertExpensesToCurrency(expenses: viewModel.expenses))
                        .font(.system(size: 35, weight: .bold))
                        .lineLimit(1)
                        .padding(.bottom, 5)
                }
                .offset(y: -10)
                
                HStack(spacing: 15) {
                    Image(systemName: "arrow.down")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                        .background {
                            Circle()
                                .fill(.white.opacity(0.7))
                        }
                    
                    VStack(alignment: .leading,spacing: 4) {
                        Text("Income")
                            .font(.caption)
                            .opacity(0.7)
                        
                        Text(viewModel.convertExpensesToCurrency(expenses: viewModel.expenses, type: .income))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Image(systemName: "arrow.up")
                        .font(.caption.bold())
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                        .background {
                            Circle()
                                .fill(.white.opacity(0.7))
                        }
                    
                    VStack(alignment: .leading,spacing: 4) {
                        Text("Expenses")
                            .font(.caption)
                            .opacity(0.7)
                        
                        Text(viewModel.convertExpensesToCurrency(expenses: viewModel.expenses, type: .income))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }
                .padding(.horizontal)
                .padding(.trailing)
                .offset(y: 15)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            
            
        }
        .frame(height: 220)
        .padding(.top)
    }
}


struct ExpenseCardView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCardView().environmentObject(ExpenseViewModel())
    }
}
