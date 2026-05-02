//
//  SettingView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 26/04/26.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("defaultPreOrderDays") private var defaultPreOrderDays = 7
    @AppStorage("appState") private var appState: String = "onboarding"
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingSaveAlert = false
    
    //it defaults to false for normal usage
    var isInitialSetup: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Pre-Order Settings
                Section(header: Text("Pre-Order Defaults Lead Time"), footer: Text("This sets the automatic deadline when you create a new order.")) {
                    
                    Stepper(value: $defaultPreOrderDays, in: 1...90) {
                        HStack {
                            // The Teal Accent Icon
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color.primaryButton)
                                .font(.title3)
                            
                            Text("Lead Time")
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            // Displays the current number
                            Text("\(defaultPreOrderDays) Days")
//                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // MARK: - Other Settings (Examples for the future)
//                Section(header: Text("App Preferences")) {
//                    HStack {
//                        Image(systemName: "bell.badge.fill")
//                            .foregroundColor(Color.primaryButton)
//                            .font(.title3)
//                        Toggle("Deadline Notifications", isOn: .constant(true))
//                            .tint(Color.primaryButton) // Makes the toggle switch teal!
//                    }
//                }
            }
            .navigationTitle(isInitialSetup ? "Initial Setup" : "Settings")
            //logging
            .onAppear {
                print("the appState : ", appState)}
            .toolbar {
                // Only show Cancel if this is NOT the initial setup
                if !isInitialSetup {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", role: .cancel) { dismiss() }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isInitialSetup ? "Finish" : "Save") {
                        if isInitialSetup {
                            // If first time, move the traffic controller to the main app!
                            appState = "main"
                        } else {
                            // If normal usage, show the success alert
                            showingSaveAlert = true
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryButton)
                }
            }
            .alert("Setting Saved", isPresented: $showingSaveAlert) {
                Button("Ok", role: .cancel) {
                    // When they tap OK, dismiss the view and go back to ContentView
                    dismiss()
                }
            } message: {
                Text("Your default pre-order lead time has been successfully updated.")
            }
        }
        // 👉 CRITICAL: Prevents users from swiping the screen down to skip setup!
                .interactiveDismissDisabled(isInitialSetup)
    }
}

#Preview {
    SettingView()
}
