//
//  TaskManagerViewModel.swift
//  KavsoftDemo
//
//  Created by work on 3/8/23.
//

import SwiftUI
import CoreData

class TaskManagerViewModel: ObservableObject {
   @Published var currentTab = "Today"
    
    
    // MARK: New Task Properties
    @Published var openEditTask: Bool = false
    
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    
    
    @Published var showDatePicker: Bool = false
}

extension TaskManagerViewModel {
    func addTask(context: NSManagedObjectContext) -> Bool {
        let task = Task(context: context)
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    // MARK: Reset task data
    func resetTaskData() {
        taskType = "Basic"
        taskTitle = "Yellow"
        taskColor = ""
        taskDeadline = Date()
    }
}
