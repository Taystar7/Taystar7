//
//  PersistenceController.swift
//  CarMaintenanceApp
//
//  Core Data stack with iCloud sync support
//

import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CarMaintenance")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            // Enable iCloud sync
            guard let description = container.persistentStoreDescriptions.first else {
                fatalError("Failed to retrieve persistent store description")
            }
            
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: "iCloud.com.carmaintenance.app"
            )
            
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Preview support
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create sample data
        let vehicle = Vehicle(context: viewContext)
        vehicle.id = UUID()
        vehicle.make = "Toyota"
        vehicle.model = "Camry"
        vehicle.year = 2020
        vehicle.currentMileage = 45000
        // TODO: Implement image display functionality
        vehicle.imageURL = nil
        
        let task = MaintenanceTask(context: viewContext)
        task.id = UUID()
        task.title = "Oil Change"
        task.taskDescription = "Regular oil change service"
        task.dueDate = Date().addingTimeInterval(86400 * 7)
        task.dueMileage = 48000
        task.isCompleted = false
        task.vehicle = vehicle
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
}
