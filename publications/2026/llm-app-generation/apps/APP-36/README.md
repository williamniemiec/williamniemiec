# Betano - Sports Betting & Casino App

A comprehensive Flutter mobile application for the Brazilian online gambling market, featuring sports betting, live casino games, and responsible gaming tools.

## 🎯 App Overview

Betano is a real-money online gambling platform designed specifically for the Brazilian market. The app provides users with a secure, intuitive, and feature-rich mobile environment for sports betting and online casino gaming.

### Key Features

- **Sports Betting**: Extensive sportsbook with pre-match and live betting
- **Live Casino**: Real dealers hosting games via video stream
- **Account Management**: Secure user authentication and KYC verification
- **Responsible Gaming**: Built-in tools for deposit limits and self-exclusion
- **Brazilian Market Focus**: Pix payments, CPF verification, Portuguese language

## 🏗️ Architecture

The app follows a clean architecture pattern with the following structure:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   ├── providers/         # State management providers
│   └── utils/             # Utility functions
├── features/              # Feature modules
│   ├── auth/             # Authentication (login, register, KYC)
│   ├── home/             # Home screen and dashboard
│   ├── sports/           # Sports betting functionality
│   ├── casino/           # Casino games and live tables
│   ├── account/          # User account management
│   ├── bet_slip/         # Betting slip functionality
│   └── live_betting/     # Live betting features
└── shared/               # Shared components
    ├── models/           # Data models
    ├── services/         # API services
    └── widgets/          # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.1.0)
- Dart SDK
- Chrome (for web development)
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd betano_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run -d chrome --web-port=8085
```

## 📱 Features Implementation

### Authentication System
- **Login Screen**: Email/password authentication with biometric support
- **Registration**: Multi-step form with CPF and age verification
- **KYC Verification**: Document upload for identity verification
- **Social Login**: Google and Facebook integration (coming soon)

### Sports Betting
- **Popular Sports**: Football, Basketball, Tennis, Volleyball, MMA
- **Live Events**: Real-time odds updates and live scores
- **Bet Types**: Single, Multiple (Accumulator), and System bets
- **Cash Out**: Full and partial cash-out options
- **SuperOdds**: Daily zero-margin odds offerings

### Casino Games
- **Slots**: Popular games from Pragmatic Play, NetEnt, and others
- **Live Casino**: Real dealers for Blackjack, Roulette, Baccarat
- **Crash Games**: Aviator and other instant-win games
- **Tournaments**: Regular competitions with prize pools

### Account Management
- **Balance Display**: Real-time balance updates
- **Transaction History**: Detailed records of all transactions
- **Deposit/Withdrawal**: Pix, bank transfer, and card payments
- **Profile Settings**: Personal information and preferences

### Responsible Gaming
- **Deposit Limits**: Daily, weekly, and monthly limits
- **Loss Limits**: Configurable loss protection
- **Session Time Limits**: Automatic logout after set time
- **Self-Exclusion**: Temporary or permanent account suspension

## 🎨 Design System

### Color Palette
- **Primary**: Betano Blue (#1E3A8A)
- **Secondary**: Gold (#FFD700)
- **Success**: Green (#10B981)
- **Error**: Red (#EF4444)
- **Warning**: Orange (#F59E0B)

### Typography
- System default fonts for optimal performance
- Font weights: Regular (400), Medium (500), Semi-bold (600), Bold (700)

### Components
- Custom button styles for different actions
- Consistent card layouts
- Responsive design for various screen sizes

## 🔧 State Management

The app uses Provider for state management with the following providers:

- **AppProvider**: Main application state (user, authentication, balance)
- **BetSlipProvider**: Betting slip management
- **SportsProvider**: Sports data and live updates
- **CasinoProvider**: Casino games and tournaments

## 📊 Data Models

### Core Models
- **User**: User profile and preferences
- **Bet**: Betting information and selections
- **Sport**: Sports, leagues, and events
- **CasinoGame**: Casino game information
- **Tournament**: Casino tournament data

### Key Features of Models
- JSON serialization/deserialization
- Immutable data structures with copyWith methods
- Validation and formatting helpers
- Type-safe enums for status and categories

## 🌐 API Integration

The app is designed to integrate with RESTful APIs for:

- User authentication and management
- Sports data and odds
- Casino game content
- Payment processing
- Live streaming data

## 🔒 Security Features

- **Data Encryption**: Sensitive data encryption
- **Secure Storage**: Local secure storage for tokens
- **API Security**: JWT token authentication
- **Input Validation**: Comprehensive form validation
- **Age Verification**: 18+ age requirement enforcement

## 🇧🇷 Brazilian Market Compliance

- **CPF Validation**: Brazilian tax ID verification
- **Pix Integration**: Instant payment system
- **Portuguese Language**: Full localization
- **Local Regulations**: Compliance with Brazilian gambling laws
- **Responsible Gaming**: Mandatory responsible gaming tools

## 🧪 Testing

Run tests with:
```bash
flutter test
```

The app includes:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows

## 📦 Dependencies

### Core Dependencies
- `provider`: State management
- `go_router`: Navigation
- `http` & `dio`: API communication
- `shared_preferences`: Local storage

### UI Dependencies
- `flutter_svg`: SVG support
- `cached_network_image`: Image caching
- `carousel_slider`: Image carousels
- `shimmer`: Loading animations

### Utility Dependencies
- `intl`: Internationalization
- `url_launcher`: External links
- `local_auth`: Biometric authentication
- `permission_handler`: Device permissions

## 🚀 Deployment

### Web Deployment
```bash
flutter build web
```

### Mobile Deployment
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📈 Performance Optimization

- **Lazy Loading**: On-demand content loading
- **Image Caching**: Efficient image management
- **State Optimization**: Minimal rebuilds with Provider
- **Bundle Splitting**: Code splitting for web deployment

## 🔮 Future Enhancements

- **Push Notifications**: Real-time betting updates
- **Offline Support**: Basic functionality without internet
- **Advanced Analytics**: User behavior tracking
- **Machine Learning**: Personalized recommendations
- **Multi-language Support**: Additional language options

## 📄 License

This project is proprietary software developed for Betano. All rights reserved.

## 🤝 Contributing

This is a proprietary project. For internal development guidelines, please refer to the internal documentation.

## 📞 Support

For technical support or questions about the app:
- Internal development team
- Technical documentation
- Code review process

---

**Note**: This is a demonstration app created for educational purposes. It includes all the core features and architecture of a real betting application but uses mock data and simulated API responses.
