//
//  AddNewTask.swift
//  TaskManager
//
//  Created by work on 7/2/23.
//

import SwiftUI

struct AddNewTask: View {
    @EnvironmentObject var viewModel: TaskManagerViewModel
    
    @Environment(\.self) var env
    @Namespace var animation
    var body: some View {
        VStack(spacing: 12) {
            Text("Edit Task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
            
            
            // MARK: Colors
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: Sample Card Colors
                let colors:[String] = ["Yellow","Green","Blue","Purple","Red","Orange"]
                
                HStack(spacing: 15) {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background {
                                if viewModel.taskColor == color {
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                viewModel.taskColor = color
                            }
                    }
                }
                .padding(.top, 20)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            
            Divider()
                .padding(.vertical, 10)
            
            // MARK: Task Deadline
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(viewModel.taskDeadline.formatted(date: .abbreviated, time: .omitted) + "," + viewModel.taskDeadline.formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,10)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    viewModel.showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }

            }
            
            
            Divider()
            
            //MARK: Task Title
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $viewModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top,10)
            }

            
            Divider()
            
            // MARK: Type
            let taskTypes:[String] = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 12) {
                    ForEach(taskTypes, id: \.self) { type in
                        Text(type)
                            .font(.callout)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(viewModel.taskType == type ?  .white : .black)
                            .background {
                                if viewModel.taskType == type {
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                }else {
                                    Capsule()
                                        .strokeBorder(.black)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation {
                                    viewModel.taskType = type
                                }
                            }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.top, 10)
            
            Divider()
            
            // MARK: Save Button
            Button {
                if  viewModel.addTask(context: env.managedObjectContext) {
                    env.dismiss()
                }
            } label: {
                Text("Save Task")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.black)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .disabled(viewModel.taskTitle == "")
            .opacity(viewModel.taskTitle == "" ? 0.6 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack {
                if viewModel.showDatePicker {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.showDatePicker = false
                        }
                    
                    DatePicker("", selection: $viewModel.taskDeadline, in: Date.now...Date.distantFuture)
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 12))
                        .padding()
                }
            }
            .animation(.easeInOut, value: viewModel.showDatePicker)
        }
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask().environmentObject(TaskManagerViewModel())
    }
}
