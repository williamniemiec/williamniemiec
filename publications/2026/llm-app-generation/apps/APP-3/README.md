# Microsoft Teams Mobile App

A comprehensive Microsoft Teams mobile application built with Flutter, featuring real-time communication, collaboration tools, and meeting capabilities.

## 📱 Features

### Communication & Chat
- **1:1 and Group Chats**: Secure instant messaging with individuals or groups
- **Teams and Channels**: Create teams for specific groups/projects with topic-specific channels
- **Rich Messaging**: Support for GIFs, emojis, stickers, and message animations
- **@mentions**: Tag specific users in chats or channels
- **Threaded Conversations**: Organized replies under initial posts
- **Message Reactions**: React to messages with emojis

### Meetings & Calling
- **Audio and Video Calls**: High-definition 1:1 or group calling
- **Scheduled Meetings**: Create and manage meetings with integrated calendar
- **Instant Meetings**: Start meetings instantly from any chat or channel
- **Screen Sharing**: Share device screen, presentations, or photos
- **Virtual Backgrounds**: Blur background or use custom images
- **Meeting Recording**: Record meetings for later review

### Collaboration & File Management
- **File Sharing**: Securely share files, photos, and videos
- **Cloud Storage**: Integrated with OneDrive for cloud file access
- **Document Collaboration**: Co-author Microsoft 365 documents in-app
- **Centralized File Access**: Dedicated file storage per channel

### Productivity & Organization
- **Activity Feed**: Consolidated view of notifications and alerts
- **Integrated Calendar**: Full-featured calendar for schedules and meetings
- **Task Management**: Create and manage personal and team tasks
- **Global Search**: Find people, chats, files, and information

### Personal & Community Features
- **Communities**: Dedicated spaces for personal groups (family, friends, clubs)
- **Community Events**: Organize shared events with dedicated calendars
- **Shared Content Hub**: Centralized place for photos, files, and links

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theme and styling
│   ├── utils/             # Utility functions
│   ├── services/          # Core services (auth, storage, etc.)
│   └── providers/         # Global providers
├── features/
│   ├── auth/              # Authentication feature
│   │   ├── screens/       # Login, signup screens
│   │   ├── widgets/       # Auth-related widgets
│   │   └── providers/     # Auth state management
│   ├── chat/              # Chat functionality
│   ├── teams/             # Teams and channels
│   ├── activity/          # Activity feed
│   ├── calendar/          # Calendar and meetings
│   ├── meetings/          # Video calling features
│   ├── files/             # File management
│   └── search/            # Search functionality
├── shared/
│   ├── models/            # Data models
│   ├── widgets/           # Reusable widgets
│   └── services/          # Shared services
└── main.dart              # App entry point
```

### State Management
- **Riverpod**: Primary state management solution
- **Hive**: Local data persistence
- **Firebase**: Backend services and real-time updates

### Key Technologies
- **Flutter**: Cross-platform mobile framework
- **Firebase**: Authentication, real-time database, cloud messaging
- **Hive**: Local storage and caching
- **Riverpod**: State management
- **Material Design**: UI components and theming

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd teams_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Hive adapters)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Firebase Setup**
   - Create a Firebase project
   - Add your app to Firebase (Android/iOS/Web)
   - Download configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
     - Update web configuration in `web/index.html`

5. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### Firebase Configuration
Update the Firebase configuration in:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `web/index.html` (Firebase config object)

#### Environment Variables
Create a `.env` file in the root directory:
```env
API_BASE_URL=https://api.teams.microsoft.com
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

## 📱 User Interface

### Bottom Navigation
- **Activity**: Notifications and activity feed
- **Chat**: Recent conversations and direct messages
- **Teams**: Team list with expandable channels
- **Calendar**: Schedule and meeting management
- **More**: Additional features and settings

### Key Screens

#### Authentication
- Login with email/password or Google Sign-In
- User registration and profile setup
- Password reset functionality

#### Chat Interface
- Message bubbles with sender information
- Rich text support with emojis and reactions
- File attachment and media sharing
- Typing indicators and read receipts

#### Teams & Channels
- Expandable team list with channel hierarchy
- Channel-specific conversations and files
- Member management and permissions
- Team creation and joining workflows

#### Calendar & Meetings
- Monthly/weekly calendar views
- Meeting scheduling and management
- Join meeting functionality
- Meeting history and recordings

## 🔧 Development

### Code Generation
The app uses code generation for:
- **Hive Type Adapters**: For local storage models
- **JSON Serialization**: For API communication

Run code generation:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

### Building for Production

#### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## 🎨 Theming

The app supports both light and dark themes with Microsoft Teams branding:

### Colors
- **Primary Blue**: `#6264A7`
- **Primary Purple**: `#464775`
- **Accent Blue**: `#5B5FC7`
- **Success Green**: `#92C353`
- **Warning Orange**: `#FFAA44`
- **Error Red**: `#D13438`

### Typography
- **Font Family**: Segoe UI (fallback to system fonts)
- **Text Styles**: Material Design 3 text theme
- **Responsive**: Adapts to system font size settings

## 🔐 Security

### Authentication
- Firebase Authentication with email/password
- Google Sign-In integration
- JWT token management
- Automatic token refresh

### Data Protection
- End-to-end encryption for messages
- Secure file storage and transmission
- User data privacy compliance
- Local data encryption with Hive

### Permissions
- Role-based access control
- Team and channel permissions
- Admin controls and moderation
- Guest user limitations

## 📊 Performance

### Optimization Strategies
- **Lazy Loading**: Load content on demand
- **Image Caching**: Cached network images
- **Local Storage**: Hive for fast data access
- **State Management**: Efficient Riverpod providers
- **Memory Management**: Proper widget disposal

### Monitoring
- Firebase Analytics integration
- Crash reporting with Firebase Crashlytics
- Performance monitoring
- User engagement tracking

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run tests and ensure they pass
6. Submit a pull request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add documentation for public APIs
- Maintain consistent formatting

### Commit Messages
Use conventional commit format:
```
feat: add video calling functionality
fix: resolve chat message ordering issue
docs: update API documentation
```

## 📝 API Documentation

### Authentication Endpoints
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `POST /auth/refresh` - Token refresh
- `POST /auth/logout` - User logout

### Chat Endpoints
- `GET /chats` - Get user chats
- `POST /chats` - Create new chat
- `GET /chats/{id}/messages` - Get chat messages
- `POST /chats/{id}/messages` - Send message

### Teams Endpoints
- `GET /teams` - Get user teams
- `POST /teams` - Create new team
- `GET /teams/{id}/channels` - Get team channels
- `POST /teams/{id}/channels` - Create channel

### Meeting Endpoints
- `GET /meetings` - Get user meetings
- `POST /meetings` - Schedule meeting
- `PUT /meetings/{id}` - Update meeting
- `DELETE /meetings/{id}` - Cancel meeting

## 🐛 Troubleshooting

### Common Issues

#### Firebase Configuration
**Error**: "FirebaseOptions cannot be null"
**Solution**: Ensure Firebase configuration files are properly added and configured

#### Build Issues
**Error**: "Unable to find directory entry in pubspec.yaml"
**Solution**: Remove unused asset references from pubspec.yaml

#### State Management
**Error**: "Provider not found"
**Solution**: Ensure providers are properly wrapped with ProviderScope

### Debug Mode
Enable debug logging:
```dart
// In main.dart
void main() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  }
  runApp(MyApp());
}
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design for UI guidelines
- Microsoft Teams for design inspiration
- Open source community for packages and tools

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Check the documentation
- Review existing issues and discussions

---

**Note**: This is a demonstration app built for educational purposes. For production use, ensure proper Firebase configuration, security rules, and compliance with relevant regulations.
