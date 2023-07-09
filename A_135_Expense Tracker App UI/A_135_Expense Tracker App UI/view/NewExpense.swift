//
//  NewExpense.swift
//  A_135_Expense Tracker App UI
//
//  Created by work on 7/8/23.
//

import SwiftUI

struct NewExpense: View {
    
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.self) var env
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text("Add Expense")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.5)
                
                // MARK: Custom TextField
                if let symbol = viewModel.convertNumberToPrice(value: 0).first {
                    TextField("0", text: $viewModel.amount)
                        .font(.system(size: 35))
                        .foregroundColor(Color("gradient2"))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            Text(viewModel.amount == "" ? "0" : viewModel.amount)
                                .font(.system(size: 35))
                                .opacity(0)
                                // 为什么创建一个 Text 是因为 overlay 这个符号需要一个载体才行
                                .overlay(alignment: .leading) {
                                    Text(String(symbol))
                                        .opacity(0.5)
                                        .offset(x: -15, y: 5)
                                }
                        }
                        .background {
                            Capsule()
                                .fill(.white)
                        }
                        .padding(.horizontal)
                }
                
                
                // MARK: Custom Labels
                Label {
                    TextField("Remark", text: $viewModel.remark)
                } icon: {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                }
                .padding(.top, 25)

                Label {
                    DatePicker("", selection: $viewModel.date,in: Date.distantPast...Date(), displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                } icon: {
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                }
                .padding(.top, 5)

                
                Label {
                    CustomsCheckBoxs()
                } icon: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                }
                .padding(.top, 5)
                
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
            // MARK: Save Button
            Button {
                viewModel.saveData()
                env.dismiss()
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill (
                                LinearGradient(colors: [
                                   Color("gradient1"),
                                   Color("gradient2"),
                                   Color("gradient3")
                                ], startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    .disabled(viewModel.remark == "" || viewModel.type == .all || viewModel.amount == "")
                    .opacity(viewModel.remark == "" || viewModel.type == .all || viewModel.amount == "" ? 0.6 : 1)
            }

            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("bg")
                .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            // MARK: Close Button
            Button {
                env.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding()

        }
    }
}


extension NewExpense {
    @ViewBuilder
    func CustomsCheckBoxs() -> some View {
        HStack(spacing: 10) {
            ForEach([ExpenseType.expense, ExpenseType.income], id: \.self) { type in
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.black, lineWidth: 2)
                        .opacity(0.5)
                        .frame(width: 20, height: 20)
                        
                    if viewModel.type == type {
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundColor(.green)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.type = type
                }
                
                Text(type.rawValue.capitalized)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .opacity(0.7)
                    .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
    }
}




struct NewExpense_Previews: PreviewProvider {
    static var previews: some View {
        NewExpense()
            .environmentObject(ExpenseViewModel())
    }
}
