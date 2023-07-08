//
//  FilteredDetailView.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/6/23.
//

import SwiftUI

struct FilteredDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    @Namespace var animation
    var body: some View {
        VStack {
            NavigationBar()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ExpenseCardView(isFilter: true).environmentObject(viewModel)
                    SegmentedControl()
                        .padding(.top)
                    
                    // MARK: Currently filtered date with amount
                    VStack(spacing: 15) {
                        Text(viewModel.contvertDateToString())
                            .opacity(0.7)
                        Text(viewModel.convertExpensesToCurrency(expenses: viewModel.expenses, type: viewModel.tabName))
                            .font(.title.bold())
                            .opacity(0.9)
                            .animation(.none, value: viewModel.tabName)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                    }
                    .padding(.vertical, 20)
                    
                    
                    ForEach(viewModel.expenses.filter{$0.type == viewModel.tabName}) { expense in
                        TransactionsCardView(expense: expense)
                            .environmentObject(viewModel)
                    }
                    
                    
                }.padding()
            }
        }
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .background {
            Color("bg")
                .ignoresSafeArea()
        }
        .overlay {
            FilterView()
        }
    }
}

// MARK: navigation bar
extension FilteredDetailView {
    @ViewBuilder
    func NavigationBar() -> some View {
        HStack(spacing: 15) {
            // MARK: Back button
            Button.init {
                dismiss()
            } label: {
                Image(systemName: "arrow.backward.circle.fill")
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 40)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .shadow(color: .blue.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
            }
            
            Text("Transactions")
                .font(.title.bold())
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                viewModel.showFilterView = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.gray)
                    .overlay {
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .padding(7)
                    }
                    .frame(width: 40, height: 40)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .shadow(color: .blue.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
            }

            
        }
    }
}


// MARK: Custom Segmented Control
extension FilteredDetailView {
    @ViewBuilder
    func SegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach([ExpenseType.income, ExpenseType.expense], id: \.rawValue) { tab in
                Text(tab.rawValue.capitalized)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.tabName == tab ? .white : .black)
                    .opacity(viewModel.tabName == tab ? 1 : 0.7)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        // MARK: With matched animation
                        if viewModel.tabName == tab {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                LinearGradient(colors: [
                                    Color("gradient1"),
                                    Color("gradient2"),
                                    Color("gradient3")
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            viewModel.tabName = tab
                        }
                    }
            }
        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        }
    }
}



// MARK: Filter View
extension FilteredDetailView {
    @ViewBuilder func FilterView() -> some View {
        ZStack {
            Color.black.opacity(viewModel.showFilterView ? 0.25 : 0)
                .ignoresSafeArea()
            if viewModel.showFilterView {
                VStack(alignment: .leading,spacing: 10) {
                    Text("Start Date")
                        .font(.caption)
                        .opacity(0.7)
                    
                    DatePicker("", selection: $viewModel.startDate, in: Date.distantPast...Date(), displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                    
                    Text("End Date")
                        .font(.caption)
                        .opacity(0.7)
                        .padding(.top, 10)
                    
                    DatePicker("", selection: $viewModel.endDate, in: Date.distantPast...Date(), displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                }
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.showFilterView = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(5)
                    }

                }
                .padding()
            }
        }
        .animation(.easeInOut, value: viewModel.showFilterView)
    }
}

struct FilteredDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredDetailView()
            .environmentObject(ExpenseViewModel())
    }
}
