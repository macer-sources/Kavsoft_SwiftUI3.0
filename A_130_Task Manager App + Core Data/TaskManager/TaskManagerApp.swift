//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Kan Tao on 2023/3/13.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskManagerPage()
                    .navigationTitle("Task Manager")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
