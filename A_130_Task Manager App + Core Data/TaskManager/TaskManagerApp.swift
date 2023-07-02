//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Kan Tao on 2023/3/13.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskManagerPage()
                    .navigationTitle("Task Manager")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
