//
//  TaskFormView.swift
//  CarMaintenanceApp
//
//  Form for adding/editing maintenance tasks
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var notificationManager: NotificationManager
    
    let vehicle: Vehicle
    var task: MaintenanceTask?
    var isEditing: Bool { task != nil }
    
    @State private var title = ""
    @State private var description = ""
    @State private var category = "General"
    @State private var dueDate = Date()
    @State private var useDueDate = true
    @State private var dueMileage = ""
    @State private var useDueMileage = false
    @State private var notifyBeforeDays = 7
    @State private var notifyBeforeMiles = 500
    @State private var cost = ""
    @State private var location = ""
    
    let categories = ["General", "Oil Change", "Tire Rotation", "Brake Service", "Inspection", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Information")) {
                    TextField("Title", text: $title)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    
                    TextField("Description (Optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Due Date")) {
                    Toggle("Set Due Date", isOn: $useDueDate)
                    
                    if useDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                        
                        Stepper("Notify \(notifyBeforeDays) days before", value: $notifyBeforeDays, in: 1...30)
                    }
                }
                
                Section(header: Text("Due Mileage")) {
                    Toggle("Set Due Mileage", isOn: $useDueMileage)
                    
                    if useDueMileage {
                        TextField("Due Mileage", text: $dueMileage)
                            .keyboardType(.numberPad)
                        
                        Stepper("Notify \(notifyBeforeMiles) miles before", value: $notifyBeforeMiles, in: 100...5000, step: 100)
                    }
                }
                
                Section(header: Text("Additional Details")) {
                    TextField("Service Location (Optional)", text: $location)
                    TextField("Estimated Cost (Optional)", text: $cost)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(isEditing ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                if let task = task {
                    title = task.title
                    description = task.taskDescription ?? ""
                    category = task.category ?? "General"
                    
                    if let dueDate = task.dueDate {
                        self.dueDate = dueDate
                        useDueDate = true
                    }
                    
                    if task.dueMileage > 0 {
                        dueMileage = "\(task.dueMileage)"
                        useDueMileage = true
                    }
                    
                    notifyBeforeDays = Int(task.notifyBeforeDays)
                    notifyBeforeMiles = Int(task.notifyBeforeMiles)
                    location = task.location ?? ""
                    
                    if task.cost > 0 {
                        cost = "\(task.cost)"
                    }
                }
            }
        }
    }
    
    private func saveTask() {
        let taskToSave = task ?? MaintenanceTask(context: viewContext)
        
        taskToSave.title = title
        taskToSave.taskDescription = description.isEmpty ? nil : description
        taskToSave.category = category
        taskToSave.dueDate = useDueDate ? dueDate : nil
        taskToSave.dueMileage = useDueMileage ? (Int32(dueMileage) ?? 0) : 0
        taskToSave.notifyBeforeDays = useDueDate ? Int16(notifyBeforeDays) : 0
        taskToSave.notifyBeforeMiles = useDueMileage ? Int32(notifyBeforeMiles) : 0
        taskToSave.location = location.isEmpty ? nil : location
        taskToSave.cost = Double(cost) ?? 0
        taskToSave.updatedAt = Date()
        taskToSave.vehicle = vehicle
        
        if task == nil {
            taskToSave.id = UUID()
            taskToSave.createdAt = Date()
            taskToSave.isCompleted = false
        }
        
        do {
            try viewContext.save()
            
            // Schedule notification
            if useDueDate && notifyBeforeDays > 0 {
                notificationManager.scheduleNotification(for: taskToSave)
            }
            
            hapticFeedback(.success)
            dismiss()
        } catch {
            print("Error saving task: \(error)")
            hapticFeedback(.error)
        }
    }
    
    private func hapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

struct TaskFormView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let vehicle = Vehicle(context: context)
        vehicle.id = UUID()
        vehicle.make = "Toyota"
        vehicle.model = "Camry"
        vehicle.year = 2020
        vehicle.currentMileage = 45000
        vehicle.createdAt = Date()
        vehicle.updatedAt = Date()
        
        return TaskFormView(vehicle: vehicle)
            .environment(\.managedObjectContext, context)
            .environmentObject(NotificationManager())
    }
}
