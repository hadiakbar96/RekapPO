//
//  MyOrdersApp.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 10/04/26.
//

import SwiftData
import SwiftUI

@main
struct MyOrdersApp: App {
    // 1. This variable tracks where the user is in the setup flow.
    // By default, it starts at "onboarding"
    @AppStorage("appState") private var appState: String = "onboarding"
    
    var body: some Scene {
        WindowGroup {
            // 2. The traffic controller logic
            if appState == "onboarding" {
                OnBoardingView()
            } else if appState == "settings" {
                // We pass a flag so SettingsView knows this is the first time!
                SettingView(isInitialSetup: true)
            } else {
                ContentView()
            }   
        }
        .modelContainer(for:  Order.self)
        
    }
}
