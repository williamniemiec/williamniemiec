# Google Home App

A comprehensive Flutter mobile application that serves as the central command center for managing and controlling smart home ecosystems. This app provides unified control of Google Nest, Google Wifi, Chromecast devices, and thousands of compatible third-party smart home products.

## Features

### 🏠 Unified Device Management
- **Device Setup**: Guided step-by-step process to add and configure new Google and "Works with Google Home" compatible devices
- **Room Organization**: Assign devices to specific rooms for organized control and group actions
- **Device Control**: Individual control interfaces for lights, thermostats, smart plugs, cameras, speakers, displays, and more

### ⭐ Personalized Home Dashboard (Favorites)
- **Customizable View**: Pin frequently used devices, actions, and automations to the primary "Favorites" tab
- **Spaces**: Interactive chips for quick access to device categories (Cameras, Lighting, Climate, etc.)
- **Media Controller**: Universal media player that appears when content is playing on any connected device

### 🤖 Home Automation (Routines)
- **Pre-set Routines**: Ready-to-use automations like "Good Morning" and "Bedtime"
- **Custom Routine Creation**: Powerful editor to create custom automations with:
  - **Starters**: Voice commands, time of day, sunrise/sunset, device state changes, location triggers
  - **Actions**: Adjust lights, set thermostat, play media, broadcast messages, control devices

### 🔒 Home Monitoring and Security
- **Live Camera Feeds**: View live video streams from all connected Nest Cams and Doorbells
- **Event History**: Scannable timeline of recorded events (motion detection, person alerts, package deliveries)
- **Activity Feed**: Chronological feed of important home events

### 👥 User and Home Management
- **Home Members**: Invite family members with shared device control
- **Consolidated Settings**: Organized settings for device permissions, notifications, and linked services
- **Privacy Controls**: Manage how Google uses device and activity data

## Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   └── providers/         # State management providers
├── features/
│   ├── favorites/         # Home dashboard and favorite devices
│   ├── devices/          # Device management and room organization
│   ├── automations/      # Routine creation and management
│   ├── activity/         # Event timeline and monitoring
│   └── settings/         # App configuration and preferences
└── shared/
    ├── models/           # Data models (Device, Room, Routine, Activity)
    ├── widgets/          # Reusable UI components
    └── services/         # API and data services
```

### Key Components

#### Models
- **Device**: Represents smart home devices with properties, status, and controls
- **Room**: Organizes devices by physical location
- **Routine**: Defines automation rules with starters and actions
- **Activity**: Tracks home events and notifications

#### State Management
- Uses Provider pattern for reactive state management
- Centralized AppProvider manages all app state
- Proper lifecycle management to prevent memory leaks

#### UI/UX Design
- Material Design 3 with Google's design language
- Responsive layouts for different screen sizes
- Smooth animations and transitions
- Accessibility support

## Getting Started

### Prerequisites
- Flutter SDK (>=3.1.0)
- Dart SDK
- Android Studio / VS Code
- Android/iOS development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd google_home_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Testing

Run the test suite:
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```

## Dependencies

### Core Dependencies
- `provider: ^6.1.1` - State management
- `material_design_icons_flutter: ^7.0.7296` - Material Design icons
- `go_router: ^12.1.3` - Navigation and routing
- `intl: ^0.19.0` - Internationalization
- `shared_preferences: ^2.2.2` - Local storage
- `http: ^1.1.2` - HTTP requests
- `cached_network_image: ^3.3.0` - Image caching
- `lottie: ^2.7.0` - Animations
- `device_info_plus: ^9.1.1` - Device information
- `permission_handler: ^11.1.0` - Permission management

### Development Dependencies
- `flutter_test` - Testing framework
- `flutter_lints: ^3.0.0` - Linting rules

## User Interaction Flows

### 1. Device Setup Flow
1. Open app → Sign in with Google Account → Create "Home"
2. App scans for nearby unconfigured devices using Bluetooth/location
3. User taps "New device found" prompt
4. Follow guided setup: confirm device code → connect to Wi-Fi → assign to room
5. Device appears in "Devices" tab and can be added to "Favorites"

### 2. Creating Automation Routines
1. Navigate to "Automations" tab
2. Tap "+" floating action button
3. Add starter (voice command, time, device state, etc.)
4. Add actions (adjust devices, play media, send notifications)
5. Save routine for automatic execution

### 3. Monitoring Home Activity
1. Receive push notification for events (motion detected, person seen, etc.)
2. Tap notification to open live camera feed
3. Review timeline of recent events
4. Use talk feature to communicate through camera speakers

## Customization

### Theming
The app supports both light and dark themes with Google's Material Design 3 color system. Themes can be customized in `lib/core/theme/app_theme.dart`.

### Adding New Device Types
1. Extend the `DeviceType` enum in `lib/shared/models/device.dart`
2. Add corresponding icons and colors in widget files
3. Implement device-specific controls in UI components

### Extending Automation
1. Add new starter types in `lib/shared/models/routine.dart`
2. Implement corresponding UI in automation screens
3. Add action types for new device capabilities

## Performance Considerations

- **Lazy Loading**: Screens load data after initial render to prevent build-time state changes
- **Efficient State Management**: Provider pattern with targeted rebuilds
- **Image Optimization**: Cached network images for better performance
- **Memory Management**: Proper disposal of controllers and listeners

## Security & Privacy

- **Local Data Storage**: Sensitive data stored securely using shared preferences
- **Permission Management**: Granular control over device permissions
- **Privacy Controls**: User control over data collection and usage
- **Secure Communication**: HTTPS for all network communications

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Google Material Design team for design guidelines
- Flutter team for the excellent framework
- Contributors to the open-source packages used in this project

---

**Note**: This is a demonstration app showcasing Google Home functionality. For production use, proper API integrations, authentication, and device communication protocols would need to be implemented.
