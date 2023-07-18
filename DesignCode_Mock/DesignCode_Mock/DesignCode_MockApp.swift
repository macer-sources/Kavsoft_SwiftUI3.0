//
//  DesignCode_MockApp.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI

@main
struct DesignCode_MockApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
