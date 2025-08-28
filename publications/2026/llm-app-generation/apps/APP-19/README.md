# MyChart Mobile App

A comprehensive patient portal mobile application built with Flutter, providing secure access to health information and healthcare services.

## Overview

MyChart is a secure, centralized patient portal that puts users' health information directly into the palm of their hand. The app empowers patients to conveniently and actively manage their healthcare and the care of their family members through proxy access.

## Features

### 🏥 Health Record & Information Access
- **Test Results**: View lab results with reference ranges as soon as they're available
- **Health Summary**: Access comprehensive summaries of current health issues, medications, allergies, and immunizations
- **After Visit Summary**: Review summaries and clinical notes from past appointments and hospital stays
- **Medical History**: View and manage personal and family medical history
- **Medication Management**: View current medications and request prescription refills

### 💬 Communication & Care Team Interaction
- **Secure Messaging**: Send and receive secure, non-urgent messages with care team
- **Photo Uploads**: Attach images to messages for assessment and monitoring
- **Priority Messages**: Support for urgent and high-priority communications

### 📅 Appointment Management
- **Scheduling**: Schedule, manage, and cancel appointments for in-person and video visits
- **eCheck-In**: Complete pre-appointment tasks to save time at the clinic
- **Appointment Types**: Support for in-person, video, and phone appointments
- **Provider Information**: View detailed provider and department information

### 💰 Billing & Financials
- **Bill Viewing**: View detailed statements and outstanding balances
- **Online Bill Pay**: Securely pay medical bills using credit card or bank account
- **Payment Plans**: Set up and manage payment plans for outstanding balances
- **Payment History**: Track payment history and account balance

### 👨‍👩‍👧‍👦 Cross-Platform & Family Management
- **Proxy Access**: Request and manage access to family members' MyChart accounts
- **Account Linking**: Connect accounts from multiple healthcare organizations
- **Push Notifications**: Receive alerts for new information and appointments
- **Biometric Authentication**: Secure login with Face ID/Touch ID support

## Technical Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   └── utils/             # Utility functions
├── features/
│   ├── auth/              # Authentication and login
│   ├── home/              # Dashboard and home screen
│   ├── appointments/      # Appointment management
│   ├── messages/          # Secure messaging
│   ├── records/           # Health records and test results
│   └── billing/           # Billing and payments
└── shared/
    ├── models/            # Data models
    ├── widgets/           # Reusable UI components
    └── services/          # API and data services
```

### Key Technologies
- **Framework**: Flutter 3.8+
- **State Management**: Provider pattern
- **HTTP Client**: Dio for API communication
- **Local Storage**: SharedPreferences and SQLite
- **Authentication**: Local authentication with biometric support
- **UI Components**: Material Design 3
- **Date Handling**: Intl package for internationalization

## Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Chrome browser (for web testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mychart_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For web (Chrome)
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

### Demo Credentials
For testing purposes, you can use any email and password combination to log into the demo app. The app will simulate a logged-in user experience with sample data.

## App Navigation

The app uses a bottom navigation bar with five main sections:

1. **Home** - Dashboard with health feed and quick actions
2. **Appointments** - Upcoming and past appointments
3. **Messages** - Secure messaging inbox
4. **My Record** - Health records, test results, medications, and immunizations
5. **Billing** - Account balance, bills, and payment options

## Key User Flows

### 1. Viewing New Test Results
1. User receives push notification about new test results
2. Taps notification to open app and authenticate
3. Views new test result alert on home screen
4. Taps alert to navigate to detailed test results
5. Reviews values, reference ranges, and provider comments

### 2. Scheduling an Appointment
1. User navigates to Appointments section
2. Taps "Schedule Appointment" button
3. Selects reason for visit, preferred provider, and available time slot
4. Confirms appointment details
5. Appointment is added to schedule with eCheck-in option

### 3. Paying Medical Bills
1. User navigates to Billing section
2. Views account balance and pending bills
3. Selects bill and taps "Pay Now"
4. Enters payment amount and selects payment method
5. Reviews and confirms payment
6. Receives payment confirmation

## Security Features

- **Biometric Authentication**: Face ID, Touch ID, and fingerprint support
- **Secure Storage**: Encrypted local storage for sensitive data
- **Session Management**: Automatic logout after inactivity
- **HTTPS Communication**: All API calls use secure HTTPS
- **Data Encryption**: Patient data encrypted in transit and at rest

## Customization

### Theming
The app uses a healthcare-focused color scheme with primary blue colors. Themes can be customized in:
- `lib/core/constants/app_colors.dart` - Color definitions
- `lib/core/theme/app_theme.dart` - Theme configuration

### Configuration
App configuration can be modified in:
- `lib/core/constants/app_constants.dart` - API endpoints, timeouts, and app settings

## Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Structure
- Unit tests for business logic and data models
- Widget tests for UI components
- Integration tests for complete user flows

## Build and Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS app
flutter build ios --release
```

### Web
```bash
# Build web app
flutter build web --release
```

## Performance Considerations

- **Lazy Loading**: Screens and data loaded on demand
- **Image Caching**: Cached network images for better performance
- **State Management**: Efficient state updates with Provider
- **Memory Management**: Proper disposal of controllers and streams

## Accessibility

The app includes comprehensive accessibility features:
- Screen reader support
- High contrast mode compatibility
- Keyboard navigation support
- Semantic labels for all interactive elements
- Scalable text support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## Changelog

### Version 1.0.0
- Initial release with core features
- Authentication and security implementation
- Complete patient portal functionality
- Cross-platform support (iOS, Android, Web)

---

**Note**: This is a demo application for educational purposes. In a production environment, ensure proper security measures, HIPAA compliance, and integration with actual healthcare systems.
