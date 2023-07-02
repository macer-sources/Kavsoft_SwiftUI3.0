//
//  TaskMangement.swift
//  KavsoftDemo
//
//  Created by tao on 2023/2/24.
//

import SwiftUI

struct TaskMangement: View {
    @ObservedObject var viewModel = TaskViewModel.init()
    @Namespace var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    // MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10) {
                            
                            ForEach(viewModel.currentWeek, id: \.self) { day in
                                VStack(spacing: 10) {
                                    Text(viewModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    Text(viewModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(viewModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(viewModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(viewModel.isToday(date: day) ? .white : .black)
                                
                                 // MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack{
                                        // MARK: method geometry effect
                                        if viewModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                        
                                        
                                       
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation {
                                        viewModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        TasksView()
                    }
                } header: {
                    HeaderView()
                }

            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

extension TaskMangement {
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            Button.init {
                
            } label: {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }


        }.padding()
            .padding(.top, getSafeArea().top)
            .background(Color.white)
    }
}



extension TaskMangement {
    func TasksView() -> some View {
        LazyVStack(spacing: 25) {
            
            if let tasks = viewModel.filteredTasks {
               
                if tasks.isEmpty {
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                }else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
                
            }else {
                // MARK: progress view
                ProgressView().offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        .onChange(of: viewModel.currentDay) { newValue in
            viewModel.filterTodayTasks()
        }
    }
}


extension TaskMangement {
    // MARK: Task Card View
    func TaskCardView(task: Task) -> some View {
        HStack.init(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(viewModel.isCurrentHour(date: task.date) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!viewModel.isCurrentHour(date: task.date) ? 0.8 : 1)
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            VStack{
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.title)
                            .font(.title2.bold())
                        Text(task.description)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }.hLeading()
                    
                    Text(task.date.formatted(date: .omitted, time: .shortened))
                }
                
                if viewModel.isCurrentHour(date: task.date) {
                    // MARK: Team Members
                    HStack(spacing: 0) {
                        HStack.init(spacing: -10) {
                            ForEach(["User1", "User2", "User3"], id: \.self) { user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
    //                                        .stroke(.black, lineWidth: 5)
                                    )
                            }
                        }
                        .hLeading()
                        
                        // MARK: Check Button
                        Button.init {
                            
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }

                        
                        
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(viewModel.isCurrentHour(date: task.date) ? .white : .black)
            .padding(viewModel.isCurrentHour(date: task.date) ? 15 : 0)
            .padding(.bottom, viewModel.isCurrentHour(date: task.date) ? 0 : 10)
            .hLeading()
            .background(Color.black.cornerRadius(25).opacity(viewModel.isCurrentHour(date: task.date) ? 1: 0))
        }.hLeading()
    }
}




// MARK: UI Design Helper functions
extension View {
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    //MARK: Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}




struct TaskMangement_Previews: PreviewProvider {
    static var previews: some View {
        TaskMangement()
    }
}
