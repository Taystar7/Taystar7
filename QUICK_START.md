# Quick Start Guide - Car Maintenance iOS App

## What is This App?
A native iOS application that helps you track maintenance for your vehicles. Set reminders based on time or mileage, manage multiple vehicles, and keep a history of all service performed.

## Features at a Glance
- 📱 **Native iOS App** - Built with SwiftUI for iOS 15+
- ☁️ **iCloud Sync** - Your data syncs across all your devices
- 🔔 **Smart Reminders** - Get notified before maintenance is due
- 🚗 **Multiple Vehicles** - Track cars, trucks, motorcycles, etc.
- 📊 **Service History** - Complete record of all maintenance
- 🌓 **Dark Mode** - Automatic light/dark theme support

## Getting Started

### Installation (For Developers)
1. **Requirements:**
   - macOS 13.0 or later
   - Xcode 14.0 or later
   - Apple ID for code signing

2. **Build Steps:**
   ```bash
   git clone https://github.com/Taystar7/Taystar7.git
   cd Taystar7
   open CarMaintenanceApp.xcodeproj
   ```

3. **In Xcode:**
   - Select your development team under "Signing & Capabilities"
   - Choose a simulator or connected iOS device
   - Press ⌘R to build and run

### First-Time Setup
1. **Grant Permissions:**
   - Allow notifications when prompted
   - Sign in to iCloud for sync (recommended)

2. **Add Your First Vehicle:**
   - Tap "Add Vehicle" on the dashboard
   - Enter make, model, year
   - Add current mileage
   - Optionally add VIN, license plate, notes
   - Tap "Save"

3. **Create a Maintenance Task:**
   - Open the vehicle you just added
   - Tap the "+" button
   - Enter task details (e.g., "Oil Change")
   - Choose a category
   - Set when it's due:
     - By date (e.g., "Next month")
     - By mileage (e.g., "At 50,000 miles")
     - Or both!
   - Configure reminder preferences
   - Tap "Save"

## Using the App

### Dashboard
- **Main Screen** - See all your vehicles at a glance
- **Upcoming Maintenance** - Next 3 tasks across all vehicles
- **Quick Access** - Tap any vehicle to see details

### Managing Vehicles
- **Add** - Tap "Add Vehicle" button
- **View** - Tap any vehicle card
- **Edit** - Open vehicle → Menu (⋯) → Edit Vehicle
- **Update Mileage** - Edit vehicle and update current mileage

### Managing Tasks
- **Add** - Open vehicle → Tap "+" button
- **View** - Tap any task in the list
- **Complete** - Open task → "Mark as Completed"
- **Edit** - Open task → Menu (⋯) → Edit
- **Delete** - Open task → Menu (⋯) → Delete

### Task Categories
Choose from pre-defined categories:
- General
- Oil Change
- Tire Rotation
- Brake Service
- Inspection
- Other

### Reminders
**Time-based:**
- Set a due date
- Choose how many days before to be reminded (1-30 days)
- Get a notification when the time comes

**Mileage-based:**
- Set a target mileage
- Choose how many miles before to be reminded
- App tracks based on current mileage

### Settings
- **Dark Mode** - Toggle between light and dark themes
- **Notifications** - View permission status
- **Version Info** - See app version and iCloud status

## Tips & Tricks

### Best Practices
1. **Keep Mileage Updated** - Update your vehicle's current mileage regularly for accurate mileage-based reminders
2. **Use Categories** - Categorize tasks for better organization
3. **Add Notes** - Use the notes field to record service details
4. **Set Reminders** - Give yourself enough lead time to schedule service

### Common Tasks
- **Change Theme** - Settings → Toggle "Dark Mode"
- **Check iCloud Sync** - Settings → Look for green checkmark next to "iCloud Sync"
- **Clear Notifications** - Settings → "Clear Notification Badge"

## Troubleshooting

### Notifications Not Working?
1. Go to iOS Settings → Notifications → Car Maintenance
2. Ensure "Allow Notifications" is ON
3. In the app, go to Settings and check permission status

### iCloud Not Syncing?
1. Ensure you're signed in to iCloud on all devices
2. Check Settings → [Your Name] → iCloud → iCloud Drive is ON
3. Wait a few moments for initial sync

### Task Not Showing on Dashboard?
- Only the next 3 upcoming tasks are shown on the dashboard
- Open the specific vehicle to see all tasks

## App Statistics
- **1,542 lines** of Swift code
- **6 main screens** with intuitive navigation
- **2 Core Data entities** for robust data storage
- **Support for unlimited** vehicles and tasks

## Support & Feedback
This is an open-source project. For questions, issues, or feature requests:
- Check the DEVELOPMENT_GUIDE.md for technical details
- See the README.md for architecture information

## Privacy & Data
- **Local Storage** - Your data is stored on your device using Core Data
- **iCloud Sync** - Optional; keeps data in sync across your devices
- **No Analytics** - No data collection or tracking
- **Your Data** - You have complete control; delete anytime

---

Enjoy tracking your vehicle maintenance with ease! 🚗✨
