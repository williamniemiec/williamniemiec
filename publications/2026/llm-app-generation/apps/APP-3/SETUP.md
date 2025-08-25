# Microsoft Teams App - Setup Guide

This guide will help you set up and run the Microsoft Teams mobile application built with Flutter.

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
- **Flutter SDK** (3.8.1 or higher)
  - Download from: https://flutter.dev/docs/get-started/install
- **Dart SDK** (included with Flutter)
- **Git** for version control
- **Code Editor**: VS Code or Android Studio

### Platform-Specific Requirements

#### For Android Development
- **Android Studio** with Android SDK
- **Java Development Kit (JDK)** 8 or higher
- **Android device** or emulator

#### For iOS Development (macOS only)
- **Xcode** (latest version)
- **iOS Simulator** or physical iOS device
- **CocoaPods** (`sudo gem install cocoapods`)

#### For Web Development
- **Chrome browser** for testing

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd teams_app

# Install Flutter dependencies
flutter pub get

# Generate code for Hive adapters
flutter packages pub run build_runner build
```

### 2. Verify Flutter Installation

```bash
# Check Flutter installation
flutter doctor

# List available devices
flutter devices
```

### 3. Run the Application

```bash
# Run on Chrome (Web)
flutter run -d chrome

# Run on Android device/emulator
flutter run -d android

# Run on iOS simulator (macOS only)
flutter run -d ios
```

## 🔥 Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `teams-app-[your-name]`
4. Enable Google Analytics (optional)
5. Create project

### 2. Configure Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password**
5. Enable **Google** sign-in
6. Add your domain to authorized domains

### 3. Setup Firestore Database

1. Go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode**
4. Select location closest to your users

### 4. Add Apps to Firebase Project

#### For Android:
1. Click **Add app** → **Android**
2. Package name: `com.microsoft.teams.teams_app`
3. Download `google-services.json`
4. Place in `android/app/` directory

#### For iOS:
1. Click **Add app** → **iOS**
2. Bundle ID: `com.microsoft.teams.teamsApp`
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/` in Xcode

#### For Web:
1. Click **Add app** → **Web**
2. App nickname: `Teams App Web`
3. Copy the config object
4. Update `web/index.html` with Firebase config

### 5. Update Firebase Configuration

Replace the demo configuration in your app:

**For Web** - Update `web/index.html`:
```html
<script type="module">
  import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js';
  
  const firebaseConfig = {
    apiKey: "your-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "your-app-id"
  };
  
  initializeApp(firebaseConfig);
</script>
```

## 📱 Platform-Specific Setup

### Android Setup

1. **Update Android Configuration**
   ```bash
   # Open Android project in Android Studio
   cd android
   ./gradlew clean
   ```

2. **Update `android/app/build.gradle`**
   ```gradle
   android {
       compileSdkVersion 34
       minSdkVersion 21
       targetSdkVersion 34
   }
   ```

3. **Add Internet Permission**
   In `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.RECORD_AUDIO" />
   ```

### iOS Setup

1. **Update iOS Configuration**
   ```bash
   cd ios
   pod install
   ```

2. **Update `ios/Runner/Info.plist`**
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access for video calls</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>This app needs microphone access for audio calls</string>
   ```

### Web Setup

1. **Update `web/index.html`**
   - Add Firebase configuration
   - Ensure proper meta tags for PWA

2. **Enable HTTPS for local development**
   ```bash
   flutter run -d chrome --web-hostname localhost --web-port 3000
   ```

## 🔧 Development Environment

### VS Code Extensions
Install these helpful extensions:
- **Flutter** by Dart Code
- **Dart** by Dart Code
- **Firebase** by Firebase
- **GitLens** by GitKraken
- **Bracket Pair Colorizer** by CoenraadS

### VS Code Settings
Create `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.debugExternalLibraries": false,
  "dart.debugSdkLibraries": false,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

### Launch Configuration
Create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Debug)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": ["--debug"]
    },
    {
      "name": "Flutter (Release)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": ["--release"]
    }
  ]
}
```

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Test with coverage
flutter test --coverage
```

### Test Configuration
Create `test/test_config.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> setupTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Register adapters
  // Setup mock data
}
```

## 🚀 Building for Production

### Android Release Build
```bash
# Generate keystore (first time only)
keytool -genkey -v -keystore ~/teams-app-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias teams-app

# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS Release Build
```bash
# Build for iOS
flutter build ios --release

# Archive in Xcode for App Store submission
```

### Web Release Build
```bash
# Build for web
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## 🔍 Troubleshooting

### Common Issues

#### 1. Firebase Configuration Error
**Error**: "FirebaseOptions cannot be null"
**Solution**: 
- Ensure Firebase config files are in correct locations
- Verify Firebase project is properly set up
- Check that Firebase is initialized in `main.dart`

#### 2. Build Errors
**Error**: "Unable to find directory entry in pubspec.yaml"
**Solution**: 
- Remove unused asset references from `pubspec.yaml`
- Run `flutter clean` and `flutter pub get`

#### 3. Hive Adapter Issues
**Error**: "No adapter registered"
**Solution**: 
- Run `flutter packages pub run build_runner build`
- Ensure adapters are registered in `main.dart`

#### 4. Permission Errors (Mobile)
**Error**: Camera/Microphone not working
**Solution**: 
- Add proper permissions to platform-specific files
- Request runtime permissions in app

### Debug Commands
```bash
# Clean build cache
flutter clean

# Reinstall dependencies
flutter pub get

# Regenerate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check for issues
flutter doctor -v

# Analyze code
flutter analyze
```

## 📊 Performance Optimization

### Build Optimization
```bash
# Build with tree shaking
flutter build apk --release --tree-shake-icons

# Build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=debug-info/
```

### Memory Management
- Use `const` constructors where possible
- Dispose controllers and streams properly
- Implement lazy loading for large lists
- Cache images and data appropriately

## 🔐 Security Considerations

### Firebase Security Rules
Update Firestore rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participants;
    }
  }
}
```

### App Security
- Enable code obfuscation for release builds
- Use secure storage for sensitive data
- Implement proper authentication flows
- Validate all user inputs

## 📞 Support

If you encounter issues:

1. **Check Documentation**: Review this guide and README.md
2. **Flutter Doctor**: Run `flutter doctor` to check setup
3. **Clean Build**: Try `flutter clean` and rebuild
4. **Check Logs**: Use `flutter logs` for runtime issues
5. **Community**: Search Flutter and Firebase communities

## 🎯 Next Steps

After successful setup:

1. **Customize Branding**: Update app icons, colors, and themes
2. **Add Features**: Implement additional functionality
3. **Testing**: Write comprehensive tests
4. **Deployment**: Set up CI/CD pipeline
5. **Monitoring**: Add analytics and crash reporting

---

**Happy Coding!** 🚀

For more detailed information, refer to the main [README.md](README.md) file.