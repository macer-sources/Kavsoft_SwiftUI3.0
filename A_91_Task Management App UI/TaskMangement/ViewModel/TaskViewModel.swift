//
//  TaskViewModel.swift
//  KavsoftDemo
//
//  Created by tao on 2023/2/24.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    // smmple tasks
    @Published var storedTasks:[Task]  = [
        Task.init(title: "Meeting", description: "Discuss team task for the day", date: .init(timeIntervalSince1970: 1677232721)),
        Task.init(title: "Icon set", description: "Edit icons for team task for next weak", date: .init(timeIntervalSince1970: 1641649097)),
        Task.init(title: "Prototype", description: "Make and send prototype", date: .init(timeIntervalSince1970: 1677232821)),
        Task.init(title: "Check asset", description: "Start checking the assets", date: .init(timeIntervalSince1970: 1641652697)),
        Task.init(title: "Team party", description: "Make fun with team mates", date: .init(timeIntervalSince1970: 1641661897))
    ]
    
    // MARK: current Week Days
    @Published var currentWeek:[Date] = []
    
    // MARK: current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Tasks
    @Published var filteredTasks:[Task]?
    
    
    // MARK: Intializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
}

extension TaskViewModel {
    // TODO: 当周日期
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week  = calendar.dateInterval(of: .weekOfMonth, for: today)
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(bySetting: .day, value: day, of: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
}


extension TaskViewModel {
    // TODO: current data
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.date, inSameDayAs: self.currentDay)
            }.sorted { task1, task2 in
                task2.date < task1.date
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
            
        }
    }
}


extension TaskViewModel {
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

extension TaskViewModel {
    // MARK: - checking if current Date is Today
    func isToday(date: Date) -> Bool{
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
}


extension TaskViewModel {
    // MARK: checking if the current hour is task hour
    func isCurrentHour(date:Date) -> Bool {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
