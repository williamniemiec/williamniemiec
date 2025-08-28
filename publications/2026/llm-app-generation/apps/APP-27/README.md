# CapCut - Professional Video Editor

A powerful, feature-rich video editing mobile application built with Flutter, inspired by the popular CapCut app. This app provides professional-level video editing capabilities with an intuitive interface designed for both beginners and advanced users.

## 🎥 Features

### Core Editing Suite
- **Multi-Track Timeline**: Intuitive timeline for arranging video clips, audio tracks, text, and effects
- **Basic Editing Tools**:
  - Trim, split, and merge video clips
  - Adjust video speed (0.1x to 100x) with speed curve tool
  - Rotate and crop footage
  - Freeze frame feature
- **Advanced Editing Tools**:
  - Keyframe animation for position, scale, and rotation
  - Chroma key (green screen) functionality
  - Video stabilization
  - Masking and blending effects

### AI-Powered Features
- **Auto Captions**: Automatic speech recognition and subtitle generation
- **Text-to-Speech**: Convert text to natural-sounding voiceovers
- **Background Removal**: AI-powered background removal without green screen
- **Beauty Effects**: AI-enhanced facial retouching
- **Optical Flow**: Ultra-smooth slow-motion effects

### Content Library
- **Template Library**: Trending, ready-to-use video templates
- **Effects & Filters**: Hundreds of video effects and movie-style filters
- **Text & Stickers**: Animated text templates and sticker library
- **Music Library**: Licensed music clips and sound effects
- **Audio Extraction**: Extract audio from existing videos

### Export & Sharing
- **Custom Export**: Support for resolutions up to 4K at 60fps
- **Multiple Formats**: Export in MP4, MOV, AVI, MKV formats
- **Aspect Ratio Adjustment**: Easy format changes for different platforms
- **Direct Sharing**: One-click sharing to social media platforms

## 🏗️ Architecture

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── core/                    # Core application components
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   ├── utils/             # Utility functions
│   ├── services/          # Core services
│   └── providers/         # State management providers
├── features/              # Feature-based modules
│   ├── home/             # Home screen and project management
│   ├── editor/           # Video editor functionality
│   ├── templates/        # Template browsing and selection
│   ├── export/           # Video export functionality
│   └── settings/         # App settings and preferences
└── shared/               # Shared components
    ├── models/           # Data models
    ├── widgets/          # Reusable UI components
    └── services/         # Shared services
```

## 🛠️ Technology Stack

- **Framework**: Flutter 3.8+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Database**: SQLite (sqflite)
- **Video Processing**: FFmpeg Kit
- **UI Components**: Material Design 3
- **Architecture**: Clean Architecture with MVVM pattern

## 📱 Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1      # State management
  go_router: ^14.2.7            # Navigation
  video_player: ^2.8.6          # Video playback
  camera: ^0.10.5+9             # Camera functionality
  image_picker: ^1.0.7          # Media selection
  ffmpeg_kit_flutter: ^6.0.3    # Video processing
  video_thumbnail: ^0.5.3       # Thumbnail generation
  audioplayers: ^6.0.0          # Audio playback
  just_audio: ^0.9.37           # Advanced audio features
  sqflite: ^2.3.2               # Local database
  path_provider: ^2.1.2         # File system access
  permission_handler: ^11.3.0   # Permissions management
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd capcut_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Required permissions: Camera, Microphone, Storage

#### iOS
- Minimum iOS version: 12.0
- Required permissions: Camera, Microphone, Photo Library

## 🎨 UI/UX Design

The app features a dark theme optimized for video editing:

- **Color Scheme**: Dark background with gold accents
- **Typography**: Roboto font family with clear hierarchy
- **Layout**: Responsive design supporting both portrait and landscape
- **Accessibility**: High contrast ratios and proper touch targets

### Key UI Components

- **Timeline**: Multi-track timeline with zoom and scroll capabilities
- **Preview Window**: Real-time video preview with playback controls
- **Tool Panels**: Context-sensitive editing tools and properties
- **Asset Browser**: Media library with thumbnail previews

## 📊 Data Models

### Core Models

- **VideoProject**: Main project container with clips, audio, text, and effects
- **VideoClip**: Individual video segments with transforms and filters
- **AudioTrack**: Audio elements with volume and timing controls
- **TextOverlay**: Text elements with styling and animations
- **Effect**: Visual effects with parameters and timing
- **Template**: Pre-built project templates with structure definitions

## 🔧 Services

### VideoService
Handles all video processing operations:
- Video trimming and merging
- Speed adjustment and filters
- Thumbnail generation
- Format conversion

### ProjectService
Manages project persistence:
- Save/load projects
- Project search and organization
- Import/export functionality
- Database operations

## 🎯 Key Features Implementation

### Timeline Editor
- Drag-and-drop clip arrangement
- Multi-track support (video, audio, text, effects)
- Zoom and scroll functionality
- Precise frame-level editing

### Real-time Preview
- Hardware-accelerated video playback
- Live effect preview
- Scrubbing and seeking
- Playback speed control

### Export System
- Multiple resolution options (480p to 4K)
- Various frame rates (24fps to 60fps)
- Bitrate control for quality/size balance
- Progress tracking and cancellation

## 🧪 Testing

Run the test suite:

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- 🔄 Web (Limited functionality)
- 🔄 Desktop (Windows, macOS, Linux)

## 🔒 Permissions

The app requires the following permissions:

### Android
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to record videos</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record audio</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to import media</string>
```

## 🚧 Development Status

### Completed Features ✅
- Project structure and architecture
- Core data models and services
- Home screen with project management
- Video editor interface
- Timeline implementation
- Export functionality
- Settings and preferences
- Navigation and routing

### In Development 🔄
- Video processing integration
- Advanced editing tools
- AI-powered features
- Template system
- Social sharing

### Planned Features 📋
- Cloud synchronization
- Collaborative editing
- Advanced color grading
- Motion graphics
- Plugin system

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- FFmpeg team for video processing capabilities
- Material Design team for UI guidelines
- Open source community for various packages

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Check the [FAQ](docs/FAQ.md)
- Review the [documentation](docs/)

## 🔄 Version History

### v1.0.0 (Current)
- Initial release
- Core video editing functionality
- Project management system
- Export capabilities
- Settings and preferences

---

**Built with ❤️ using Flutter**
