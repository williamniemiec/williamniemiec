# Nubank App - Flutter Implementation

A complete digital banking platform inspired by Nubank, built with Flutter. This app provides a comprehensive mobile banking experience with modern UI/UX design and essential financial features.

## 🏦 App Purpose

The Nubank app functions as a complete digital banking platform that empowers users by simplifying their financial lives. Its primary objective is to offer a transparent, intuitive, and bureaucracy-free mobile experience for managing a full suite of financial products.

## ✨ Features

### Digital Account (NuConta)
- **Free Digital Account**: Completely free checking and savings account with no maintenance fees
- **High-Yield Savings**: Money automatically earns interest at competitive rates
- **Pix Transfers**: Instant, free 24/7 money transfers using Brazil's central bank payment system
- **Bill Payments**: Scan and pay utility bills, taxes, and other payment slips
- **Mobile Top-Up**: Recharge pre-paid mobile phone plans
- **Direct Deposit**: Receive salary and other payments directly

### Credit Card ("Roxinho")
- **No Annual Fee**: International Mastercard credit card with no annual fees
- **Real-Time Management**: Track all purchases in real-time with instant notifications
- **In-App Limit Adjustment**: Request credit limit increases directly through the app
- **Virtual Cards**: Create temporary or recurring virtual credit cards for secure online shopping
- **Bill Payment**: Pay credit card bills directly from account balance
- **Rewards Program**: Optional points program with cashback benefits

### Financial Services
- **Personal Loans**: Simple, transparent loan application and management process
- **Investments**: Integrated platform for stocks, ETFs, and fixed-income assets
- **"Caixinhas" (Money Boxes)**: Goal-based savings feature with customizable objectives
- **Insurance**: Life insurance and cell phone insurance options

### Shopping & Benefits
- **Nubank Shopping**: In-app marketplace with exclusive discounts and cashback from partner retailers

### Security Features
- **Biometric Login**: Secure access using fingerprint or facial recognition
- **In-App Card Lock**: Instantly lock and unlock physical and virtual credit cards
- **Password-Protected Actions**: All sensitive transactions require 4-digit password
- **"Modo Rua" (Street Mode)**: Security feature that limits transaction values on untrusted networks

## 🎨 Design & Layout

The app features a clean, minimalist, and user-centric interface using Nubank's signature purple color scheme (#8A05BE). The layout is organized into three main tabs:

1. **Financial Life (💰)**: Primary tab for day-to-day transactions, account and credit card management
2. **Planning (💵)**: Hub for investments, insurance, and "Caixinhas" savings goals
3. **Shopping (🛍️)**: Dedicated marketplace for partner deals and cashback offers

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theme and styling
│   ├── utils/             # Utility functions
│   └── services/          # Core services
├── features/
│   ├── home/              # Main dashboard and financial overview
│   ├── account/           # Digital account management
│   ├── credit_card/       # Credit card features
│   ├── pix/               # Pix transfer functionality
│   ├── shopping/          # Shopping marketplace
│   ├── auth/              # Authentication
│   └── security/          # Security features
├── shared/
│   ├── models/            # Data models
│   ├── widgets/           # Reusable UI components
│   └── services/          # Shared services
└── main.dart              # App entry point
```

### Key Components

#### Data Models
- **User**: User profile and authentication data
- **Account**: Digital account information and balance
- **CreditCard**: Credit card details and limits
- **Transaction**: Transaction history and details
- **Caixinha**: Savings goals and progress
- **ShoppingOffer**: Marketplace deals and cashback offers

#### State Management
- Uses Provider pattern for state management
- Separate providers for each feature domain
- Reactive UI updates based on state changes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Chrome (for web development)
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nubank_app
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

2. **Check available devices**
   ```bash
   flutter devices
   ```

3. **Run in debug mode**
   ```bash
   flutter run --debug
   ```

## 📱 User Interaction Flows

### Making a Pix Transfer
1. Open app → Financial Life screen
2. Tap "Pix Area" from action shortcuts
3. Select "Transfer" option
4. Enter amount and recipient details
5. Confirm transaction with 4-digit password
6. Instant transfer completion

### Paying Credit Card Bill
1. Financial Life screen → Tap Credit Card section
2. View closed bill amount
3. Tap "Pay Bill" button
4. Choose payment amount (full, minimum, or custom)
5. Select payment method (account balance or boleto)
6. Confirm with password → Instant limit restoration

### Creating Virtual Card
1. Navigate to Credit Card screen
2. Tap "Virtual Card" button
3. View existing cards or create new
4. Name the card (e.g., "Streaming Service")
5. Confirm with password
6. Copy generated card details for online use

## 🛠️ Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `shared_preferences`: Local storage
- `local_auth`: Biometric authentication
- `intl`: Internationalization and date formatting

### UI Dependencies
- `flutter_svg`: SVG image support
- `image_picker`: Image selection
- `url_launcher`: External URL handling

### Security Dependencies
- `flutter_secure_storage`: Secure local storage
- `uuid`: Unique identifier generation

## 🎯 Current Implementation Status

### ✅ Completed Features
- [x] Project structure and configuration
- [x] Data models for all entities
- [x] Core theme with Nubank's purple branding
- [x] Main navigation with bottom tabs
- [x] Financial Life screen with account and credit card overview
- [x] Real-time balance and transaction display
- [x] Action shortcuts for quick access
- [x] Recent transactions list
- [x] Responsive design for web and mobile

### 🚧 In Development
- [ ] Credit Card detailed screen with full transaction history
- [ ] Account screen with complete transaction management
- [ ] Pix transfer functionality with QR code scanning
- [ ] Bill payment system with barcode scanning
- [ ] Virtual card creation and management
- [ ] Shopping marketplace with partner offers
- [ ] Biometric authentication integration
- [ ] "Caixinhas" savings goals feature

### 🔮 Future Enhancements
- [ ] Investment portfolio management
- [ ] Insurance products integration
- [ ] Advanced analytics and spending insights
- [ ] Push notifications
- [ ] Offline mode support
- [ ] Multi-language support
- [ ] Accessibility improvements

## 🔒 Security Features

- **Biometric Authentication**: Fingerprint and face recognition
- **4-Digit PIN**: Required for sensitive operations
- **Street Mode**: Limits transaction amounts on untrusted networks
- **Card Lock/Unlock**: Instant card control
- **Secure Storage**: Encrypted local data storage
- **Session Management**: Automatic logout for security

## 🎨 Design System

### Colors
- **Primary Purple**: #8A05BE (Nubank's signature color)
- **Light Purple**: #BA2EC6
- **Dark Purple**: #6B0F9C
- **Background Gray**: #F5F5F5
- **Card White**: #FFFFFF
- **Success Green**: #00C851
- **Error Red**: #FF4444

### Typography
- Clean, modern font hierarchy
- Consistent spacing and sizing
- High contrast for accessibility

### Components
- Rounded corners (12px for cards, 8px for buttons)
- Consistent padding and margins
- Material Design 3 principles
- Purple accent throughout the interface

## 📊 Mock Data

The app includes comprehensive mock data for demonstration:
- Sample user profile (João Silva)
- Account with realistic balance (R$ 2.547,83)
- Credit card with usage statistics
- Recent transaction history
- Various transaction types (Pix, purchases, deposits)

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Structure
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows
- Mock data for consistent testing

## 📈 Performance Considerations

- **Lazy Loading**: Efficient data loading strategies
- **State Management**: Optimized Provider usage
- **Image Optimization**: Proper asset management
- **Memory Management**: Efficient widget disposal
- **Network Caching**: Reduced API calls

## 🌐 Localization

Currently supports Portuguese (Brazil) with infrastructure for:
- Multiple language support
- Currency formatting (Brazilian Real)
- Date/time formatting
- Cultural adaptations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable names
- Add comments for complex logic
- Maintain consistent formatting

## 📄 License

This project is for educational and demonstration purposes. Nubank is a trademark of Nu Pagamentos S.A.

## 📞 Support

For questions or issues:
- Create an issue in the repository
- Check the Flutter documentation
- Review the implementation guides

---

**Note**: This is a demonstration app inspired by Nubank's design and functionality. It is not affiliated with or endorsed by Nubank or Nu Pagamentos S.A.
