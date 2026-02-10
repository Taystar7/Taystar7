//
//  VehicleDetailView.swift
//  CarMaintenanceApp
//
//  Detailed view of a vehicle and its maintenance tasks
//

import SwiftUI

struct VehicleDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var vehicle: Vehicle
    
    @State private var showingAddTask = false
    @State private var showingEditVehicle = false
    @State private var selectedTask: MaintenanceTask?
    
    var body: some View {
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
                    // Vehicle Header
                    vehicleHeader
                    
                    // Stats Cards
                    statsSection
                    
                    // Tasks Section
                    tasksSection
                }
                .padding()
            }
        }
        .navigationTitle(vehicle.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditVehicle = true }) {
                        Label("Edit Vehicle", systemImage: "pencil")
                    }
                    
                    Button(action: { showingAddTask = true }) {
                        Label("Add Task", systemImage: "plus")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            TaskFormView(vehicle: vehicle)
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(isPresented: $showingEditVehicle) {
            VehicleFormView(vehicle: vehicle)
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(task: task)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private var vehicleHeader: some View {
        VStack(spacing: 12) {
            // Vehicle Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "car.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            Text(vehicle.displayName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if let licensePlate = vehicle.licensePlate {
                Text(licensePlate)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
    }
    
    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Mileage",
                value: "\(vehicle.currentMileage)",
                icon: "gauge"
            )
            
            StatCard(
                title: "Tasks",
                value: "\(vehicle.upcomingTasks.count)",
                icon: "wrench.and.screwdriver"
            )
            
            StatCard(
                title: "Completed",
                value: "\(vehicle.completedTasks.count)",
                icon: "checkmark.circle"
            )
        }
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Maintenance Tasks")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    hapticFeedback()
                    showingAddTask = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            
            if vehicle.upcomingTasks.isEmpty && vehicle.completedTasks.isEmpty {
                Text("No maintenance tasks yet")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            } else {
                // Upcoming Tasks
                if !vehicle.upcomingTasks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        ForEach(vehicle.upcomingTasks, id: \.id) { task in
                            Button(action: {
                                selectedTask = task
                            }) {
                                TaskRow(task: task)
                            }
                        }
                    }
                }
                
                // Completed Tasks
                if !vehicle.completedTasks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completed")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        ForEach(vehicle.completedTasks.prefix(5), id: \.id) { task in
                            Button(action: {
                                selectedTask = task
                            }) {
                                TaskRow(task: task)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.15))
        )
    }
}

struct TaskRow: View {
    let task: MaintenanceTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.wrappedTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if task.isDue {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct VehicleDetailView_Previews: PreviewProvider {
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
        
        return NavigationView {
            VehicleDetailView(vehicle: vehicle)
                .environment(\.managedObjectContext, context)
        }
    }
}
