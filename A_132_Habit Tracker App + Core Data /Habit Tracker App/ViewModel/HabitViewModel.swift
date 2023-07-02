//
//  HabitViewModel.swift
//  Habit Tracker App
//
//  Created by work on 3/11/23.
//

import SwiftUI
import CoreData
import NotificationCenter

class HabitViewModel: ObservableObject {

    
    @Published var addNewHabit: Bool = false
    
    
    
    
    @Published var title: String = ""
    @Published var habitColor: String = "Color-0"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    
    
    
    // MARK: Remainder Time Packer
    @Published var showTimePicker: Bool = false
    
    // MARK: Editing Habit
    @Published var editHabit: Habit?
    
    // MARK: Notification access status
    @Published var notificationAccess: Bool = false
    
    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
    
    init() {
        requestNotificationAccess()
    }
    
    
    
    // MARK: Adding Habit to Database
    func addHabit(context: NSManagedObjectContext) async -> Bool {
        var habit = Habit(context: context)
        if let editHabit = editHabit {
            habit = editHabit
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: editHabit.notificationDs ?? [])
        }
        habit.title = title
        habit.color = habitColor
        habit.weekDays = weekDays
        habit.isRemainderOn = isRemainderOn
        habit.remainderText = remainderText
        habit.notificationDate = remainderDate
        habit.notificationDs = []
        
        if isRemainderOn {
                // MARK: Scheduling Notification
            if let ids = try? await scheduleNotification() {
                habit.notificationDs = ids
                if let _ = try? context.save() {
                    return true
                }
            }
        }else {
            // MARK: Adding Data
            if let _ = try? context.save() {
                return true
            }
        }
        return false
    }
    
    // MARK: Adding Notification
    func scheduleNotification()async throws -> [String] {
        let content = UNMutableNotificationContent()
        content.title = "Habit Remainder"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default
        
        
        var notificationsIDs:[String] = []
        let calendar = Calendar.current
        let weekdaysSymbols:[String] = calendar.weekdaySymbols
        
        // MARK: Scheduling Notificaiton
        for weekDay in weekDays {
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: remainderDate)
            let min = calendar.component(.minute, from: remainderDate)
            let day = weekdaysSymbols.firstIndex { currentDay in
                return currentDay == weekDay
            } ??  -1
            
            guard day != -1 else {
                return  []
            }
            
            var components = DateComponents()
            components.hour = hour
            components.minute = min
            components.weekday = day + 1
            // MARK: this will trigger notification on each selected day
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            // MARK: notification request
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            try await UNUserNotificationCenter.current().add(request)
            
            notificationsIDs.append(id)
            
        }
        return notificationsIDs
    }
    
    
    // MARK: delete habit from datebase
    func deleteHabit(context: NSManagedObjectContext) -> Bool {
        guard let editHabit = editHabit else {
            return false
        }
        if editHabit.isRemainderOn {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: editHabit.notificationDs ?? [])
        }
        context.delete(editHabit)
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    
    
    // MARK: Restoring Edit Data
    func restoreEditData() {
        guard let editHabit = editHabit else {
            return
        }
        title = editHabit.title ?? ""
        habitColor = editHabit.color ?? "Color-1"
        weekDays = editHabit.weekDays ?? []
        isRemainderOn = editHabit.isRemainderOn
        remainderDate = editHabit.dateAdded ?? Date()
        remainderText = editHabit.remainderText ?? ""
    }
    
    func resetData() {
        title = ""
        habitColor = "Color-0"
        weekDays = []
        isRemainderOn = false
        remainderDate = Date()
        remainderText = ""
        editHabit = nil
    }
    
    
    // MARK:  Done Button Status
    func doneStatus () -> Bool {
        let remainderStatus = isRemainderOn ? remainderText == "" : false
        if title == "" || weekDays.isEmpty || remainderStatus {
            return false
        }
        return true
    }
}
