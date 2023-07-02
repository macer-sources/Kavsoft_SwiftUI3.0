//
//  TaskMangement.swift
//  KavsoftDemo
//
//  Created by tao on 2023/2/24.
//

import SwiftUI

// TODO: 无内容就查看数据时间 
struct TaskMangement: View {
    @ObservedObject var viewModel = TaskViewModel.init()
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    // MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        // TODO: 顶部周segment contorl 区域
                        CalendarWeekView().environmentObject(viewModel)
                        
                        // TODO: 数据内容区域
                        TasksView().environmentObject(viewModel)
                    }
                } header: {
                    HeaderView()
                }

            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}






struct TaskMangement_Previews: PreviewProvider {
    static var previews: some View {
        TaskMangement()
    }
}
