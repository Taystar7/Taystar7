//
//  VehicleFormView.swift
//  CarMaintenanceApp
//
//  Form for adding/editing vehicles
//

import SwiftUI

struct VehicleFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var make = ""
    @State private var model = ""
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var vin = ""
    @State private var licensePlate = ""
    @State private var currentMileage = ""
    @State private var notes = ""
    
    var vehicle: Vehicle?
    var isEditing: Bool { vehicle != nil }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Information")) {
                    TextField("Make", text: $make)
                    TextField("Model", text: $model)
                    Stepper("Year: \(year)", value: $year, in: 1900...2050)
                }
                
                Section(header: Text("Details")) {
                    TextField("VIN (Optional)", text: $vin)
                    TextField("License Plate (Optional)", text: $licensePlate)
                    TextField("Current Mileage", text: $currentMileage)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Vehicle" : "Add Vehicle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveVehicle()
                    }
                    .disabled(make.isEmpty || model.isEmpty)
                }
            }
            .onAppear {
                if let vehicle = vehicle {
                    make = vehicle.make
                    model = vehicle.model
                    year = Int(vehicle.year)
                    vin = vehicle.vin ?? ""
                    licensePlate = vehicle.licensePlate ?? ""
                    currentMileage = "\(vehicle.currentMileage)"
                    notes = vehicle.notes ?? ""
                }
            }
        }
    }
    
    private func saveVehicle() {
        let vehicleToSave = vehicle ?? Vehicle(context: viewContext)
        
        vehicleToSave.make = make
        vehicleToSave.model = model
        vehicleToSave.year = Int16(year)
        vehicleToSave.vin = vin.isEmpty ? nil : vin
        vehicleToSave.licensePlate = licensePlate.isEmpty ? nil : licensePlate
        vehicleToSave.currentMileage = Int32(currentMileage) ?? 0
        vehicleToSave.notes = notes.isEmpty ? nil : notes
        vehicleToSave.updatedAt = Date()
        
        if vehicle == nil {
            vehicleToSave.id = UUID()
            vehicleToSave.createdAt = Date()
        }
        
        do {
            try viewContext.save()
            hapticFeedback(.success)
            dismiss()
        } catch {
            print("Error saving vehicle: \(error)")
            hapticFeedback(.error)
        }
    }
    
    private func hapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

struct VehicleFormView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleFormView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
