//
//  CarMaintenanceApp.swift
//  CarMaintenanceApp
//
//  Created on 2026-02-08
//

import SwiftUI

@main
struct CarMaintenanceApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var notificationManager = NotificationManager()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
