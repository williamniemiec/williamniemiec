# PayPal App - Project Structure

This document outlines the complete project structure and organization of the PayPal mobile application built with Flutter.

## 📁 Root Directory Structure

```
paypal_app/
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── web/                     # Web-specific files
├── windows/                 # Windows-specific files
├── linux/                  # Linux-specific files
├── macos/                  # macOS-specific files
├── assets/                 # Static assets
│   ├── images/            # Image assets
│   ├── icons/             # Icon assets
│   ├── animations/        # Lottie animations
│   └── fonts/             # Custom fonts
├── lib/                    # Main source code
├── test/                   # Test files
├── pubspec.yaml           # Project dependencies
├── README.md              # Project documentation
└── PROJECT_STRUCTURE.md   # This file
```

## 📱 Lib Directory Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core functionality
│   ├── constants/
│   │   └── app_constants.dart   # App-wide constants
│   ├── theme/
│   │   └── app_theme.dart       # App theming
│   ├── utils/                   # Utility functions
│   └── services/                # Core services
├── features/                    # Feature modules
│   ├── home/                    # Home/Dashboard feature
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   ├── widgets/
│   │   │   ├── balance_card.dart
│   │   │   ├── quick_actions.dart
│   │   │   └── recent_activity.dart
│   │   └── providers/           # State management
│   ├── payments/                # Payments feature
│   │   ├── screens/
│   │   │   └── payments_screen.dart
│   │   ├── widgets/
│   │   └── providers/
│   ├── wallet/                  # Wallet management
│   │   ├── screens/
│   │   │   └── wallet_screen.dart
│   │   ├── widgets/
│   │   └── providers/
│   └── deals/                   # Deals and offers
│       ├── screens/
│       │   └── deals_screen.dart
│       ├── widgets/
│       └── providers/
└── shared/                      # Shared components
    ├── models/                  # Data models
    │   ├── user.dart
    │   ├── transaction.dart
    │   ├── payment_method.dart
    │   ├── deal.dart
    │   └── contact.dart
    ├── widgets/                 # Reusable widgets
    └── services/                # Shared services
```

## 🏗️ Architecture Overview

### Feature-Based Architecture
The app follows a feature-based architecture where each major functionality is organized into its own module:

- **Home**: Dashboard, balance display, quick actions
- **Payments**: P2P payments, bill pay, transaction history
- **Wallet**: Payment methods, balance management
- **Deals**: Offers, cash back, promotions

### Layer Separation
Each feature follows a consistent structure:
- **Screens**: UI screens and pages
- **Widgets**: Reusable UI components
- **Providers**: State management (ready for Provider/Riverpod)

## 📄 Core Files

### main.dart
- App entry point
- Material App configuration
- Main navigation setup with bottom tabs

### Core Constants (app_constants.dart)
- App configuration values
- API endpoints
- UI constants (padding, colors, etc.)
- Feature flags
- Supported currencies and languages

### App Theme (app_theme.dart)
- Light and dark theme definitions
- PayPal brand colors
- Typography scales
- Component themes (buttons, cards, etc.)

## 🎯 Feature Modules

### Home Feature
**Purpose**: Main dashboard and app entry point

**Components**:
- `HomeScreen`: Main dashboard with balance and quick actions
- `BalanceCard`: PayPal balance display with action buttons
- `QuickActions`: Send, Request, Scan, My Code buttons
- `RecentActivity`: Transaction history list

### Payments Feature
**Purpose**: Money movement and payment functionality

**Components**:
- `PaymentsScreen`: Payment hub with tabs for activity and bills
- Send/Request money functionality
- Frequent contacts display
- Transaction history
- Bill payment management

### Wallet Feature
**Purpose**: Payment method and balance management

**Components**:
- `WalletScreen`: Payment methods and balance overview
- Balance cards for PayPal and Savings accounts
- Payment method list (cards, bank accounts)
- Add payment method functionality

### Deals Feature
**Purpose**: Offers, promotions, and cash back

**Components**:
- `DealsScreen`: Available and saved deals with filtering
- Deal cards with merchant information
- Category filtering
- Deal details modal

## 📊 Data Models

### User Model
- User profile information
- Account preferences
- Balance information
- Verification status

### Transaction Model
- Transaction details and metadata
- Type classification (send, receive, purchase, etc.)
- Status tracking
- Amount and currency information

### Payment Method Model
- Card and bank account information
- Verification and default status
- Masked display information
- Expiry and security details

### Deal Model
- Merchant and offer information
- Deal types (cash back, discount, etc.)
- Usage tracking and limits
- Expiry and terms

### Contact Model
- P2P payment contacts
- Frequent contact tracking
- Contact methods (email, phone)

## 🎨 UI Components

### Shared Widgets
- Custom buttons following PayPal design
- Card components with consistent styling
- Loading and error states
- Modal bottom sheets

### Theme System
- Consistent color palette
- Typography scales
- Component theming
- Dark mode support

## 🔧 Services Architecture

### HTTP Services
- API client configuration
- Request/response handling
- Error management
- Authentication headers

### Local Storage
- User preferences
- Cached data
- Secure token storage

### Authentication
- Biometric authentication
- Session management
- Security validation

## 📱 Navigation Structure

### Bottom Tab Navigation
- Home (Dashboard)
- Payments (Money movement)
- Wallet (Payment methods)
- Deals (Offers)

### Modal Navigation
- Bottom sheets for forms
- Full-screen modals for detailed views
- Overlay dialogs for confirmations

## 🧪 Testing Structure

### Test Organization
```
test/
├── unit/                    # Unit tests
│   ├── models/             # Model tests
│   └── services/           # Service tests
├── widget/                 # Widget tests
│   ├── screens/           # Screen tests
│   └── widgets/           # Component tests
└── integration/           # Integration tests
    └── flows/             # User flow tests
```

### Test Categories
- **Unit Tests**: Model validation, service logic
- **Widget Tests**: UI component behavior
- **Integration Tests**: End-to-end user flows

## 🚀 Build Configuration

### Environment Configuration
- Development, staging, production environments
- Feature flags for different builds
- API endpoint configuration

### Platform-Specific Files
- Android: Gradle configuration, permissions
- iOS: Info.plist, entitlements
- Web: index.html, manifest.json

## 📦 Dependencies Organization

### Core Dependencies
- Flutter framework
- State management (Provider)
- Navigation (Go Router)
- HTTP client (Dio)

### Feature Dependencies
- QR code functionality
- Biometric authentication
- Image handling
- Animations

### Development Dependencies
- Testing frameworks
- Code analysis tools
- Build tools

## 🔐 Security Considerations

### Data Protection
- Sensitive data encryption
- Secure storage implementation
- Network security (HTTPS, certificate pinning)

### Authentication
- Biometric authentication setup
- Session management
- Token security

## 📈 Scalability Considerations

### State Management
- Ready for Provider/Riverpod integration
- Modular state organization
- Performance optimization

### Code Organization
- Feature-based modularity
- Reusable component library
- Service abstraction

### Performance
- Lazy loading implementation
- Image caching
- Memory management

This structure provides a solid foundation for a production-ready PayPal mobile application with clear separation of concerns, maintainable code organization, and scalability for future enhancements.