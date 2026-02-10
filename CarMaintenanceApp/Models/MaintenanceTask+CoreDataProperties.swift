//
//  MaintenanceTask+CoreDataProperties.swift
//  CarMaintenanceApp
//

import Foundation
import CoreData

extension MaintenanceTask {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MaintenanceTask> {
        return NSFetchRequest<MaintenanceTask>(entityName: "MaintenanceTask")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var taskDescription: String?
    @NSManaged public var category: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var dueMileage: Int32
    @NSManaged public var completedDate: Date?
    @NSManaged public var completedMileage: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var cost: Double
    @NSManaged public var location: String?
    @NSManaged public var notifyBeforeDays: Int16
    @NSManaged public var notifyBeforeMiles: Int32
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var vehicle: Vehicle
    
    public var wrappedTitle: String {
        title 
    }
    
    public var wrappedDescription: String {
        taskDescription ?? ""
    }
    
    public var wrappedCategory: String {
        category ?? "General"
    }
    
    public var isDue: Bool {
        if let dueDate = dueDate, dueDate <= Date() {
            return true
        }
        if dueMileage > 0 && vehicle.currentMileage >= dueMileage {
            return true
        }
        return false
    }
    
    public var daysUntilDue: Int? {
        guard let dueDate = dueDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: dueDate)
        return components.day
    }
    
    public var milesUntilDue: Int32 {
        guard dueMileage > 0 else { return 0 }
        return dueMileage - vehicle.currentMileage
    }
}

extension MaintenanceTask : Identifiable {
    
}
