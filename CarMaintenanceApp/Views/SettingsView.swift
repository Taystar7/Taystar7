//
//  SettingsView.swift
//  CarMaintenanceApp
//
//  Settings screen for app preferences
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var notificationManager: NotificationManager
    @Binding var isDarkMode: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section(header: Text("Notifications")) {
                    HStack {
                        Text("Notifications")
                        Spacer()
                        Text(notificationManager.isAuthorized ? "Enabled" : "Disabled")
                            .foregroundColor(notificationManager.isAuthorized ? .green : .red)
                    }
                    
                    if !notificationManager.isAuthorized {
                        Button("Enable Notifications") {
                            notificationManager.requestAuthorization()
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("iCloud Sync")
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Section(header: Text("Data")) {
                    Button("Clear Notification Badge") {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isDarkMode: .constant(false))
            .environmentObject(NotificationManager())
    }
}
