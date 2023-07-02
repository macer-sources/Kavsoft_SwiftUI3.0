//
//  TaskManagerPage.swift
//  KavsoftDemo
//
//  Created by work on 3/8/23.
//

import SwiftUI

struct TaskManagerPage: View {
    @ObservedObject private var viewModel = TaskManagerViewModel()
    
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

struct TaskManagerPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagerPage()
    }
}
