# Car Maintenance Tracker - iOS App

A native iOS application built with SwiftUI for tracking vehicle maintenance schedules, tasks, and service history.

## 🚗 Features

### Core Functionality
- **Vehicle Management**: Add, edit, and manage multiple vehicles with detailed information
- **Maintenance Tracking**: Create and track maintenance tasks with time-based and mileage-based reminders
- **Dashboard**: Overview of all vehicles and upcoming maintenance schedules
- **Task History**: View completed maintenance history for each vehicle

### Technical Features
- **SwiftUI**: Modern, declarative UI framework for iOS
- **Core Data**: Persistent data storage with support for complex relationships
- **iCloud Sync**: Cross-device data synchronization using CloudKit
- **UserNotifications**: Smart reminders for upcoming maintenance
- **Dark Mode**: Full support for system-wide appearance settings
- **Haptic Feedback**: Enhanced user experience with tactile feedback
- **Smooth Animations**: Polished transitions and interactions

### Data Model
- **Vehicle**: Store make, model, year, VIN, license plate, current mileage, notes, and images
- **Maintenance Task**: Track title, description, category, due dates, mileage intervals, completion status, costs, and service locations

## 📱 Screenshots

The app features:
- Clean, modern UI with gradient backgrounds
- Intuitive navigation and forms
- Status indicators for task urgency
- Categorized maintenance tasks (Oil Change, Tire Rotation, Brake Service, etc.)

## 🏗️ Architecture

### File Structure
```
CarMaintenanceApp/
├── CarMaintenanceApp.swift         # App entry point
├── Info.plist                      # App configuration
├── PersistenceController.swift     # Core Data stack
├── CarMaintenance.xcdatamodeld/    # Core Data model
├── Models/                         # Data models
│   ├── Vehicle+CoreDataClass.swift
│   ├── Vehicle+CoreDataProperties.swift
│   ├── MaintenanceTask+CoreDataClass.swift
│   └── MaintenanceTask+CoreDataProperties.swift
├── Views/                          # SwiftUI views
│   ├── DashboardView.swift
│   ├── VehicleFormView.swift
│   ├── VehicleDetailView.swift
│   ├── TaskFormView.swift
│   ├── TaskDetailView.swift
│   └── SettingsView.swift
└── Managers/                       # Business logic
    └── NotificationManager.swift
```

### Key Technologies
- **Language**: Swift 5.0+
- **UI Framework**: SwiftUI
- **Data Persistence**: Core Data with NSPersistentCloudKitContainer
- **Cloud Sync**: CloudKit
- **Notifications**: UserNotifications framework
- **Minimum iOS Version**: iOS 15.0+

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ device or simulator
- Apple Developer account (for iCloud capabilities)

### Building the App

1. **Clone the repository**
   ```bash
   git clone https://github.com/Taystar7/Taystar7.git
   cd Taystar7/CarMaintenanceApp
   ```

2. **Open in Xcode**
   - Open the `CarMaintenanceApp` folder in Xcode
   - Select your development team in the project settings
   - Configure iCloud container identifier if needed

3. **Build and Run**
   - Select a target device or simulator
   - Press ⌘R to build and run

### Configuration

#### iCloud Setup
The app is configured to use iCloud sync. To enable:
1. Sign in with your Apple ID in Xcode
2. Enable iCloud capability in the project
3. Update the container identifier in `PersistenceController.swift` to match your bundle ID

#### Notifications
The app requests notification permissions on first launch. Users can manage these in Settings.

## 💡 Usage

### Adding a Vehicle
1. Tap the "Add Vehicle" button on the dashboard
2. Fill in vehicle details (make, model, year, mileage)
3. Optionally add VIN, license plate, and notes
4. Tap "Save"

### Creating Maintenance Tasks
1. Open a vehicle from the dashboard
2. Tap the "+" button or "Add Task"
3. Enter task details (title, category, description)
4. Set due date and/or mileage
5. Configure reminder preferences
6. Save the task

### Tracking Completion
1. Tap on any task to view details
2. Use "Mark as Completed" to record completion
3. The app automatically records completion date and mileage

### Notifications
- Time-based reminders notify you X days before the due date
- Configure reminder lead time when creating tasks
- Notifications appear as system alerts

## 🔮 Future Enhancements

The app is designed to support future features:
- **Siri Integration**: Voice commands for adding tasks and checking status
- **Cost Tracking**: Detailed expense reports and analytics
- **Service Center Locator**: Find nearby service centers using MapKit
- **Photo Attachments**: Store receipts and service records
- **Export/Import**: Backup and restore data
- **Multi-language Support**: Internationalization
- **Widget Support**: Home screen widgets for quick overview
- **Apple Watch App**: View upcoming maintenance on your wrist

## 🛠️ Development

### Testing
The app includes preview support for SwiftUI views. Use Xcode's preview canvas for rapid development.

### Core Data
The data model uses automatic lightweight migration. Schema changes should be compatible with existing data.

### Performance
- Efficient fetch requests with predicates
- Lazy loading of relationships
- Background context for heavy operations

## 📄 License

This project is open source and available for personal and educational use.

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

---

Built with ❤️ using SwiftUI
