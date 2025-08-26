# Duolingo Clone - Flutter Language Learning App

A comprehensive Flutter application that replicates the core functionality and user experience of Duolingo, the popular language learning platform. This app features gamified learning, interactive lessons, progress tracking, and social elements to make language learning engaging and effective.

## 🚀 Features

### Core Learning Experience
- **Gamified Learning Path**: Visual, sequential lesson progression with unlockable content
- **Bite-Sized Lessons**: Short, focused lessons designed for on-the-go learning
- **Diverse Exercise Types**: Multiple exercise formats including:
  - Translation exercises
  - Multiple choice questions
  - Matching pairs
  - Listening comprehension
  - Speaking exercises
  - Fill-in-the-blank
  - Word bank exercises
  - Image selection
- **Interactive Stories**: Narrative-based learning with dialogue and comprehension tests
- **AI-Enhanced Learning**: Personalized review sessions and adaptive content

### Gamification & Motivation
- **XP System**: Earn experience points for completing lessons and activities
- **Streak Tracking**: Daily streak counter to encourage consistent practice
- **Hearts System**: Lives-based system that adds challenge and pacing
- **Gems Currency**: In-app currency for purchasing power-ups and customizations
- **Leaderboards**: Weekly competitive leagues with promotion/demotion system
- **Achievements**: Badges and milestones for various accomplishments

### Practice & Review
- **Practice Hub**: Dedicated section for targeted skill practice
- **Personalized Practice**: Algorithm-driven review of previously missed content
- **Spaced Repetition**: Intelligent review scheduling for optimal retention

### Social & Profile Features
- **User Profiles**: Personal statistics, achievements, and progress tracking
- **Friends System**: Follow friends and view their progress
- **Friend Quests**: Collaborative challenges and competitions

### Premium Features
- **Freemium Model**: Core features free with optional premium subscription
- **Ad-Free Experience**: Remove advertisements with premium subscription
- **Unlimited Hearts**: No lesson limits for premium users
- **Advanced Analytics**: Detailed progress insights and learning analytics

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App-wide constants and configuration
│   ├── theme/             # Theme configuration and styling
│   ├── utils/             # Utility functions and helpers
│   └── services/          # Core services (API, storage, etc.)
├── features/
│   ├── auth/              # Authentication and user management
│   ├── learn/             # Main learning interface and lessons
│   ├── lesson/            # Individual lesson screens and logic
│   ├── leaderboards/      # League system and competitions
│   ├── profile/           # User profile and statistics
│   ├── practice/          # Practice hub and review sessions
│   └── stories/           # Interactive story content
├── shared/
│   ├── models/            # Data models and entities
│   ├── widgets/           # Reusable UI components
│   └── services/          # Shared services and utilities
└── main.dart              # Application entry point
```

### Key Models
- **User**: User profile, progress, and gamification data
- **Lesson**: Lesson structure with exercises and metadata
- **Exercise**: Individual exercise with questions and answers
- **Achievement**: Badge system with progress tracking
- **Story**: Interactive narrative content with dialogue
- **Leaderboard**: League system with rankings and competition

### Design Patterns
- **Provider Pattern**: State management using Provider package
- **Repository Pattern**: Data access abstraction
- **Factory Pattern**: Exercise type creation and management
- **Observer Pattern**: Progress tracking and achievement notifications

## 🎨 UI/UX Design

### Design System
- **Color Palette**: Duolingo-inspired green primary with supporting colors
- **Typography**: Nunito font family for friendly, readable text
- **Icons**: Material Design icons with custom illustrations
- **Animations**: Smooth transitions and micro-interactions
- **Responsive Design**: Adaptive layouts for various screen sizes

### Key Screens
1. **Learn Screen**: Main learning path with lesson nodes
2. **Lesson Screen**: Interactive exercise interface
3. **Stories Screen**: Narrative-based learning content
4. **Practice Hub**: Targeted skill practice and review
5. **Leaderboards**: Weekly competition and rankings
6. **Profile Screen**: User statistics and achievements

## 🛠️ Technical Stack

### Framework & Language
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language for Flutter development

### Key Dependencies
- **provider**: State management solution
- **go_router**: Declarative routing and navigation
- **google_fonts**: Custom typography (Nunito font family)
- **audioplayers**: Audio playback for pronunciation exercises
- **speech_to_text**: Speech recognition for speaking exercises
- **flutter_tts**: Text-to-speech for audio generation
- **shared_preferences**: Local data persistence
- **sqflite**: Local database for offline functionality
- **lottie**: Vector animations and micro-interactions
- **uuid**: Unique identifier generation
- **intl**: Internationalization and localization

### Development Tools
- **flutter_lints**: Code quality and style enforcement
- **flutter_test**: Unit and widget testing framework

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS development tools (for iOS deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd duolingo_clone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable developer options**
   ```bash
   flutter config --enable-web  # For web development
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Analyze code quality**
   ```bash
   flutter analyze
   ```

4. **Format code**
   ```bash
   flutter format .
   ```

## 📱 Platform Support

- ✅ **Android**: Full feature support
- ✅ **iOS**: Full feature support
- 🔄 **Web**: Basic functionality (in development)
- 🔄 **Desktop**: Limited support (future enhancement)

## 🎯 Roadmap

### Phase 1: Core Features ✅
- [x] Basic navigation and UI structure
- [x] Learning path visualization
- [x] User profile and gamification elements
- [x] Theme system and design consistency

### Phase 2: Learning Engine 🔄
- [ ] Exercise type implementations
- [ ] Audio integration and speech recognition
- [ ] Progress tracking and analytics
- [ ] Offline functionality

### Phase 3: Social Features 📋
- [ ] Friends system and social interactions
- [ ] Leaderboards and competitions
- [ ] Achievement system
- [ ] Community features

### Phase 4: Advanced Features 📋
- [ ] AI-powered personalization
- [ ] Advanced analytics and insights
- [ ] Premium subscription features
- [ ] Multi-language support

### Phase 5: Platform Expansion 📋
- [ ] Web application optimization
- [ ] Desktop application support
- [ ] API integration and backend services
- [ ] Content management system

## 🤝 Contributing

We welcome contributions from the community! Please read our contributing guidelines and code of conduct before submitting pull requests.

### Development Guidelines
1. Follow Flutter/Dart style guidelines
2. Write comprehensive tests for new features
3. Update documentation for API changes
4. Use meaningful commit messages
5. Ensure code passes all linting checks

### Reporting Issues
Please use the GitHub issue tracker to report bugs or request features. Include:
- Device and OS information
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots or logs if applicable

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Duolingo for inspiration and UX patterns
- Flutter team for the excellent framework
- Open source community for valuable packages and tools
- Contributors and testers who help improve the application

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Check the documentation and FAQ
- Join our community discussions

---

**Note**: This is an educational project inspired by Duolingo. It is not affiliated with or endorsed by Duolingo Inc.
