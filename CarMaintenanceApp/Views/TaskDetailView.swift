//
//  TaskDetailView.swift
//  CarMaintenanceApp
//
//  Detailed view of a maintenance task with history
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var task: MaintenanceTask
    
    @State private var showingEditTask = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.2, blue: 0.45),
                        Color(red: 0.2, green: 0.3, blue: 0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Task Header
                        taskHeader
                        
                        // Task Details
                        taskDetails
                        
                        // Actions
                        actionButtons
                    }
                    .padding()
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingEditTask = true }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingEditTask) {
                TaskFormView(vehicle: task.vehicle, task: task)
                    .environment(\.managedObjectContext, viewContext)
            }
            .alert("Delete Task", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteTask()
                }
            } message: {
                Text("Are you sure you want to delete this task?")
            }
        }
    }
    
    private var taskHeader: some View {
        VStack(spacing: 12) {
            // Status Icon
            ZStack {
                Circle()
                    .fill(task.isCompleted ? Color.green.opacity(0.3) : Color.yellow.opacity(0.3))
                    .frame(width: 80, height: 80)
                
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "wrench.and.screwdriver")
                    .font(.system(size: 40))
                    .foregroundColor(task.isCompleted ? .green : .yellow)
            }
            
            Text(task.wrappedTitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(task.wrappedCategory)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
    }
    
    private var taskDetails: some View {
        VStack(spacing: 16) {
            if !task.wrappedDescription.isEmpty {
                DetailRow(label: "Description", value: task.wrappedDescription)
            }
            
            if let dueDate = task.dueDate {
                DetailRow(label: "Due Date", value: dueDate.formatted(date: .long, time: .omitted))
            }
            
            if task.dueMileage > 0 {
                DetailRow(label: "Due Mileage", value: "\(task.dueMileage) miles")
            }
            
            if let completedDate = task.completedDate {
                DetailRow(label: "Completed", value: completedDate.formatted(date: .long, time: .omitted))
            }
            
            if task.completedMileage > 0 {
                DetailRow(label: "Completed Mileage", value: "\(task.completedMileage) miles")
            }
            
            if task.cost > 0 {
                DetailRow(label: "Cost", value: String(format: "$%.2f", task.cost))
            }
            
            if let location = task.location {
                DetailRow(label: "Location", value: location)
            }
            
            DetailRow(label: "Vehicle", value: task.vehicle.displayName)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if !task.isCompleted {
                Button(action: {
                    markAsCompleted()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)
                    )
                }
            } else {
                Button(action: {
                    markAsIncomplete()
                }) {
                    HStack {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                        Text("Mark as Incomplete")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange)
                    )
                }
            }
        }
    }
    
    private func markAsCompleted() {
        task.isCompleted = true
        task.completedDate = Date()
        task.completedMileage = task.vehicle.currentMileage
        task.updatedAt = Date()
        
        do {
            try viewContext.save()
            hapticFeedback(.success)
        } catch {
            print("Error marking task as completed: \(error)")
            hapticFeedback(.error)
        }
    }
    
    private func markAsIncomplete() {
        task.isCompleted = false
        task.completedDate = nil
        task.completedMileage = 0
        task.updatedAt = Date()
        
        do {
            try viewContext.save()
            hapticFeedback(.success)
        } catch {
            print("Error marking task as incomplete: \(error)")
            hapticFeedback(.error)
        }
    }
    
    private func deleteTask() {
        viewContext.delete(task)
        
        do {
            try viewContext.save()
            hapticFeedback(.success)
            dismiss()
        } catch {
            print("Error deleting task: \(error)")
            hapticFeedback(.error)
        }
    }
    
    private func hapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

struct TaskDetailView_Previews: PreviewProvider {
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
        
        let task = MaintenanceTask(context: context)
        task.id = UUID()
        task.title = "Oil Change"
        task.taskDescription = "Regular oil change service"
        task.category = "Oil Change"
        task.dueDate = Date().addingTimeInterval(86400 * 7)
        task.isCompleted = false
        task.vehicle = vehicle
        task.createdAt = Date()
        task.updatedAt = Date()
        
        return TaskDetailView(task: task)
            .environment(\.managedObjectContext, context)
    }
}
