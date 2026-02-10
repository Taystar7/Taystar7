//
//  NotificationManager.swift
//  CarMaintenanceApp
//
//  Manages local notifications for maintenance reminders
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: NSObject, ObservableObject {
    @Published var isAuthorized = false
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkAuthorization()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
            }
        }
    }
    
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleNotification(for task: MaintenanceTask) {
        guard isAuthorized else {
            requestAuthorization()
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Maintenance Reminder"
        content.body = "\(task.wrappedTitle) is due soon for \(task.vehicle.displayName)"
        content.sound = .default
        content.badge = 1
        
        // Schedule based on due date
        if let dueDate = task.dueDate, task.notifyBeforeDays > 0 {
            let notificationDate = Calendar.current.date(
                byAdding: .day,
                value: -Int(task.notifyBeforeDays),
                to: dueDate
            )
            
            if let notificationDate = notificationDate, notificationDate > Date() {
                let components = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: notificationDate
                )
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                let request = UNNotificationRequest(
                    identifier: "task-\(task.id.uuidString)",
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
        
        // Note: Mileage-based notifications would require periodic checks
        // This could be implemented via background tasks or app active state monitoring
    }
    
    func cancelNotification(for task: MaintenanceTask) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["task-\(task.id.uuidString)"]
        )
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap
        completionHandler()
    }
}
