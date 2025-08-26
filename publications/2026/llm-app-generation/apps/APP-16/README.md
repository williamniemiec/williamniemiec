# Blood Pressure Tracker App

A comprehensive Flutter mobile application for tracking and monitoring blood pressure readings with intelligent analysis, visualization, and reporting features.

## 📱 App Overview

The Blood Pressure Tracker is a digital logbook that helps users manually track, monitor, and analyze their cardiovascular health data. The app serves as an intelligent and user-friendly mobile assistant that replaces traditional paper-based logs.

### ⚠️ Important Disclaimer

**This app does NOT measure blood pressure.** It is a tracking tool that requires users to input readings taken from a separate, medically-approved blood pressure monitor. This app is intended for informational purposes only and should not be used as a substitute for professional medical advice.

## ✨ Features

### Core Data Tracking
- **Manual Data Entry**: Simple interface to log systolic, diastolic, and pulse readings
- **Automatic Categorization**: Readings are automatically classified into standard blood pressure zones
- **Contextual Tagging**: Add tags like time of day, meal relation, body posture, etc.
- **Notes**: Custom notes field for additional details

### Analysis & Visualization
- **Historical Log**: Comprehensive chronological history of all measurements
- **Interactive Charts**: Visual trends analysis with line charts and statistics
- **Time-Based Filtering**: Filter data by week, month, 3 months, 6 months, or all time
- **Category Distribution**: Visual breakdown of readings by blood pressure category

### Reporting & Reminders
- **PDF Export**: Generate detailed reports for sharing with healthcare providers
- **Measurement Reminders**: Customizable notification system for regular monitoring
- **Data Sharing**: Easy export and sharing capabilities

### Educational Resources
- **Health Insights**: Curated articles about blood pressure and heart health
- **Category-Based Content**: Articles organized by topics like diet, exercise, lifestyle, etc.
- **Health Tips**: Daily tips and recommendations

## 🏗️ Technical Architecture

### Project Structure
```
lib/
├── constants/          # App constants and theme configuration
├── models/            # Data models (BloodPressureReading, User, etc.)
├── providers/         # State management with Provider pattern
├── screens/           # UI screens (Tracker, History, Stats, Insights)
├── services/          # Business logic services (Database, PDF, Notifications)
└── widgets/           # Reusable UI components
```

### Key Technologies
- **Framework**: Flutter 3.8+
- **State Management**: Provider pattern
- **Local Database**: SQLite with sqflite
- **Charts**: FL Chart for data visualization
- **PDF Generation**: pdf package with printing support
- **Notifications**: flutter_local_notifications
- **File Sharing**: share_plus package

### Blood Pressure Categories
The app automatically categorizes readings based on American Heart Association guidelines:

- **Normal**: Less than 120/80 mmHg (Green)
- **Elevated**: 120-129 systolic and less than 80 diastolic (Orange)
- **Hypertension Stage 1**: 130-139 systolic or 80-89 diastolic (Deep Orange)
- **Hypertension Stage 2**: 140/90 mmHg or higher (Red)
- **Hypertensive Crisis**: Higher than 180/120 mmHg (Purple)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator

### Installation

1. **Clone or extract the project**
   ```bash
   cd blood_pressure_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK version: 21 (Android 5.0)
- Target SDK version: 34
- Permissions automatically handled by the app

#### iOS
- Minimum iOS version: 12.0
- Permissions for notifications handled automatically

## 📖 User Guide

### Adding a Blood Pressure Reading

1. **Measure your blood pressure** using a medically-approved monitor
2. Open the app (defaults to Tracker screen)
3. Tap the **"+" (Add New)** floating action button
4. Enter your readings:
   - **Systolic pressure** (top number)
   - **Diastolic pressure** (bottom number)
   - **Pulse rate**
5. Adjust date/time if needed
6. Select relevant tags (Morning, Sitting, etc.)
7. Add optional notes
8. Tap **"Save"**

### Viewing Your History

1. Navigate to the **History** tab
2. Use filter chips to view specific time periods
3. Tap any reading to view details or edit
4. Use the menu to export data as PDF

### Analyzing Trends

1. Go to the **Stats** tab
2. Select time period using filter chips
3. View:
   - Summary statistics (averages, totals)
   - Blood pressure trend chart
   - Category distribution
   - Time-of-day analysis

### Reading Health Insights

1. Navigate to the **Insights** tab
2. Browse articles by category or view all
3. Tap any article to read full content
4. Check the daily health tip at the top

### Exporting Data

1. From the **History** screen, tap the menu (⋮)
2. Select **"Export PDF"**
3. Choose sharing method (email, save to files, etc.)
4. The PDF includes:
   - Summary statistics
   - Detailed reading table
   - Category breakdown
   - Professional disclaimer

## 🔧 Configuration

### Customizing Tags
Edit [`lib/constants/app_constants.dart`](lib/constants/app_constants.dart) to modify the `commonTags` list:

```dart
static const List<String> commonTags = [
  'Morning',
  'Evening',
  'Before Meal',
  'After Meal',
  // Add your custom tags here
];
```

### Modifying Blood Pressure Ranges
Adjust ranges in [`lib/constants/app_constants.dart`](lib/constants/app_constants.dart):

```dart
static const Map<String, Map<String, int>> bloodPressureRanges = {
  'normal': {'systolicMax': 119, 'diastolicMax': 79},
  // Modify ranges as needed
};
```

### Theme Customization
Update colors and styling in [`lib/constants/app_theme.dart`](lib/constants/app_theme.dart).

## 🧪 Testing

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Building for Release

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 📊 Database Schema

### Blood Pressure Readings
- `id`: Primary key
- `systolic`: Systolic pressure (int)
- `diastolic`: Diastolic pressure (int)
- `pulse`: Pulse rate (int)
- `dateTime`: Timestamp (int)
- `tags`: Comma-separated tags (text)
- `notes`: Optional notes (text)
- `category`: Blood pressure category (int)

### Health Articles
- Pre-populated educational content
- Categories: Blood Pressure, Diet, Exercise, Lifestyle, Medication, General

## 🔒 Privacy & Security

- **Local Storage Only**: All data is stored locally on the device
- **No Cloud Sync**: No data is transmitted to external servers
- **User Control**: Users have full control over their data
- **Export Options**: Data can be exported and shared at user's discretion

## 🐛 Troubleshooting

### Common Issues

1. **App won't start**
   - Ensure Flutter SDK is properly installed
   - Run `flutter doctor` to check setup
   - Try `flutter clean && flutter pub get`

2. **Charts not displaying**
   - Ensure you have at least 2 readings for trend charts
   - Check that readings have valid dates

3. **PDF export fails**
   - Ensure device has sufficient storage
   - Check app permissions for file access

4. **Notifications not working**
   - Check device notification settings
   - Ensure app has notification permissions

### Getting Help

1. Check the console output for error messages
2. Run `flutter doctor` to verify setup
3. Ensure all dependencies are properly installed
4. Check device/emulator compatibility

## 📝 Development Notes

### Code Quality
- Follows Flutter best practices
- Uses Provider for state management
- Implements proper error handling
- Includes comprehensive documentation

### Performance Considerations
- Efficient database queries with indexing
- Lazy loading for large datasets
- Optimized chart rendering
- Memory-efficient image handling

### Accessibility
- Semantic labels for screen readers
- High contrast color schemes
- Proper focus management
- Scalable text support

## 📄 License

This project is created for educational and personal use. Please ensure compliance with medical app regulations if used in a commercial context.

## 🤝 Contributing

This is a complete, standalone application. For modifications:

1. Follow Flutter coding standards
2. Maintain comprehensive documentation
3. Test thoroughly on multiple devices
4. Consider medical accuracy and user safety

---

**Remember**: This app is a tracking tool only. Always consult healthcare professionals for medical advice and use approved medical devices for blood pressure measurements.
