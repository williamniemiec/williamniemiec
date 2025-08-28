# Reddit Mobile App

A complete Reddit mobile application built with Flutter, featuring a modern UI and comprehensive functionality for browsing, posting, and interacting with Reddit content.

## Features

### 🏠 Core Features
- **Personalized Home Feed**: Algorithmically curated feed from subscribed communities
- **Popular & Trending Content**: Discover what's hot across Reddit
- **Community Discovery**: Search and explore thousands of subreddits
- **Post Creation**: Create text, image, link, and poll posts
- **Voting System**: Upvote and downvote posts and comments
- **Comment Threading**: Nested comment discussions with full threading support
- **User Profiles**: View user karma, post history, and account information

### 📱 User Interface
- **Modern Material Design**: Clean, intuitive interface following Material Design 3
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Reddit-inspired Colors**: Authentic Reddit orange and blue color scheme
- **Responsive Layout**: Optimized for various screen sizes
- **Smooth Animations**: Fluid transitions and interactions

### 🔐 Authentication
- **Secure Login**: Demo authentication system (accepts any credentials for testing)
- **User Sessions**: Persistent login with secure token storage
- **Profile Management**: Update user information and preferences

### 🎯 Content Management
- **Post Types**: Support for text, image, video, link, and poll posts
- **Save Posts**: Bookmark posts for later viewing
- **Share Content**: Share posts and comments with other apps
- **Content Filtering**: Sort by Hot, New, Top, Rising, and Controversial

### 💬 Communication
- **Direct Messaging**: Private messaging between users (placeholder)
- **Notifications**: Inbox for replies, mentions, and alerts (placeholder)
- **Chat Rooms**: Group chat functionality (placeholder)

## Architecture

### 📁 Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # Theme definitions and styling
│   └── utils/             # Utility functions and helpers
├── features/
│   ├── auth/              # Authentication screens and logic
│   ├── home/              # Home feed functionality
│   ├── discover/          # Content discovery and search
│   ├── create/            # Post creation
│   ├── chat/              # Messaging features
│   ├── inbox/             # Notifications and inbox
│   ├── profile/           # User profiles
│   ├── post_detail/       # Individual post viewing
│   └── subreddit/         # Subreddit-specific screens
└── shared/
    ├── models/            # Data models
    ├── widgets/           # Reusable UI components
    └── services/          # API and data services
```

### 🏗️ Design Patterns
- **Provider Pattern**: State management using Flutter Provider
- **Repository Pattern**: Data layer abstraction
- **Feature-based Architecture**: Modular organization by features
- **Clean Architecture**: Separation of concerns and dependencies

## Models

### 📊 Data Models
- **RedditUser**: User account information and statistics
- **RedditPost**: Post content, metadata, and interactions
- **Subreddit**: Community information and settings
- **RedditComment**: Comment content with threading support
- **RedditMessage**: Direct messages and notifications
- **ChatRoom**: Group chat functionality

### 🔄 State Management
- **AuthProvider**: User authentication and session management
- **HomeProvider**: Home feed data and interactions
- **DiscoverProvider**: Search and discovery functionality
- **ProfileProvider**: User profile management

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS development setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd reddit_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Usage

The app includes a demo authentication system for testing:

1. **Login**: Enter any username and password to access the app
2. **Browse**: Explore the home feed with mock Reddit posts
3. **Interact**: Vote on posts, save content, and navigate between screens
4. **Discover**: Search for communities and trending content
5. **Profile**: View user statistics and account information

## Dependencies

### 📦 Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `go_router`: Navigation and routing
- `shared_preferences`: Local data storage

### 🌐 Network & API
- `http`: HTTP client
- `dio`: Advanced HTTP client
- `cached_network_image`: Image caching

### 🎨 UI & Media
- `flutter_svg`: SVG support
- `font_awesome_flutter`: Icon library
- `shimmer`: Loading animations
- `image_picker`: Image selection
- `video_player`: Video playback

### 🛠️ Utilities
- `intl`: Internationalization
- `timeago`: Time formatting
- `url_launcher`: External URL handling
- `share_plus`: Content sharing
- `pull_to_refresh`: Pull-to-refresh functionality

## Features Implementation Status

### ✅ Completed
- [x] Project structure and architecture
- [x] Core data models (User, Post, Subreddit, Comment, Message)
- [x] Authentication system with demo login
- [x] Home feed with post cards and voting
- [x] Discover screen with search functionality
- [x] User profile screen with statistics
- [x] Navigation system with bottom tabs
- [x] Theme system with light/dark modes
- [x] Post card UI with media support
- [x] Sort functionality (Hot, New, Top, Rising)

### 🚧 In Progress / Placeholder
- [ ] Full post detail screen with comments
- [ ] Complete post creation with all types
- [ ] Chat and messaging functionality
- [ ] Inbox and notifications
- [ ] Subreddit-specific screens
- [ ] Comment threading implementation
- [ ] Real API integration
- [ ] Advanced search filters
- [ ] User settings and preferences

## Customization

### 🎨 Theming
The app uses a comprehensive theme system located in `lib/core/theme/app_theme.dart`:

- **Colors**: Reddit-inspired orange and blue palette
- **Typography**: Custom Reddit Sans font family
- **Components**: Consistent styling across all UI elements
- **Dark Mode**: Automatic switching based on system preferences

### 🔧 Configuration
App configuration is centralized in `lib/core/constants/app_constants.dart`:

- API endpoints and URLs
- UI constants and dimensions
- Default values and settings
- Error messages and strings

## Testing

### 🧪 Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### 📊 Test Coverage
The app includes basic widget tests and can be extended with:
- Unit tests for business logic
- Integration tests for user flows
- Widget tests for UI components
- Golden tests for visual regression

## Performance

### ⚡ Optimizations
- **Image Caching**: Efficient image loading and caching
- **Lazy Loading**: Posts loaded on demand with pagination
- **State Management**: Efficient state updates with Provider
- **Memory Management**: Proper disposal of resources
- **Network Optimization**: Request caching and error handling

## Contributing

### 🤝 Development Guidelines
1. Follow the established architecture patterns
2. Write tests for new features
3. Update documentation for changes
4. Use consistent code formatting
5. Follow Flutter best practices

### 📝 Code Style
- Use meaningful variable and function names
- Add comments for complex logic
- Follow Dart naming conventions
- Keep functions small and focused
- Use const constructors where possible

## Troubleshooting

### 🐛 Common Issues

**Build Errors**
- Run `flutter clean && flutter pub get`
- Check Flutter and Dart SDK versions
- Verify all dependencies are compatible

**Navigation Issues**
- Ensure all routes are properly defined
- Check GoRouter configuration
- Verify screen imports

**State Management**
- Confirm Provider setup in main.dart
- Check context usage in widgets
- Verify notifyListeners() calls

## Future Enhancements

### 🚀 Planned Features
- Real Reddit API integration
- Advanced comment threading
- Rich text editor for posts
- Image/video upload functionality
- Push notifications
- Offline support
- Advanced search filters
- User flair and awards system
- Moderation tools
- Cross-posting functionality

### 📈 Performance Improvements
- Implement virtual scrolling for large lists
- Add image compression and optimization
- Implement background sync
- Add analytics and crash reporting
- Optimize bundle size

## License

This project is created for educational and demonstration purposes. Please ensure compliance with Reddit's API terms of service if integrating with real Reddit data.

## Support

For questions, issues, or contributions, please refer to the project documentation or create an issue in the repository.

---

**Built with ❤️ using Flutter**
