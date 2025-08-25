# AI Home Design

Transform your space with AI-powered interior and exterior design. Upload a photo of your room or outdoor space, select a design style, and let AI reimagine your space in seconds.

## Features

### Core Features
- **AI-Powered Design Generation**: Upload photos and transform them with AI
- **Photo Upload**: Camera capture or gallery selection
- **Multiple Room Types**: Living room, bedroom, kitchen, bathroom, office, and more
- **Exterior Design**: House exterior, garden, patio, balcony redesign
- **Design Styles**: Modern, minimalist, Scandinavian, bohemian, industrial, farmhouse, coastal, tropical
- **Before/After Comparison**: Interactive slider to compare original vs. AI-generated design
- **Project Gallery**: Save and organize your favorite designs
- **Sharing**: Share your designs on social media

### Premium Features
- **Unlimited Generations**: No daily limits
- **Premium Design Styles**: Access to exclusive styles
- **High Resolution Export**: 4K quality images
- **Priority Processing**: Faster AI generation
- **Ad-Free Experience**: No interruptions
- **Cloud Storage**: Unlimited project saves

## Screenshots

*Screenshots would be added here showing the main screens*

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS development setup (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ai_home_design
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
- Minimum SDK version: 21
- Target SDK version: 34
- Permissions required:
  - Camera access
  - Storage access
  - Internet access

#### iOS
- Minimum iOS version: 12.0
- Permissions required:
  - Camera usage
  - Photo library access
  - Internet access

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and default data
│   ├── theme/             # App theme and styling
│   └── utils/             # Utilities and routing
├── features/
│   ├── home/              # Home screen and widgets
│   ├── editor/            # Photo selection and style editor
│   ├── results/           # Results screen with before/after slider
│   ├── gallery/           # Project gallery and management
│   └── subscription/      # Premium subscription features
└── shared/
    ├── models/            # Data models
    ├── services/          # Business logic and API services
    └── widgets/           # Reusable UI components
```

## Key Components

### Models
- **DesignProject**: Represents a design generation project
- **DesignStyle**: Available design styles (modern, minimalist, etc.)
- **RoomType**: Room categories (interior/exterior)
- **UserSubscription**: Premium subscription management

### Services
- **AIDesignService**: Handles AI design generation (mock implementation)
- **PhotoService**: Camera and gallery photo selection
- **AppProvider**: Main state management provider

### Screens
- **HomeScreen**: Main landing page with CTA and inspiration
- **EditorScreen**: Photo upload and style selection
- **ResultsScreen**: Display results with before/after comparison
- **GalleryScreen**: Browse and manage saved projects
- **SubscriptionScreen**: Premium subscription management

## Configuration

### AI Service Integration
The app currently uses a mock AI service. To integrate with a real AI service:

1. Update `AIDesignService` in `lib/shared/services/ai_design_service.dart`
2. Replace mock generation with actual API calls
3. Update API endpoints in `AppConstants`

### Subscription Integration
To enable real in-app purchases:

1. Configure App Store Connect / Google Play Console
2. Update subscription product IDs in `AppConstants`
3. Implement real purchase flow in `SubscriptionScreen`

## Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `go_router`: Navigation and routing
- `shared_preferences`: Local data persistence

### Image & Camera
- `image_picker`: Photo selection from camera/gallery
- `camera`: Camera functionality
- `photo_view`: Image viewing and zooming
- `cached_network_image`: Network image caching

### UI & Animations
- `shimmer`: Loading animations
- `lottie`: Advanced animations

### Utilities
- `uuid`: Unique ID generation
- `intl`: Internationalization
- `path_provider`: File system access
- `permission_handler`: Runtime permissions
- `share_plus`: Social sharing
- `http` & `dio`: Network requests

## Development

### Adding New Design Styles
1. Add style definition to `AppConstants.defaultDesignStyles`
2. Add thumbnail assets to `assets/sample_designs/`
3. Update AI service to handle new style

### Adding New Room Types
1. Add room type to `AppConstants.defaultRoomTypes`
2. Add icon assets to `assets/icons/`
3. Update suggested styles mapping

### Customizing Theme
- Update colors and styles in `AppTheme`
- Modify component themes as needed
- Add custom decorations in `AppDecorations`

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## Building

### Android
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
flutter build ipa
```

## Deployment

### Android (Google Play)
1. Build release AAB: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Configure store listing and screenshots

### iOS (App Store)
1. Build release IPA: `flutter build ipa`
2. Upload to App Store Connect via Xcode or Transporter
3. Configure App Store listing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue on GitHub
- Email: support@aihomedesign.com

## Roadmap

### Upcoming Features
- [ ] Real AI service integration
- [ ] User accounts and cloud sync
- [ ] Social features and community gallery
- [ ] AR preview functionality
- [ ] Batch processing
- [ ] Custom style training
- [ ] Professional designer collaboration
- [ ] 3D room visualization

### Technical Improvements
- [ ] Offline mode support
- [ ] Performance optimizations
- [ ] Accessibility improvements
- [ ] Internationalization
- [ ] Analytics integration
- [ ] Crash reporting
- [ ] A/B testing framework
