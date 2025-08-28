# ChatGPT Mobile App

A comprehensive Flutter mobile application that replicates the ChatGPT experience with advanced AI conversation capabilities, voice mode, image analysis, and image generation features.

## Features

### 🤖 Core AI Capabilities
- **Instant Conversations**: Chat with advanced AI models (GPT-3.5, GPT-4, GPT-4 Turbo, GPT-4o)
- **Multi-Modal Support**: Text, voice, and image interactions
- **Conversation Management**: Create, save, and organize multiple chat sessions
- **Cross-Device Sync**: Seamlessly sync conversations across devices

### 🎙️ Voice Mode
- **Real-time Voice Conversations**: Natural speech-to-text and text-to-speech
- **Interactive Audio**: Hands-free communication with visual feedback
- **Multiple Languages**: Support for various languages and accents
- **Voice Controls**: Start, stop, and manage voice interactions

### 📸 Image Capabilities
- **Image Analysis**: Upload photos for AI analysis and transcription
- **Image Generation**: Create original images using DALL-E integration
- **Camera Integration**: Take photos directly within the app
- **Gallery Access**: Choose images from device gallery

### 💎 ChatGPT Plus Features
- **Advanced Models**: Access to GPT-4 and latest AI models
- **Unlimited Usage**: No daily limits on messages or image generations
- **Priority Access**: Faster response times during peak usage
- **Early Features**: First access to new capabilities

### ⚙️ Customization & Settings
- **Theme Options**: Light, dark, and system themes
- **Model Selection**: Choose between different AI models (Plus subscribers)
- **Data Management**: Export conversations and manage privacy settings
- **Account Management**: Sign in/out and subscription management

## Screenshots

*Note: Add screenshots of the app in action*

## Installation

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for mobile development
- OpenAI API key (optional, app works in demo mode without it)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd chatgpt_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key (Optional)**
   - Open `lib/core/services/openai_service.dart`
   - Replace `'your-openai-api-key-here'` with your actual OpenAI API key
   - Without an API key, the app runs in demo mode with simulated responses

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Permissions: Camera, Microphone, Storage

#### iOS
- Minimum iOS: 12.0
- Permissions: Camera, Microphone, Photo Library

## Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── constants/                 # App constants
│   ├── models/                    # Data models
│   ├── providers/                 # State management
│   ├── services/                  # API and business logic
│   └── theme/                     # App theming
├── features/                      # Feature modules
│   ├── chat/                      # Chat functionality
│   │   ├── screens/               # Chat screens
│   │   └── widgets/               # Chat widgets
│   ├── onboarding/                # App onboarding
│   └── settings/                  # Settings and preferences
└── main.dart                      # App entry point
```

## Key Components

### State Management
- **Provider Pattern**: Used for state management across the app
- **ChatProvider**: Manages conversations and AI interactions
- **AuthProvider**: Handles user authentication
- **SubscriptionProvider**: Manages subscription status and limits
- **AppProvider**: Global app settings and theme

### Services
- **OpenAIService**: Handles API communication with OpenAI
- **SyncService**: Manages cross-device synchronization
- **Voice Services**: Speech-to-text and text-to-speech functionality

### Models
- **Message**: Individual chat messages with metadata
- **Conversation**: Chat sessions with multiple messages
- **User**: User account information

## Configuration

### API Configuration
The app can work in two modes:

1. **Demo Mode** (Default)
   - No API key required
   - Simulated AI responses
   - All features available for testing

2. **Production Mode**
   - Requires OpenAI API key
   - Real AI responses
   - Actual image generation and analysis

### Subscription Features
The app simulates ChatGPT Plus subscription with:
- Free tier: 50 messages/day, 3 image generations/day
- Plus tier: Unlimited usage, advanced models

## Dependencies

### Core Dependencies
- `flutter`: Flutter framework
- `provider`: State management
- `http` & `dio`: HTTP client for API calls
- `shared_preferences`: Local storage
- `sqflite`: Local database

### UI Dependencies
- `flutter_animate`: Animations
- `lottie`: Lottie animations
- `shimmer`: Loading effects
- `cached_network_image`: Image caching

### Feature Dependencies
- `speech_to_text`: Voice recognition
- `flutter_tts`: Text-to-speech
- `image_picker`: Camera and gallery access
- `permission_handler`: Device permissions

## Development

### Adding New Features
1. Create feature directory in `lib/features/`
2. Add screens, widgets, and providers as needed
3. Update routing and navigation
4. Add tests for new functionality

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent file structure

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

### Common Issues

1. **Voice not working**
   - Check microphone permissions
   - Ensure device has speech recognition support
   - Verify internet connection for speech processing

2. **Images not loading**
   - Check internet connection
   - Verify API key configuration
   - Check device storage permissions

3. **Sync not working**
   - Ensure user is signed in
   - Check internet connection
   - Verify local storage permissions

### Debug Mode
Run the app in debug mode for detailed logging:
```bash
flutter run --debug
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- OpenAI for the ChatGPT API and inspiration
- Flutter team for the excellent framework
- Contributors and testers

## Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review the Flutter documentation

---

**Note**: This is a demonstration app showcasing ChatGPT-like functionality. For production use, ensure proper API key management, security measures, and compliance with OpenAI's usage policies.