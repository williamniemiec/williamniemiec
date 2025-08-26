# ParentSquare - Mobile Communication Platform

ParentSquare is a unified communication platform that connects schools, districts, teachers, and parents. This Flutter mobile application serves as a single hub for all school-to-home communication, ensuring parents and guardians stay informed and actively engaged in their child's education.

## Features

### 🏠 Unified Communication Hub
- **Centralized Feed**: Main home feed aggregating all posts, announcements, and alerts from district, school, and individual teachers
- **Mass Notifications & Alerts**: Urgent alerts for closures, emergencies, and general announcements
- **Direct & Group Messaging**: Secure two-way messaging between parents and teachers/staff
- **Automated Translation**: Posts and messages automatically translated into user's preferred language (100+ languages supported)
- **Cross-Platform Notifications**: Customizable notification delivery via push, email, or SMS

### 🎯 Interactive & Engagement Tools
- **Calendar & RSVPs**: Integrated calendar with event RSVP functionality
- **Appointment Sign-Ups**: Schedule parent-teacher conferences with available time slots
- **Volunteer & Supply Sign-Ups**: Easy sign-up for classroom volunteering and supply requests
- **Forms & Permission Slips**: Digital forms and permission slips with electronic signatures
- **Polls & Surveys**: Quick polls for gathering parent feedback

### 👨‍👩‍👧‍👦 Student-Specific Information
- **Attendance Notifications**: Automated alerts for absences/tardies with response capability
- **Secure Document Delivery**: Student-specific documents like report cards and health notices
- **Fee & Invoice Payments**: Secure payment system for school fees, field trips, and cafeteria balances

### 📸 Content & Media Sharing
- **Photo & Video Sharing**: View shared memories from school events and classroom activities
- **File Sharing**: Access to important documents, forms, and newsletters

## Architecture

The app follows a clean architecture pattern with feature-based organization:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   ├── utils/             # Utility functions
│   └── services/          # Core services
├── features/              # Feature modules
│   ├── home/             # Home feed functionality
│   ├── messages/         # Messaging system
│   ├── events/           # Calendar and events
│   ├── explore/          # Interactive features
│   └── more/             # Settings and profile
└── shared/               # Shared components
    ├── models/           # Data models
    ├── widgets/          # Reusable widgets
    └── services/         # Shared services
```

## Key Models

### User Model
- User profile information
- Role-based permissions (parent, teacher, staff, admin)
- Notification preferences
- Language settings

### Post Model
- Announcements and alerts
- Content with attachments
- Audience targeting
- Interaction tracking (appreciations, comments)

### Message Model
- Direct and group conversations
- Message status tracking
- File attachments
- Read receipts

### Event Model
- Calendar events with RSVP
- Recurring events support
- Attendee management
- Location and meeting links

## Navigation Structure

The app uses a bottom tab navigation with 5 main sections:

1. **Home** - Main feed with posts and announcements
2. **Messages** - Inbox for all conversations
3. **Events** - Calendar view with event management
4. **Explore** - Interactive features (sign-ups, forms, polls)
5. **More** - Settings, profile, and account management

## User Interaction Flows

### Viewing and Appreciating Announcements
1. User receives push notification
2. Taps notification to open app
3. Views post in main feed
4. Taps "Appreciate" button to acknowledge

### Responding to Teacher Messages
1. User sees message badge in Messages tab
2. Taps Messages tab to open inbox
3. Selects conversation with teacher
4. Types and sends reply

### Event RSVP Process
1. User views event in Events calendar
2. Taps event to view details
3. Selects RSVP response (Going/Maybe/Can't Go)
4. Confirmation sent to event organizer

### Volunteer Sign-up
1. User sees volunteer request in Home feed
2. Taps "Sign Up" button in post
3. Views available volunteer slots
4. Selects and confirms sign-up

## Technical Stack

- **Framework**: Flutter 3.8+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: Hive + SharedPreferences
- **Calendar**: TableCalendar
- **Notifications**: Firebase Cloud Messaging
- **Forms**: Flutter Form Builder
- **Internationalization**: Flutter Localizations

## Dependencies

### Core Dependencies
```yaml
flutter_riverpod: ^2.5.1          # State management
go_router: ^14.2.7                # Navigation
dio: ^5.7.0                       # HTTP client
hive_flutter: ^1.1.0              # Local database
shared_preferences: ^2.3.2        # Simple storage
```

### UI Dependencies
```yaml
table_calendar: ^3.1.2            # Calendar widget
cached_network_image: ^3.4.1      # Image caching
shimmer: ^3.0.0                   # Loading animations
pull_to_refresh: ^2.0.0           # Pull to refresh
```

### Firebase Dependencies
```yaml
firebase_core: ^3.6.0             # Firebase core
firebase_messaging: ^15.1.3       # Push notifications
flutter_local_notifications: ^17.2.3  # Local notifications
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.8 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions
- iOS development: Xcode (for iOS builds)
- Android development: Android SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd parent_square
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase (Optional)**
   - Create a new Firebase project
   - Add Android/iOS apps to the project
   - Download and place configuration files:
     - `android/app/google-services.json` (Android)
     - `ios/Runner/GoogleService-Info.plist` (iOS)

4. **Run the app**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   ```

### Development Setup

1. **Enable developer options**
   ```bash
   flutter config --enable-web  # If web support needed
   ```

2. **Generate code (if using code generation)**
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Analyze code**
   ```bash
   flutter analyze
   ```

## Configuration

### Environment Configuration
Create environment-specific configuration files:

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String apiBaseUrl = 'https://api.parentsquare.com/v1';
  static const String websocketUrl = 'wss://ws.parentsquare.com';
  static const bool enableLogging = true;
}
```

### Theme Customization
Modify theme settings in [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart):

```dart
static const Color primaryColor = Color(0xFF1976D2);
static const Color secondaryColor = Color(0xFF388E3C);
```

### Localization
Add new languages by:
1. Adding language codes to [`AppConstants.supportedLanguages`](lib/core/constants/app_constants.dart)
2. Creating corresponding `.arb` files in `lib/l10n/`
3. Running `flutter gen-l10n`

## Building for Production

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting with `dart format`

## Troubleshooting

### Common Issues

1. **Build failures**
   - Clean build: `flutter clean && flutter pub get`
   - Check Flutter version: `flutter --version`
   - Update dependencies: `flutter pub upgrade`

2. **Firebase issues**
   - Verify configuration files are in correct locations
   - Check package names match Firebase project
   - Ensure Firebase services are enabled

3. **Navigation issues**
   - Check route definitions in `main.dart`
   - Verify import statements
   - Test deep linking configuration

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Email: support@parentsquare.com
- Documentation: https://docs.parentsquare.com
- Issues: Create an issue in this repository

## Roadmap

### Upcoming Features
- [ ] Offline support with data synchronization
- [ ] Voice messages
- [ ] Video calling integration
- [ ] Advanced analytics dashboard
- [ ] Multi-school support for district users
- [ ] Enhanced accessibility features
- [ ] Dark mode improvements
- [ ] Biometric authentication

### Version History
- **v1.0.0** - Initial release with core communication features
- **v1.1.0** - Enhanced calendar and event management
- **v1.2.0** - Improved messaging with file attachments
- **v2.0.0** - Major UI overhaul and performance improvements
