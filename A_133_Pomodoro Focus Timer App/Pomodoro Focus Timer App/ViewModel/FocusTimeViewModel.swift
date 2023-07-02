//
//  FocusTimeViewModel.swift
//  Pomodoro Focus Timer App
//
//  Created by work on 3/12/23.
//

import SwiftUI

class FocusTimeViewModel: NSObject, ObservableObject , UNUserNotificationCenterDelegate {
    
    
    @Published var progress: CGFloat = 1
    @Published var timerStringValue = "00:00"
    
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    // MARK: Total Seconds
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    // MARK: Post Timer Properties
    @Published var isFinished = false
    
    override init() {
        super.init()
        authorizeNotification()
    }
    
    
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isStarted = true
        }
        
        timerStringValue = "\(hour == 0 ? "": "\(hour)"):\(minutes >= 10 ? "\(minutes)" : "0\(minutes)" ) : \(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        //MARK: Calculating Total Seconds For Timer Animation
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    func updateTimer() {
        totalSeconds -= 1
        
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = progress < 0 ?  0 : progress
        
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        
        timerStringValue = "\(hour == 0 ? "": "\(hour)"):\(minutes >= 10 ? "\(minutes)" : "0\(minutes)" ) : \(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        if hour == 0  ,seconds == 0, minutes == 0 {
            isStarted = false
            print("Finished")
            isFinished = true
        }
    }
    
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.subtitle = "Congratulations You did is hooray"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
            
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
}
