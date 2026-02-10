# Car Maintenance App - Development Guide

## Overview
This is a native iOS application built with SwiftUI for tracking vehicle maintenance schedules, tasks, and service history.

## Architecture

### Core Components

#### 1. Data Layer (Core Data)
- **PersistenceController**: Manages the Core Data stack with iCloud sync
- **Vehicle**: Entity representing a vehicle with make, model, year, mileage
- **MaintenanceTask**: Entity representing maintenance tasks with dates, mileage, and completion status

#### 2. Views (SwiftUI)
- **DashboardView**: Main view showing all vehicles and upcoming maintenance
- **VehicleFormView**: Add/Edit vehicle details
- **VehicleDetailView**: Shows vehicle details and associated tasks
- **TaskFormView**: Add/Edit maintenance tasks
- **TaskDetailView**: View and manage individual task details
- **SettingsView**: App settings and preferences

#### 3. Managers
- **NotificationManager**: Handles local notifications for maintenance reminders

## Features Implemented

### ✅ Core Functionality
- [x] Vehicle management (CRUD operations)
- [x] Maintenance task tracking
- [x] Dashboard with upcoming tasks
- [x] Task completion tracking
- [x] Time-based and mileage-based due dates

### ✅ iOS Features
- [x] SwiftUI declarative UI
- [x] Core Data persistence
- [x] iCloud sync via CloudKit
- [x] UserNotifications for reminders
- [x] Dark mode support
- [x] Haptic feedback
- [x] Smooth animations

### ✅ UX Enhancements
- [x] Gradient backgrounds
- [x] Status indicators
- [x] Card-based layouts
- [x] System SF Symbols icons
- [x] Form validation

## Project Structure

```
CarMaintenanceApp/
├── CarMaintenanceApp.swift          # App entry point
├── Info.plist                       # App configuration
├── CarMaintenanceApp.entitlements   # Capabilities (iCloud)
├── Assets.xcassets/                 # Images and colors
├── PersistenceController.swift      # Core Data stack
├── CarMaintenance.xcdatamodeld/     # Data model
├── Models/                          # Core Data entities
│   ├── Vehicle+CoreDataClass.swift
│   ├── Vehicle+CoreDataProperties.swift
│   ├── MaintenanceTask+CoreDataClass.swift
│   └── MaintenanceTask+CoreDataProperties.swift
├── Views/                           # SwiftUI views
│   ├── DashboardView.swift
│   ├── VehicleFormView.swift
│   ├── VehicleDetailView.swift
│   ├── TaskFormView.swift
│   ├── TaskDetailView.swift
│   └── SettingsView.swift
├── Managers/                        # Business logic
│   └── NotificationManager.swift
└── Utilities/                       # Helpers
    └── Extensions.swift
```

## How to Build

### Prerequisites
1. macOS 13.0 or later
2. Xcode 14.0 or later
3. Apple Developer account (for iCloud)

### Steps
1. Open `CarMaintenanceApp.xcodeproj` in Xcode
2. Select your development team in the project settings
3. Update the bundle identifier if needed
4. Build and run (⌘R)

## Configuration

### iCloud Setup
1. In Xcode, select the CarMaintenanceApp target
2. Go to "Signing & Capabilities"
3. Add "iCloud" capability
4. Enable "CloudKit"
5. Create or select a container

### Notifications
The app requests notification permissions at runtime. Users can grant or deny permissions in Settings.

## Data Model

### Vehicle
- `id`: UUID (primary key)
- `make`: String (e.g., "Toyota")
- `model`: String (e.g., "Camry")
- `year`: Int16 (e.g., 2020)
- `vin`: String? (optional)
- `licensePlate`: String? (optional)
- `currentMileage`: Int32
- `imageURL`: String? (for future use)
- `notes`: String?
- `createdAt`: Date
- `updatedAt`: Date
- Relationship: `tasks` → [MaintenanceTask]

### MaintenanceTask
- `id`: UUID (primary key)
- `title`: String (e.g., "Oil Change")
- `taskDescription`: String?
- `category`: String? (e.g., "Oil Change", "Tire Rotation")
- `dueDate`: Date? (time-based reminder)
- `dueMileage`: Int32 (mileage-based reminder)
- `completedDate`: Date?
- `completedMileage`: Int32
- `isCompleted`: Bool
- `cost`: Double
- `location`: String?
- `notifyBeforeDays`: Int16
- `notifyBeforeMiles`: Int32
- `createdAt`: Date
- `updatedAt`: Date
- Relationship: `vehicle` → Vehicle

## Key Workflows

### Adding a Vehicle
1. User taps "Add Vehicle" on Dashboard
2. `VehicleFormView` presented as sheet
3. User fills in make, model, year, mileage
4. On save, creates new `Vehicle` entity
5. Saves to Core Data
6. Syncs to iCloud
7. Dismisses form and returns to Dashboard

### Creating a Task
1. User navigates to a vehicle
2. Taps "Add Task" button
3. `TaskFormView` presented as sheet
4. User enters task details
5. Sets due date and/or mileage
6. Configures reminder preferences
7. On save, creates `MaintenanceTask`
8. Schedules notification if applicable
9. Saves to Core Data
10. Returns to vehicle detail

### Completing a Task
1. User taps on a task
2. `TaskDetailView` displayed
3. User taps "Mark as Completed"
4. Updates task with:
   - `isCompleted = true`
   - `completedDate = now`
   - `completedMileage = vehicle.currentMileage`
5. Saves to Core Data
6. Cancels any pending notifications

## Notifications

### Time-Based
- Scheduled X days before due date
- User configurable (1-30 days)
- Uses `UNCalendarNotificationTrigger`

### Mileage-Based
- Currently requires active monitoring
- Future enhancement: Background task to check mileage

## Theming

### Color Scheme
- Primary: Dark blue gradient
- Accent: Blue
- Background: Gradient (dark blue to lighter blue)
- Text: White on dark backgrounds

### Dark Mode
- Fully supported
- Follows system settings
- Toggle in Settings view
- Persisted via `@AppStorage`

## Future Enhancements

### Planned Features
1. **Siri Integration**
   - Voice commands for adding tasks
   - Query upcoming maintenance
   - Requires Intents framework

2. **Cost Tracking**
   - Expense reports
   - Charts and analytics
   - Export to CSV

3. **Service Center Locator**
   - MapKit integration
   - Find nearby service centers
   - Navigation support

4. **Photo Attachments**
   - Store receipts
   - Service records
   - Before/after photos

5. **Widgets**
   - Home screen widget
   - Lock screen widget
   - Show upcoming tasks

6. **Apple Watch**
   - Companion app
   - Quick task view
   - Completion tracking

## Best Practices

### Core Data
- Always use background context for heavy operations
- Implement proper error handling
- Use fetch request predicates to limit results
- Enable lightweight migration for schema changes

### SwiftUI
- Keep views small and focused
- Extract reusable components
- Use `@StateObject` for owned objects
- Use `@ObservedObject` for passed objects
- Leverage preview providers for development

### Testing
- Use `PersistenceController.preview` for SwiftUI previews
- Test on both light and dark mode
- Verify iCloud sync behavior
- Test notification permissions

## Troubleshooting

### iCloud Not Syncing
1. Verify iCloud capability is enabled
2. Check container identifier matches
3. Ensure user is signed in to iCloud
4. Check Xcode logs for CloudKit errors

### Notifications Not Working
1. Check permission status in Settings
2. Verify notification scheduling logic
3. Check device notification settings
4. Test on physical device (simulator limitations)

### Build Errors
1. Clean build folder (⇧⌘K)
2. Reset package caches if using SPM
3. Update Xcode to latest version
4. Check code signing settings

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [UserNotifications Framework](https://developer.apple.com/documentation/usernotifications)

## License
Open source - Available for personal and educational use.
