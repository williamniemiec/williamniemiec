# Crumbl Cookies Mobile App

A Flutter mobile application for Crumbl Cookies - the official digital storefront and loyalty platform for ordering fresh, warm cookies.

## Features

### 🍪 Core Functionality
- **Weekly Menu Viewing**: Browse the current rotating lineup of cookie flavors
- **Multi-Channel Ordering**: Support for pickup, curbside, delivery, catering, and shipping
- **Store Locator**: Find and select the nearest Crumbl store
- **Order Tracking**: Real-time status updates on order preparation
- **Scheduled Orders**: Place orders for future pickup or delivery

### 🎁 Loyalty & Rewards
- **Loyalty Crumbs**: Earn points for every dollar spent
- **Crumbl Cash**: Convert 100 points to $10 in rewards
- **Free Birthday Cookie**: Special birthday month rewards
- **Rewards Tracking**: View current points and available rewards

### 👤 Account Management
- **User Profiles**: Manage personal information and preferences
- **Saved Payment Methods**: Securely store payment information
- **Saved Addresses**: Store multiple delivery addresses
- **Order History**: View past orders and reorder favorites
- **Push Notifications**: Stay updated on menu changes and promotions

### 🎁 Gifting Features
- **Cookie Gifting**: Send cookies to friends and family
- **Gift Cards**: Purchase and send digital Crumbl gift cards

## App Architecture

### 📁 Project Structure
```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── theme/             # App theming and styling
│   ├── utils/             # Utility functions
│   └── services/          # Core services
├── features/
│   ├── home/              # Home screen and weekly menu
│   ├── order/             # Order placement flow
│   ├── checkout/          # Checkout and payment
│   ├── locations/         # Store locator
│   └── more/              # Account and loyalty features
├── shared/
│   ├── models/            # Data models
│   ├── widgets/           # Reusable UI components
│   └── services/          # Shared services
└── main.dart              # App entry point
```

### 🎨 Design System
- **Primary Color**: Crumbl Pink (#FF69B4)
- **Typography**: Google Fonts (Poppins)
- **Components**: Material Design 3 with custom Crumbl styling
- **Navigation**: Bottom tab navigation with 4 main sections

### 🏗️ State Management
- **Provider Pattern**: Used for state management across the app
- **Services**: Separate service classes for cart, user, and loyalty management
- **Models**: Immutable data classes with copyWith methods

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Chrome browser (for web development)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd crumbl_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web (Chrome)
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

### Development Setup

1. **Enable web support** (if not already enabled)
   ```bash
   flutter config --enable-web
   ```

2. **Check Flutter doctor**
   ```bash
   flutter doctor
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

## Features Implementation Status

### ✅ Completed
- [x] Project structure and configuration
- [x] Data models (Cookie, Order, User, Loyalty, Cart, Store)
- [x] App theme with Crumbl branding
- [x] Main navigation with bottom tabs
- [x] Home screen with weekly menu carousel
- [x] Cookie detail modal
- [x] Basic service architecture
- [x] Provider-based state management

### 🚧 In Progress
- [ ] Order screen with cookie selection
- [ ] Checkout flow with payment integration
- [ ] Store locator with maps
- [ ] Loyalty account management
- [ ] User profile and settings

### 📋 Planned Features
- [ ] Push notifications
- [ ] Order tracking
- [ ] Gift card functionality
- [ ] Social sharing
- [ ] Offline support
- [ ] Analytics integration

## API Integration

The app is designed to integrate with the Crumbl API for:
- Cookie menu data
- Store locations
- Order management
- User authentication
- Loyalty program data

### Mock Data
Currently using mock data for development. Replace with actual API calls in:
- `lib/features/home/providers/cookie_provider.dart`
- `lib/features/locations/providers/location_provider.dart`
- `lib/shared/services/`

## Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `google_fonts`: Typography
- `http`: API communication
- `shared_preferences`: Local storage

### UI Dependencies
- `cached_network_image`: Image caching
- `flutter_svg`: SVG support
- `lottie`: Animations

### Location Dependencies
- `google_maps_flutter`: Maps integration
- `geolocator`: Location services
- `geocoding`: Address conversion

### Utility Dependencies
- `intl`: Internationalization
- `provider`: State management

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting with `dart format`

### Commit Messages
- Use conventional commit format
- Examples:
  - `feat: add cookie detail modal`
  - `fix: resolve navigation issue`
  - `docs: update README`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Email: support@crumbl.com
- Phone: 1-800-CRUMBL
- Website: https://crumbl.com

## Acknowledgments

- Crumbl Cookies for the amazing brand and concept
- Flutter team for the excellent framework
- Google Fonts for typography
- Material Design for UI components

---

**Made with ❤️ and 🍪 by the Crumbl development team**
