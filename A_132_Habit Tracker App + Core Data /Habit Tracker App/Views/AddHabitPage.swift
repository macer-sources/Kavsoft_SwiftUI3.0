//
//  AddHabitPage.swift
//  Habit Tracker App
//
//  Created by work on 3/11/23.
//

import SwiftUI

struct AddHabitPage: View {
    
    @EnvironmentObject private var viewModel: HabitViewModel
    
    @Environment(\.self) var env
    
    var body: some View {
            
        NavigationStack {
            VStack(spacing: 15) {
                TextField("Title", text: $viewModel.title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                // MARK: Habit Color Picker
                HabitColorPickerView()
                
                Divider()
                
                // hiding if notification access is Rejected
                FrequencyView()
                    .opacity(viewModel.notificationAccess ? 1 : 0)
                

                RemainderView()
                    .opacity(viewModel.notificationAccess ? 1 : 0)
                
                HStack (spacing: 12) {
                    Label {
                        Text(viewModel.remainderDate.formatted(date: .omitted, time: .shortened))
                    }icon: {
                        Image(systemName: "clock")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6,style: .continuous))
                    .onTapGesture {
                        withAnimation {
                            viewModel.showTimePicker.toggle()
                        }
                    }
                    
                    TextField("Remainder Text", text: $viewModel.remainderText)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color("TFBG").opacity(0.4))
                        }
                }
                .frame(height: viewModel.isRemainderOn ? nil : 0)
                .opacity(viewModel.isRemainderOn ?  1 : 0)
            }
            .animation(.easeInOut, value: viewModel.isRemainderOn)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.editHabit != nil ? "Delete Habit" : "Add Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }.tint(.white)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewModel.deleteHabit(context: env.managedObjectContext) {
                            env.dismiss()
                        }
                    } label: {
                        Image(systemName: "trash")
                    }.tint(.red)
                        .opacity(viewModel.editHabit == nil ? 0 : 1)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            if await viewModel.addHabit(context: env.managedObjectContext) {
                                env.dismiss()
                            }
                        }
 
                    }.tint(.white)
                        .disabled(!viewModel.doneStatus())
                        .opacity(viewModel.doneStatus() ? 1 : 0.6)
                }
            }
        }
        .overlay {
            if viewModel.showTimePicker {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.showTimePicker.toggle()
                            }
                        }
                    
                    DatePicker("", selection: $viewModel.remainderDate, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("TFBG"))
                        }
                        .padding()
                }
            }
        }
    }
    
    
    
    @ViewBuilder
    func FrequencyView() -> some View {
        VStack(alignment: .leading,spacing: 6) {
            Text("Frequency")
                .font(.callout.bold())
            // TODO: 当间距固定的时候，内部元素可以自适应大小，
            HStack(spacing: 10) {
                let weekDays = Calendar.current.weekdaySymbols
                ForEach(weekDays, id: \.self) { day in
                    let index = viewModel.weekDays.firstIndex { value in
                        return value == day
                    } ?? -1
                    
                    Text(day.prefix(2))
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(index != -1 ? Color(viewModel.habitColor) : Color("TFBG").opacity(0.4))
                        }
                        .onTapGesture {
                            withAnimation {
                                if index != -1 {
                                    viewModel.weekDays.remove(at: index)
                                }else {
                                    viewModel.weekDays.append(day)
                                }
                            }
                        }
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    @ViewBuilder
    func HabitColorPickerView() -> some View {
        // TODO: 当不想固定设死间距时，可以不设，然后设置父级 frame 为 infinity， 内部固定大小元素，间距就会平均
        HStack(spacing: 0) {
            ForEach(0...7,id: \.self) { index in
                let color = "Color-\(index)"
                Circle()
                    .fill(Color(color))
                    .frame(width: 30, height: 30)
                    .overlay(content: {
                        if color == viewModel.habitColor {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                        }
                    })
                    .onTapGesture {
                        withAnimation {
                            viewModel.habitColor = color
                        }
                    }
                    .frame(maxWidth: .infinity)
            }
        }.padding(.vertical)
        
        
    }
    
    @ViewBuilder
    func RemainderView() -> some View {
        HStack {
            VStack(alignment: .leading,spacing: 6) {
                Text("Remainder")
                    .fontWeight(.semibold)
                Text("Just notification")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity,  alignment: .leading)
            
            Toggle(isOn: $viewModel.isRemainderOn) {
                
            }
            .labelsHidden()
        }
    }
}

struct AddHabitPage_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitPage()
            .environmentObject(HabitViewModel())
            .preferredColorScheme(.dark)
    }
}
