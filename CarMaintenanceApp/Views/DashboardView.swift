//
//  DashboardView.swift
//  CarMaintenanceApp
//
//  Main dashboard displaying vehicles and upcoming maintenance
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var notificationManager: NotificationManager
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Vehicle.createdAt, ascending: true)],
        animation: .default
    )
    private var vehicles: FetchedResults<Vehicle>
    
    @State private var showingAddVehicle = false
    @State private var showingSettings = false
    @State private var selectedVehicle: Vehicle?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
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
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text("My Garage")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("\(vehicles.count) vehicle\(vehicles.count == 1 ? "" : "s")")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            Button(action: { showingSettings = true }) {
                                Image(systemName: "gear")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        
                        // Upcoming Maintenance Summary
                        upcomingMaintenanceSummary
                        
                        // Vehicles List
                        if vehicles.isEmpty {
                            emptyStateView
                        } else {
                            vehiclesList
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddVehicle) {
                VehicleFormView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(isDarkMode: $isDarkMode)
            }
        }
    }
    
    private var upcomingMaintenanceSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Maintenance")
                .font(.headline)
                .foregroundColor(.white)
            
            let allUpcomingTasks = vehicles.flatMap { $0.upcomingTasks }
                .sorted { task1, task2 in
                    if let date1 = task1.dueDate, let date2 = task2.dueDate {
                        return date1 < date2
                    }
                    return false
                }
                .prefix(3)
            
            if allUpcomingTasks.isEmpty {
                Text("No upcoming maintenance")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            } else {
                ForEach(Array(allUpcomingTasks), id: \.id) { task in
                    TaskSummaryCard(task: task)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
        .padding(.horizontal)
    }
    
    private var vehiclesList: some View {
        VStack(spacing: 16) {
            ForEach(vehicles) { vehicle in
                NavigationLink(destination: VehicleDetailView(vehicle: vehicle)) {
                    VehicleCard(vehicle: vehicle)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Add Vehicle Button
            Button(action: {
                hapticFeedback()
                showingAddVehicle = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("Add Vehicle")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.fill")
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.5))
            
            Text("No Vehicles Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Add your first vehicle to start tracking maintenance")
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                hapticFeedback()
                showingAddVehicle = true
            }) {
                Text("Add Vehicle")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct VehicleCard: View {
    let vehicle: Vehicle
    
    var body: some View {
        HStack(spacing: 16) {
            // Vehicle Image/Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "car.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.displayName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(vehicle.currentMileage) miles")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                if !vehicle.upcomingTasks.isEmpty {
                    Text("\(vehicle.upcomingTasks.count) upcoming task\(vehicle.upcomingTasks.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.15))
        )
        .padding(.horizontal)
    }
}

struct TaskSummaryCard: View {
    let task: MaintenanceTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.wrappedTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(task.vehicle.displayName)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            if let daysUntil = task.daysUntilDue {
                Text("\(daysUntil)d")
                    .font(.caption)
                    .foregroundColor(daysUntil < 7 ? .red : .yellow)
            }
        }
        .padding(.vertical, 8)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(NotificationManager())
    }
}
