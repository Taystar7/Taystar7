//
//  Vehicle+CoreDataProperties.swift
//  CarMaintenanceApp
//

import Foundation
import CoreData

extension Vehicle {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var make: String
    @NSManaged public var model: String
    @NSManaged public var year: Int16
    @NSManaged public var vin: String?
    @NSManaged public var licensePlate: String?
    @NSManaged public var currentMileage: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var notes: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var tasks: NSSet?
    
    public var displayName: String {
        "\(year) \(make) \(model)"
    }
    
    public var taskArray: [MaintenanceTask] {
        let set = tasks as? Set<MaintenanceTask> ?? []
        return set.sorted { $0.createdAt < $1.createdAt }
    }
    
    public var upcomingTasks: [MaintenanceTask] {
        taskArray.filter { !$0.isCompleted }
    }
    
    public var completedTasks: [MaintenanceTask] {
        taskArray.filter { $0.isCompleted }
    }
}

// MARK: Generated accessors for tasks
extension Vehicle {
    
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: MaintenanceTask)
    
    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: MaintenanceTask)
    
    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
}

extension Vehicle : Identifiable {
    
}
