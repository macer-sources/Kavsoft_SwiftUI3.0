//
//  HomePage.swift
//  Habit Tracker App
//
//  Created by work on 3/11/23.
//

import SwiftUI

struct HomePage: View {
    
    
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut)
    var habits:FetchedResults<Habit>
    
    @StateObject var viewModel = HabitViewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Habits")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        
                    }label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                    }
                }
                .padding(.bottom, 10)
            
            
            ScrollView(habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(habits, id: \.id) {habit in
                        HabitCardView(habit)
                    }
                    
                    
                    Button {
                        viewModel.addNewHabit.toggle()
                    } label: {
                        Label {
                            Text("New habit")
                        } icon: {
                            Image(systemName: "plus.circle")
                        }
                        .foregroundColor(.white)
                        .font(.callout.bold())
                    }
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                }.padding(.vertical)
            }
        }
        //maxHeight 这里如果不是这个，就不会置顶了
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .sheet(isPresented: $viewModel.addNewHabit, onDismiss: {
            viewModel.resetData()
        }) {
            AddHabitPage().environmentObject(viewModel)
        }
    }
    
    
    
    
    
    @ViewBuilder
    func HabitCardView(_ habit: Habit) -> some  View {
        VStack(spacing: 6) {
            HStack {
                Text(habit.title ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Image(systemName: "bell.badge.fill")
                    .font(.callout)
                    .foregroundColor(Color(habit.color ?? "Color-0"))
                    .scaleEffect(0.9)
                    .opacity(habit.isRemainderOn ? 1 : 0)
                
                Spacer()
                
                let count = (habit.weekDays?.count ?? 0)
                Text(count == 7 ? "Everyday" : "\(count) times a week")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            
            // MARK: displaying current week and marking active dates of habit
            let calendar = Calendar.current
            let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())
            let symbols = calendar.weekdaySymbols
            let startDate = currentWeek?.start ?? Date()
            let activeWeekDays = habit.weekDays ?? []
            let activePlot = symbols.indices.compactMap { index -> (String, Date) in
                let currentDate = calendar.date(bySetting: .day, value: index, of: startDate)
                return (symbols[index], currentDate ?? Date())
            }
            
            HStack(spacing: 0) {
                ForEach(activePlot.indices, id: \.self) { index in
                    let item = activePlot[index]
                    VStack(spacing: 6) {
                        Text(item.0.prefix(3))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        let status = activeWeekDays.contains { day in
                            return day == item.0
                        }
                        
                        Text(getDate(date:item.1))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(Color(habit.color ?? "Color-1"))
                                    .opacity(status ? 1 : 0)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 15)
            
        }
        .padding(.vertical)
        .padding(.horizontal, 6)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("TFBG").opacity(0.5))
        }
        .onTapGesture {
            // MARK: Editing Habit
            viewModel.editHabit = habit
            viewModel.restoreEditData()
            viewModel.addNewHabit.toggle()
        }
    }
    
    
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: date)
    }
    
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage().preferredColorScheme(.dark)
    }
}
