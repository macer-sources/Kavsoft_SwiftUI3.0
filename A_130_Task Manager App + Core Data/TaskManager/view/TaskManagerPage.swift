//
//  TaskManagerPage.swift
//  KavsoftDemo
//
//  Created by work on 3/8/23.
//

import SwiftUI

struct TaskManagerPage: View {
    @ObservedObject private var viewModel = TaskManagerViewModel()
    
    @Environment(\.self) var env
    
    // MARK: Fetching Task
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut)
    var tasks:FetchedResults<Task>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading,spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here`s Update Today.")
                        .font(.title2.bold())
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                
                CustomSegmentedBar().environmentObject(viewModel)
                    .padding(.top, 5)
                
                // MARK: Task View
                // later will come
                TaskView()
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            // MARK: Add Button
            Button {
                withAnimation {
                    viewModel.openEditTask.toggle()
                }
            } label: {
                Label{
                    Text("Add Tesk")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in:Capsule())
            }
            // MARK: Linear gradient BG
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7)
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $viewModel.openEditTask, onDismiss: {
            viewModel.resetTaskData()
        }, content: {
            AddNewTask().environmentObject(viewModel)
        })
        
    }

}

extension TaskManagerPage {
    @ViewBuilder
    func TaskView() -> some View {
        LazyVStack(spacing: 12) {
            ForEach(tasks) { task in
                _TaskCardView(task: task)
            }
        }
        .padding(.top, 20)
    }
}

extension TaskManagerPage {
    @ViewBuilder
    func _TaskCardView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }
                
                Spacer()
                
                // MARK: Edit button only for Non Completed tasks
                if !task.isCompleted {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }

                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom,spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)

                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted {
                    Button {
                        // MARK: Updating Core Data
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                        
                    } label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }

                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
}




struct TaskManagerPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagerPage()
    }
}
