//
//  TasksView.swift
//  TaskMangement
//
//  Created by work on 7/2/23.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    
    var body: some View {
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

extension TasksView {
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


