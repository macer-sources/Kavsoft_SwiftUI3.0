//
//  Habit_Tracker_AppApp.swift
//  Habit Tracker App
//
//  Created by work on 3/11/23.
//

import SwiftUI

@main
struct Habit_Tracker_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
