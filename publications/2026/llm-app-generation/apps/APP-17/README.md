# Tea - Your AI-Powered Dating Wingman 🍵

Tea is a Flutter mobile application that acts as an AI-powered "dating wingman," designed to help users navigate the complexities of modern online dating. The app provides instant, personalized advice, generates engaging conversational content, and offers constructive feedback on dating profiles.

## 🎯 App Purpose

The Tea app aims to increase users' confidence and success on dating platforms by providing:
- Instant, personalized dating advice
- AI-powered conversation analysis and reply suggestions
- Dating profile optimization through constructive feedback
- Creative bio generation based on user interests
- Clever pickup lines and conversation starters

## ✨ Features

### Core Features

1. **AI Conversation Analysis** 📱
   - Upload screenshots of dating app conversations
   - Get AI-powered analysis of conversation tone and context
   - Receive witty, engaging reply suggestions
   - Tips for maintaining conversation flow

2. **AI Profile Review ("Roast")** 🔥
   - Submit dating profile (bio and photos) for AI critique
   - Receive constructive feedback with humor
   - Get actionable improvement suggestions
   - Profile scoring and optimization tips

3. **AI Bio Generator** ✍️
   - Create unique and compelling dating profile bios
   - Input personality traits and interests
   - Generate multiple bio variations (witty, detailed, playful)
   - Tailored content for different dating platforms

4. **"Rizz" & Opener Generator** 💬
   - Library of clever pickup lines and conversation starters
   - Context-aware suggestions based on profiles
   - Witty comebacks and responses
   - Personalized opening messages

5. **General Dating Advice Chat** 🤖
   - Conversational AI chatbot for dating questions
   - First-date ideas and tips
   - Signal interpretation and relationship advice
   - 24/7 availability for dating guidance

6. **Subscription Model** 💎
   - Freemium model with daily usage limits
   - Premium subscription for unlimited access
   - Multiple subscription tiers (weekly, monthly, lifetime)

## 🏗️ Architecture

### Project Structure

```
tea_app/
├── lib/
│   ├── constants/
│   │   ├── app_constants.dart      # App-wide constants and configurations
│   │   └── app_theme.dart          # Theme definitions and styling
│   ├── models/
│   │   ├── user.dart               # User data model
│   │   ├── chat_message.dart       # Chat message model
│   │   ├── subscription.dart       # Subscription model
│   │   └── dating_profile.dart     # Dating profile model
│   ├── services/
│   │   ├── ai_service.dart         # AI integration service
│   │   ├── storage_service.dart    # Local data persistence
│   │   ├── subscription_service.dart # In-app purchase management
│   │   └── image_service.dart      # Image handling and upload
│   ├── providers/
│   │   └── tea_provider.dart       # State management with Provider
│   ├── screens/
│   │   ├── onboarding_screen.dart  # App onboarding flow
│   │   ├── home_screen.dart        # Main chat interface
│   │   └── subscription_screen.dart # Premium upgrade screen
│   ├── widgets/
│   │   ├── chat_bubble.dart        # Chat message UI component
│   │   ├── feature_selection_card.dart # Feature selection cards
│   │   └── subscription_banner.dart # Premium upgrade banner
│   └── main.dart                   # App entry point
├── assets/
│   ├── images/                     # App images and illustrations
│   ├── icons/                      # Custom icons
│   └── fonts/                      # Custom fonts (Poppins)
└── test/
    └── widget_test.dart            # Widget tests
```

### Key Technologies

- **Framework**: Flutter 3.1.0+
- **State Management**: Provider pattern
- **Local Storage**: SharedPreferences + SQLite
- **HTTP Client**: Dio
- **Image Handling**: image_picker
- **In-App Purchases**: in_app_purchase
- **JSON Serialization**: json_annotation + build_runner
- **UI**: Material Design 3 with custom theming

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.1.0 or higher
- Dart SDK 3.1.0 or higher
- Android Studio / VS Code with Flutter extensions
- iOS development setup (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd tea_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **AI Service Configuration**
   - Update `lib/constants/app_constants.dart` with your AI service endpoints
   - Configure API keys in your environment

2. **In-App Purchase Setup**
   - Configure product IDs in App Store Connect / Google Play Console
   - Update product IDs in `app_constants.dart`

3. **Assets Setup**
   - Add custom fonts to `assets/fonts/`
   - Add app icons and images to respective asset folders

## 💡 Usage

### First Launch
1. Users see an onboarding flow explaining app features
2. App initializes with free tier access
3. Users can immediately start using limited features

### Main Workflow
1. **Feature Selection**: Choose from available AI features
2. **Input Provision**: Provide text, images, or context
3. **AI Processing**: App processes input and generates responses
4. **Result Display**: View AI-generated advice, suggestions, or analysis
5. **Action Taking**: Copy responses, save profiles, or get more suggestions

### Premium Upgrade
1. Users hit daily limits on free features
2. Subscription screen shows premium benefits
3. In-app purchase flow for subscription activation
4. Unlimited access to all features

## 🎨 Design System

### Color Palette
- **Primary**: Purple gradient (#6C63FF to #8B85FF)
- **Secondary**: Pink gradient (#FF6B9D to #FF8FB0)
- **Accent**: Teal gradient (#00D4AA to #33DDBD)
- **Background**: Light gray (#F8F9FA)
- **Surface**: White (#FFFFFF)

### Typography
- **Font Family**: Poppins
- **Hierarchy**: Display, Headline, Title, Body, Label styles
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Components
- **Chat Bubbles**: Rounded corners with user/assistant styling
- **Feature Cards**: Gradient backgrounds with usage indicators
- **Buttons**: Rounded with gradient backgrounds
- **Input Fields**: Rounded borders with focus states

## 🔧 Development

### Code Generation
```bash
# Generate JSON serialization
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Analysis
```bash
# Analyze code quality
flutter analyze

# Format code
flutter format .
```

### Building
```bash
# Build APK
flutter build apk

# Build iOS
flutter build ios

# Build for release
flutter build apk --release
```

## 📱 Platform Support

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Web**: Limited support (mobile-first design)

## 🔒 Privacy & Security

- **Local Storage**: User data stored locally with encryption
- **API Communication**: HTTPS only with proper authentication
- **Image Handling**: Secure upload with size/type validation
- **Subscription Data**: Handled through platform stores

## 🚦 Limitations & Future Enhancements

### Current Limitations
- Mock AI responses (requires real AI service integration)
- Basic image upload (no cloud storage)
- Limited offline functionality
- Single language support (English)

### Planned Enhancements
- Real AI service integration (OpenAI, Claude, etc.)
- Cloud storage for images and profiles
- Multi-language support
- Advanced analytics and insights
- Social features and community
- Dating platform integrations

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support, email support@tea-app.com or create an issue in the repository.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- AI service providers for conversation intelligence
- Beta testers and early users for feedback

---

**Tea** - Making dating conversations smoother, one message at a time! ☕💕
