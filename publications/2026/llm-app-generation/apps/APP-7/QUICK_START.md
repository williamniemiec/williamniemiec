# ParentSquare - Quick Start Guide

This guide will help you get the ParentSquare Flutter app up and running quickly.

## Prerequisites

- Flutter SDK 3.8+
- Dart SDK 3.0+
- Android Studio or VS Code with Flutter extensions
- Git

## Quick Setup (5 minutes)

### 1. Clone and Setup
```bash
# Clone the repository
git clone <repository-url>
cd parent_square

# Install dependencies
flutter pub get
```

### 2. Run the App
```bash
# Start the app in debug mode
flutter run
```

That's it! The app should now be running on your device/emulator.

## What You'll See

### 🏠 Home Screen
- Sample posts and announcements
- Feed filter options (All, District, School, Classroom, Urgent)
- Floating action button to create new posts

### 💬 Messages Screen
- Mock conversations with teachers and groups
- Unread message indicators
- Search functionality

### 📅 Events Screen
- Interactive calendar with sample events
- Event cards with RSVP options
- Today button to jump to current date

### 🔍 Explore Screen
- Quick action cards for common tasks
- Category grid for different features
- Recent activity timeline

### ⚙️ More Screen
- User profile section
- Settings and preferences
- Help and support options

## Key Features to Try

### 1. Navigate Between Tabs
Use the bottom navigation bar to switch between:
- Home (feed)
- Messages (inbox)
- Events (calendar)
- Explore (features)
- More (settings)

### 2. Interact with Posts
- Tap the heart icon to "appreciate" posts
- Tap comment icon to view comments
- Tap share icon to share posts

### 3. Browse Events
- Tap on calendar dates to see events
- Use format button to switch calendar views
- Tap events to see details and RSVP

### 4. Explore Features
- Tap quick action cards in Explore
- Browse category cards for different features
- Check recent activity timeline

## Mock Data

The app currently uses mock data to demonstrate functionality:

- **Sample Users**: Teachers, principals, and parents
- **Sample Posts**: Announcements, alerts, and events
- **Sample Messages**: Conversations with different participants
- **Sample Events**: School activities with RSVP options

## Customization

### Change App Theme
Edit [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart):
```dart
static const Color primaryColor = Color(0xFF1976D2); // Change this
```

### Modify Mock Data
Update sample data in respective screen files:
- Home posts: [`lib/features/home/screens/home_screen.dart`](lib/features/home/screens/home_screen.dart)
- Messages: [`lib/features/messages/screens/messages_screen.dart`](lib/features/messages/screens/messages_screen.dart)
- Events: [`lib/features/events/screens/events_screen.dart`](lib/features/events/screens/events_screen.dart)

## Next Steps

1. **Connect to Backend**: Replace mock data with real API calls
2. **Add Authentication**: Implement user login/registration
3. **Enable Push Notifications**: Configure Firebase messaging
4. **Add Real-time Features**: Implement WebSocket connections
5. **Customize Branding**: Update colors, fonts, and logos

## Troubleshooting

### App Won't Start?
```bash
flutter clean
flutter pub get
flutter run
```

### Build Errors?
```bash
flutter doctor
flutter analyze
```

### Need Help?
- Check the full [README.md](README.md) for detailed documentation
- Review Flutter documentation: https://docs.flutter.dev
- Check issues in the repository

## Development Tips

### Hot Reload
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Debugging
- Use `print()` statements for quick debugging
- Use Flutter Inspector in your IDE
- Check debug console for errors

### Code Structure
```
lib/
├── main.dart              # App entry point
├── core/                  # Core functionality
├── features/              # Feature modules
│   ├── home/             # Home feed
│   ├── messages/         # Messaging
│   ├── events/           # Calendar
│   ├── explore/          # Interactive features
│   └── more/             # Settings
└── shared/               # Shared components
```

Happy coding! 🚀