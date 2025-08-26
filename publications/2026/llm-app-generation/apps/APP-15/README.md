# Blink Fitness Mobile App

A comprehensive Flutter mobile application for Blink Fitness gym members, providing digital gym access, membership management, and curated fitness content.

## Features

### 🏋️ Gym Access & Membership Management
- **Mobile Check-In**: Digital barcode/QR code for contactless gym entry
- **Membership Management**: View membership details, status, and billing information
- **Guest Privileges**: Invite guests and manage guest passes
- **Secure Authentication**: Firebase-based user authentication

### 📱 Personalized Fitness Content
- **Curated Content Feed**: Workout videos, audio coaching, recipes, and meditations
- **Content Partners**: Integration with Aaptiv, Daily Burn, Sworkit, and more
- **Personalization**: Content recommendations based on fitness goals
- **Search & Filter**: Find content by category, difficulty, duration, and partner

### 🔗 Health Integration
- **Apple HealthKit**: Connect and sync workout data
- **Activity Tracking**: Monitor fitness progress and achievements

## Architecture

The app follows a clean architecture pattern with the following structure:

```
lib/
├── core/
│   ├── constants/     # App constants and strings
│   ├── theme/         # App theme and styling
│   └── utils/         # Utilities and routing
├── features/
│   ├── auth/          # Authentication screens and logic
│   ├── home/          # Home screen with barcode and quick actions
│   ├── content/       # Content library and filtering
│   └── account/       # Account management and settings
└── shared/
    ├── models/        # Data models with Hive persistence
    ├── widgets/       # Reusable UI components
    └── services/      # Shared services
```

## Tech Stack

- **Framework**: Flutter 3.8+
- **State Management**: Provider
- **Navigation**: GoRouter
- **Local Storage**: Hive
- **Authentication**: Firebase Auth
- **UI Components**: Material Design 3
- **Networking**: Dio & HTTP
- **Image Caching**: CachedNetworkImage
- **Video Player**: Chewie
- **QR/Barcode**: QR Flutter & Mobile Scanner
- **Health Integration**: Health package

## Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd blink_fitness_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS apps to your Firebase project
   - Download and place `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Authentication with Email/Password provider

5. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### Android NDK Version
If you encounter NDK version conflicts, add this to `android/app/build.gradle.kts`:

```kotlin
android {
    ndkVersion = "27.0.12077973"
    // ... other configurations
}
```

#### Firebase Configuration
Ensure Firebase is properly configured:
- Place `google-services.json` in `android/app/`
- Place `GoogleService-Info.plist` in `ios/Runner/`
- Enable Authentication in Firebase Console

## App Screens

### 🏠 Home Screen
- **Digital Check-in**: Large QR code for gym access
- **Quick Actions**: Invite guest, manage billing
- **Featured Content**: Personalized workout recommendations
- **Recent Activity**: Check-in history and membership info

### 📚 Content Library
- **Tabbed Interface**: All content, Videos, Audio, Articles
- **Advanced Filtering**: Category, difficulty, partner, duration
- **Search Functionality**: Find specific workouts or content
- **Content Cards**: Rich preview with ratings and metadata

### 👤 Account Management
- **Profile Management**: Update personal information
- **Membership Details**: Plan info, billing, and status
- **Guest Passes**: Manage and invite guests
- **Settings**: Notifications, privacy, and app preferences

### 🔐 Authentication
- **Login/Register**: Email and password authentication
- **Password Reset**: Secure password recovery
- **Form Validation**: Comprehensive input validation

## Data Models

### User Model
- Personal information and preferences
- Membership details and status
- Fitness goals and health data
- Guest pass management

### Content Model
- Workout videos, audio, and articles
- Metadata (duration, difficulty, category)
- Partner information and ratings
- User engagement tracking

### Membership Model
- Plan details and billing information
- Payment methods and transaction history
- Status tracking and notifications
- Guest pass allocations

## Key Features Implementation

### Mobile Check-in
- QR code generation using user's membership ID
- Barcode display with full-screen option
- Automatic refresh for security

### Content Personalization
- Initial onboarding questionnaire
- Dynamic content filtering based on preferences
- Engagement tracking for improved recommendations

### Offline Support
- Hive local database for offline access
- Cached content and user data
- Sync when connection is restored

## Testing

Run tests with:
```bash
flutter test
```

For widget tests:
```bash
flutter test test/widget_test.dart
```

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Email: support@blinkfitness.com
- Documentation: [App Documentation](docs/)
- Issues: [GitHub Issues](issues/)

---

**Blink Fitness App** - Your digital gym companion 💪
