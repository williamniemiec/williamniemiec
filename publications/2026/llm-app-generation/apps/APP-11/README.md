# PayPal Mobile App

A comprehensive digital wallet and financial hub built with Flutter, replicating the core functionality of the PayPal mobile application.

## 📱 App Overview

The PayPal mobile app serves as a comprehensive digital wallet and all-in-one financial hub, providing users with a single, secure platform to manage their day-to-day financial activities including sending and receiving money, shopping online and in-store, saving, and managing various payment methods.

## ✨ Features

### Core Payments & Money Movement
- **Peer-to-Peer (P2P) Payments**: Send money to and request money from friends and family
- **Global Payments**: Send money to users in over 120 countries with currency conversion
- **QR Code Payments**: Generate and scan QR codes for touch-free payments
- **Bill Pay**: Centralized feature to find, pay, and manage recurring bills

### Shopping & Financial Services
- **Online Checkout**: Use as primary payment method for online shopping
- **Pay in 4**: Buy Now, Pay Later feature splitting purchases into four interest-free payments
- **Deals and Cash Back**: Discover, save, and automatically apply cash back offers
- **Package Tracking**: Track shipments and view delivery status
- **PayPal Debit Card**: Physical debit card with customizable cash back rewards
- **High-Yield Savings**: Integrated savings account with competitive APY

### Wallet & Account Management
- **Digital Wallet**: Securely link and manage various payment methods
- **PayPal Balance**: Hold and use balance directly within the account
- **Activity Tracking**: Detailed and searchable transaction history
- **Security & Fraud Protection**: 24/7 transaction monitoring and fraud protection

## 🏗️ Architecture

The app follows a feature-based architecture with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   ├── utils/             # Utility functions
│   └── services/          # Core services
├── features/              # Feature modules
│   ├── home/             # Dashboard and main screen
│   ├── payments/         # Payment functionality
│   ├── wallet/           # Wallet management
│   └── deals/            # Deals and offers
├── shared/               # Shared components
│   ├── models/          # Data models
│   ├── widgets/         # Reusable widgets
│   └── services/        # Shared services
└── main.dart            # App entry point
```

## 🎨 Design System

### Colors
- **Primary Blue**: `#0070BA` - PayPal's signature blue
- **Dark Blue**: `#003087` - Darker variant for contrast
- **Light Blue**: `#009CDE` - Lighter accent color
- **Yellow**: `#FFC439` - PayPal's secondary brand color
- **Success**: `#28A745` - For positive actions
- **Warning**: `#FFC107` - For cautions
- **Error**: `#DC3545` - For errors

### Typography
- **Font Family**: System default (PayPalSans when available)
- **Weights**: Regular (400), Medium (500), Bold (700)
- **Scales**: Display, Headline, Title, Body, Label variants

### Components
- **Cards**: Rounded corners (12px), subtle shadows
- **Buttons**: Primary (filled), Secondary (outlined), Text buttons
- **Navigation**: Bottom tab bar with 4 main sections

## 📱 Screens

### 1. Home Screen
- **Balance Card**: Prominent display of PayPal balance with quick actions
- **Quick Actions**: Send, Request, Scan QR, Show QR code
- **Recent Activity**: List of recent transactions
- **Feature Cards**: Access to savings, debit card, bill pay, Pay in 4

### 2. Payments Screen
- **Quick Actions**: Send Money and Request Money buttons
- **Activity Tab**: Recent transactions and frequent contacts
- **Bills Tab**: Bill management and payment functionality
- **Send Again**: Quick access to frequent contacts

### 3. Wallet Screen
- **Balance Cards**: PayPal Balance and High-Yield Savings
- **Payment Methods**: List of linked cards and bank accounts
- **Additional Features**: Debit card, Pay in 4, transaction history

### 4. Deals Screen
- **Available Deals**: Browse active offers and promotions
- **Saved Deals**: View and manage saved offers
- **Category Filter**: Filter deals by category
- **Deal Details**: Detailed view with terms and conditions

## 🔧 Technical Implementation

### State Management
- Currently using basic StatefulWidget approach
- Ready for integration with Provider, Riverpod, or Bloc

### Navigation
- Bottom tab navigation with IndexedStack for performance
- Modal bottom sheets for forms and detailed views

### Data Models
- **User**: User profile and preferences
- **Transaction**: Payment and transaction data
- **PaymentMethod**: Cards and bank accounts
- **Deal**: Offers and promotions
- **Contact**: P2P payment contacts

### Services
- HTTP client setup with Dio
- Local storage with SharedPreferences
- Biometric authentication support
- QR code scanning and generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Chrome (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd paypal_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For mobile (with device connected)
   flutter run
   
   # For specific device
   flutter run -d <device-id>
   ```

### Development Setup

1. **Enable web support** (if not already enabled)
   ```bash
   flutter config --enable-web
   ```

2. **Check available devices**
   ```bash
   flutter devices
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Analyze code**
   ```bash
   flutter analyze
   ```

## 🧪 Testing

The app includes comprehensive testing:

- **Unit Tests**: Model and service testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end user flows

Run tests with:
```bash
flutter test
```

## 📦 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `go_router`: Navigation
- `http` & `dio`: HTTP requests
- `shared_preferences`: Local storage

### UI & UX
- `font_awesome_flutter`: Icons
- `cached_network_image`: Image caching
- `lottie`: Animations

### Functionality
- `qr_code_scanner`: QR code scanning
- `qr_flutter`: QR code generation
- `permission_handler`: Device permissions
- `local_auth`: Biometric authentication
- `intl`: Internationalization

## 🔐 Security Features

- **Biometric Authentication**: Fingerprint and face recognition
- **Secure Storage**: Encrypted local data storage
- **Network Security**: HTTPS and certificate pinning
- **Fraud Protection**: Transaction monitoring and alerts

## 🌍 Internationalization

The app supports multiple languages and currencies:
- **Languages**: English, Spanish, French, German, Italian, Portuguese, Chinese, Japanese, Korean, Arabic
- **Currencies**: USD, EUR, GBP, CAD, AUD, JPY, and 17 others

## 📱 Platform Support

- **iOS**: iOS 12.0+
- **Android**: Android 5.0+ (API level 21)
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Desktop**: Windows, macOS, Linux (experimental)

## 🔧 Configuration

### Environment Variables
Create a `.env` file for environment-specific configuration:
```
API_BASE_URL=https://api.paypal.com/v1
SANDBOX_URL=https://api.sandbox.paypal.com/v1
ENABLE_BIOMETRIC_AUTH=true
ENABLE_QR_PAYMENTS=true
```

### Feature Flags
Configure features in `lib/core/constants/app_constants.dart`:
```dart
static const bool enableBiometricAuth = true;
static const bool enableQRCodePayments = true;
static const bool enableDeals = true;
static const bool enableBillPay = true;
static const bool enablePayIn4 = true;
static const bool enableSavingsAccount = true;
static const bool enableDebitCard = true;
```

## 🚀 Deployment

### Web Deployment
```bash
flutter build web
# Deploy the build/web directory to your web server
```

### Mobile Deployment
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- PayPal for design inspiration
- Flutter team for the amazing framework
- Open source community for the packages used

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the [Flutter documentation](https://docs.flutter.dev/)
- Visit [PayPal Developer](https://developer.paypal.com/) for API documentation

---

**Note**: This is a demonstration app created for educational purposes. It is not affiliated with or endorsed by PayPal Holdings, Inc.
