//
//  Home.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/6/23.
//

import SwiftUI

struct Home: View {
    @StateObject var viewModel = ExpenseViewModel()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                HStack(spacing: 15) {
                    VStack(alignment: .leading,spacing: 4) {
                        Text("Welcome")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("iJustine")
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    NavigationLink {
                        FilteredDetailView().environmentObject(viewModel)
                    } label: {
                        Image(systemName: "hexagon.fill")
                            .foregroundColor(.gray)
                            .overlay(content: {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .padding(7)
                            })
                            .frame(width: 40, height: 40)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }

                }
                
                ExpenseCardView().environmentObject(viewModel)
                TransactionsView()
            }
            .padding()
        }
        .ignoresSafeArea(.all,edges: [])
        .background {
            Color("bg")
                .ignoresSafeArea()
        }
    }
}


// MARK: Transactions View
extension Home {
    @ViewBuilder
    func TransactionsView() -> some View {
        VStack(spacing: 15) {
            Text("Transactions")
                .font(.title2.bold())
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            ForEach(sample_expenses) { expense in
                // MARK: Transactions Card Item
                TransactionsCardView(expense: expense).environmentObject(viewModel)
            }
        }
    }
}







struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
