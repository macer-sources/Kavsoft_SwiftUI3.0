//
//  Pomodoro_Focus_Timer_AppApp.swift
//  Pomodoro Focus Timer App
//
//  Created by work on 3/12/23.
//

import SwiftUI

@main
struct Pomodoro_Focus_Timer_AppApp: App {
    @StateObject private var viewModel = FocusTimeViewModel()
    
    @Environment(\.scenePhase) var phase
    
    @State var lastActiveTimeStamp = Date()
    
    var body: some Scene {
        WindowGroup {
            HomePage().environmentObject(viewModel)
        }
        .onChange(of: phase) { newValue in
            if newValue == .background {
                lastActiveTimeStamp = Date()
            }
            if newValue == .active {
                // Mark: FINDING the difference
                let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                if viewModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                    viewModel.isStarted = false
                    viewModel.totalSeconds = 0
                    viewModel.isFinished = true
                }else {
                    viewModel.totalSeconds -= Int(currentTimeStampDiff)
                }
            }
        }
    }
}
