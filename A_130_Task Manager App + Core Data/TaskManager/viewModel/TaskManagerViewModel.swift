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
    
    
    
    @Published var editTask: Task?
    
}

extension TaskManagerViewModel {
    func addTask(context: NSManagedObjectContext) -> Bool {
        // MARK: Updating existing data in core data
        var task = Task.init(context: context)
        if let editTask = editTask {
            task = editTask
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
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


extension TaskManagerViewModel {
    // MARK: if edit task is available then setting exisiting data
    func setupTask () {
        if let editTask = editTask {
            taskTitle = editTask.title ?? ""
            taskColor = editTask.color ?? "Yellow"
            taskDeadline = editTask.deadline ??  Date()
            taskType = editTask.type ?? "Basic"
        }
    }
}
