# Nubank App - Project Structure

This document outlines the complete project structure and organization of the Nubank Flutter application.

## 📁 Directory Structure

```
nubank_app/
├── android/                    # Android-specific configuration
├── ios/                       # iOS-specific configuration
├── web/                       # Web-specific configuration
├── lib/                       # Main application code
│   ├── core/                  # Core application components
│   │   ├── constants/         # App constants and configuration
│   │   │   └── app_constants.dart
│   │   ├── theme/            # App theme and styling
│   │   │   └── app_theme.dart
│   │   ├── utils/            # Utility functions
│   │   └── services/         # Core services
│   ├── features/             # Feature-based modules
│   │   ├── home/             # Main dashboard
│   │   │   ├── screens/      # Home screens
│   │   │   │   └── home_screen.dart
│   │   │   ├── widgets/      # Home-specific widgets
│   │   │   │   ├── account_card.dart
│   │   │   │   ├── credit_card_card.dart
│   │   │   │   ├── action_shortcuts.dart
│   │   │   │   └── recent_transactions.dart
│   │   │   └── providers/    # Home state management
│   │   │       └── home_provider.dart
│   │   ├── account/          # Digital account features
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │       └── account_provider.dart
│   │   ├── credit_card/      # Credit card management
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │       └── credit_card_provider.dart
│   │   ├── pix/              # Pix transfer functionality
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │       └── pix_provider.dart
│   │   ├── shopping/         # Shopping marketplace
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │       └── shopping_provider.dart
│   │   ├── auth/             # Authentication
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   └── security/         # Security features
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── providers/
│   ├── shared/               # Shared components
│   │   ├── models/           # Data models
│   │   │   ├── user.dart
│   │   │   ├── account.dart
│   │   │   ├── credit_card.dart
│   │   │   ├── transaction.dart
│   │   │   ├── caixinha.dart
│   │   │   └── shopping_offer.dart
│   │   ├── widgets/          # Reusable UI components
│   │   └── services/         # Shared services
│   └── main.dart             # App entry point
├── test/                     # Test files
│   └── widget_test.dart
├── assets/                   # Static assets (created when needed)
│   ├── images/
│   ├── icons/
│   └── fonts/
├── pubspec.yaml              # Project dependencies
├── README.md                 # Project documentation
└── PROJECT_STRUCTURE.md     # This file
```

## 🏗️ Architecture Overview

### Core Layer (`lib/core/`)
Contains fundamental app components that are used throughout the application:

- **Constants**: App-wide constants, configuration values, and static data
- **Theme**: Material Design theme configuration with Nubank's branding
- **Utils**: Helper functions and utilities
- **Services**: Core services like API clients, storage, etc.

### Features Layer (`lib/features/`)
Organized by business domains, each feature contains:

- **Screens**: UI screens for the feature
- **Widgets**: Feature-specific reusable components
- **Providers**: State management for the feature

#### Feature Modules:

1. **Home** - Main dashboard and financial overview
2. **Account** - Digital account management and transactions
3. **Credit Card** - Credit card features and bill management
4. **Pix** - Brazilian instant payment system integration
5. **Shopping** - Marketplace and cashback offers
6. **Auth** - User authentication and onboarding
7. **Security** - Biometric auth, PIN, and security settings

### Shared Layer (`lib/shared/`)
Contains components shared across multiple features:

- **Models**: Data transfer objects and business entities
- **Widgets**: Reusable UI components
- **Services**: Shared business logic and API services

## 📱 Screen Flow

```
Main Navigation
├── Financial Life (Home)
│   ├── Account Overview
│   ├── Credit Card Overview
│   ├── Action Shortcuts
│   └── Recent Transactions
├── Planning
│   ├── Caixinhas (Savings Goals)
│   ├── Investments
│   └── Insurance
└── Shopping
    ├── Offers List
    ├── Categories
    └── Partner Stores
```

## 🔄 State Management

The app uses the Provider pattern for state management:

- **HomeProvider**: Manages main dashboard state
- **AccountProvider**: Handles account-related state
- **CreditCardProvider**: Manages credit card state
- **PixProvider**: Handles Pix transfer state
- **ShoppingProvider**: Manages shopping offers state

## 📊 Data Models

### Core Models:
- **User**: User profile and authentication data
- **Account**: Digital account information
- **CreditCard**: Credit card details and limits
- **Transaction**: Financial transaction records
- **Caixinha**: Savings goals and progress
- **ShoppingOffer**: Marketplace deals and offers

## 🎨 UI Components

### Shared Widgets:
- Custom buttons with Nubank styling
- Card components with consistent design
- Form inputs with validation
- Loading states and error handling

### Feature-Specific Widgets:
- Account balance cards
- Credit card visualization
- Transaction list items
- Action shortcut buttons

## 🔧 Configuration Files

### `pubspec.yaml`
- Project metadata
- Dependencies management
- Asset declarations
- Build configuration

### Platform-Specific:
- **Android**: `android/app/build.gradle`, `AndroidManifest.xml`
- **iOS**: `ios/Runner/Info.plist`, Xcode project settings
- **Web**: `web/index.html`, web-specific configurations

## 🧪 Testing Structure

```
test/
├── unit/                     # Unit tests
│   ├── models/              # Model tests
│   ├── providers/           # Provider tests
│   └── services/            # Service tests
├── widget/                  # Widget tests
│   ├── screens/             # Screen tests
│   └── widgets/             # Component tests
└── integration/             # Integration tests
    └── app_test.dart        # End-to-end tests
```

## 📦 Dependencies

### Production Dependencies:
- `flutter`: Flutter framework
- `provider`: State management
- `shared_preferences`: Local storage
- `local_auth`: Biometric authentication
- `intl`: Internationalization
- `flutter_svg`: SVG support
- `image_picker`: Image selection
- `url_launcher`: URL handling
- `flutter_secure_storage`: Secure storage
- `uuid`: Unique identifiers

### Development Dependencies:
- `flutter_test`: Testing framework
- `flutter_lints`: Code analysis
- `mockito`: Mocking for tests
- `integration_test`: Integration testing

## 🚀 Build and Deployment

### Development:
```bash
flutter run -d chrome          # Web development
flutter run -d android         # Android development
flutter run -d ios            # iOS development
```

### Production:
```bash
flutter build web             # Web production build
flutter build apk            # Android APK
flutter build ios            # iOS build
```

## 📝 Code Organization Principles

1. **Feature-First**: Organize by business features, not technical layers
2. **Separation of Concerns**: Clear separation between UI, business logic, and data
3. **Reusability**: Shared components in the shared layer
4. **Testability**: Structure supports easy unit and widget testing
5. **Scalability**: Easy to add new features without affecting existing code

## 🔍 File Naming Conventions

- **Screens**: `*_screen.dart` (e.g., `home_screen.dart`)
- **Widgets**: `*_widget.dart` or descriptive names (e.g., `account_card.dart`)
- **Models**: Singular nouns (e.g., `user.dart`, `transaction.dart`)
- **Providers**: `*_provider.dart` (e.g., `home_provider.dart`)
- **Services**: `*_service.dart` (e.g., `api_service.dart`)
- **Constants**: `*_constants.dart` (e.g., `app_constants.dart`)

## 📚 Documentation

- **README.md**: Project overview and setup instructions
- **PROJECT_STRUCTURE.md**: This file - detailed project organization
- **API_DOCS.md**: API documentation (when backend is implemented)
- **CONTRIBUTING.md**: Contribution guidelines (for team development)

This structure ensures maintainability, scalability, and clear separation of concerns while following Flutter best practices.