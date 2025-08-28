# Sleeper - Modern Fantasy Sports Platform

A complete Flutter mobile application implementation of Sleeper, the modern fantasy sports platform focused on social interaction and user experience.

## 🏈 App Overview

Sleeper is a fantasy sports platform that connects friends and communities through sports by integrating seamless communication directly into the fantasy league experience. The app moves beyond traditional, stats-heavy interfaces to provide a fun, engaging, and intuitive platform for fantasy football, basketball, and other sports, as well as offering real-money skill-based games.

## ✨ Features Implemented

### Core Features
- **Multi-Sport Fantasy Leagues**: Support for NFL Football, NBA Basketball, and Soccer
- **Modern Drafting Experience**: Intuitive draft room interface with commissioner controls
- **Advanced League Management**: Full customization options for scoring, rosters, and playoffs
- **Integrated Social Features**: League chat, direct messages, and communication tools
- **Real Money Gaming (Sleeper Picks)**: Skill-based contests with player stat predictions
- **SleeperZone Feed**: Real-time news feed for breaking news and updates

### User Interface
- **Bottom Tab Navigation**: Easy access to Leagues, Picks, Feed, and Messages
- **Dark Theme**: Modern dark UI matching Sleeper's brand identity
- **Responsive Design**: Optimized for mobile devices
- **Interactive Elements**: Cards, buttons, and navigation components

### Technical Features
- **State Management**: Provider pattern for app-wide state
- **Navigation**: Go Router for declarative routing
- **Theming**: Comprehensive theme system with brand colors
- **Models**: Complete data models for leagues, players, messages, and picks
- **Architecture**: Clean, modular architecture with feature-based organization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Chrome (for web testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sleeper_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web (Chrome)
   flutter run -d chrome --web-port=8084
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

## 📱 App Structure

### Main Navigation
The app uses a bottom tab bar with four main sections:

1. **Leagues** (`/leagues`)
   - View all user leagues
   - Create new leagues
   - Join existing leagues
   - League management

2. **Picks** (`/picks`)
   - Sleeper Picks real money gaming
   - Available player picks
   - User entries and history
   - Balance management

3. **Feed** (`/feed`)
   - SleeperZone news feed
   - Breaking news and updates
   - Player injury reports
   - Fantasy insights

4. **Messages** (`/messages`)
   - League chat channels
   - Direct messages
   - Group conversations
   - Notifications

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── providers/          # State management providers
│   ├── router/            # Navigation and routing
│   ├── theme/             # App theming and styling
│   └── widgets/           # Shared UI components
├── features/
│   ├── auth/              # Authentication screens
│   ├── draft/             # Draft room functionality
│   ├── feed/              # News feed features
│   ├── leagues/           # League management
│   ├── messages/          # Chat and messaging
│   ├── onboarding/        # User onboarding
│   └── picks/             # Sleeper Picks gaming
├── shared/
│   ├── models/            # Data models
│   ├── services/          # API and business logic
│   └── widgets/           # Reusable UI components
└── main.dart              # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: `#00D4AA` (Sleeper Teal)
- **Primary Dark**: `#00B894`
- **Secondary**: `#6C5CE7` (Purple)
- **Accent**: `#FF6B6B` (Red)
- **Background**: `#0D1421` (Dark Blue)
- **Surface**: `#1A2332`
- **Card**: `#243447`

### Typography
- **Font Family**: Inter (system fallback)
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Components
- **Cards**: Rounded corners (12px), subtle shadows
- **Buttons**: Primary, outlined, and text variants
- **Navigation**: Bottom tab bar with icons and labels
- **Forms**: Rounded input fields with focus states

## 🔧 Key Components

### Models
- **[`User`](lib/shared/models/user.dart)**: User profiles and statistics
- **[`League`](lib/shared/models/league.dart)**: League data, settings, and rosters
- **[`Player`](lib/shared/models/player.dart)**: Player information and statistics
- **[`Message`](lib/shared/models/message.dart)**: Chat messages and channels
- **[`SleeperPick`](lib/shared/models/sleeper_pick.dart)**: Real money gaming picks

### Screens
- **[`LeaguesScreen`](lib/features/leagues/screens/leagues_screen.dart)**: Main leagues interface
- **[`PicksScreen`](lib/features/picks/screens/picks_screen.dart)**: Sleeper Picks gaming
- **[`FeedScreen`](lib/features/feed/screens/feed_screen.dart)**: News and updates
- **[`MessagesScreen`](lib/features/messages/screens/messages_screen.dart)**: Chat interface

### Widgets
- **[`LeagueCard`](lib/features/leagues/widgets/league_card.dart)**: League display component
- **[`PickCard`](lib/features/picks/widgets/pick_card.dart)**: Player pick interface
- **[`MainNavigation`](lib/core/widgets/main_navigation.dart)**: Bottom navigation bar

## 🎯 User Flows

### Creating a League
1. Navigate to Leagues tab
2. Tap "Create" floating action button
3. Select "Create New League"
4. Configure league settings
5. Invite friends via link

### Making Picks
1. Navigate to Picks tab
2. View available player picks
3. Select "MORE" or "LESS" for stat predictions
4. Add to entry slip
5. Submit with stake amount

### League Chat
1. Navigate to Messages tab
2. Select league chat
3. Send messages, GIFs, or polls
4. View trade notifications and updates

## 🔮 Future Enhancements

### Planned Features
- **Live Draft Room**: Real-time drafting with timer and chat
- **Advanced Statistics**: Detailed player analytics and projections
- **Push Notifications**: Real-time alerts for trades, waivers, and games
- **Offline Support**: Cached data for offline viewing
- **Social Features**: Friend systems and public leagues

### Technical Improvements
- **API Integration**: Connect to real Sleeper API endpoints
- **Authentication**: User login and registration system
- **Database**: Local storage with Hive/SQLite
- **Testing**: Unit and widget tests
- **CI/CD**: Automated testing and deployment

## 🛠 Development

### Adding New Features
1. Create feature directory in `lib/features/`
2. Add screens, widgets, and providers
3. Update routing in `app_router.dart`
4. Add navigation in `main_navigation.dart`

### State Management
The app uses Provider for state management:
- **[`AppProvider`](lib/core/providers/app_provider.dart)**: Global app state
- Feature-specific providers for local state

### Theming
Customize the app appearance in:
- **[`AppTheme`](lib/core/theme/app_theme.dart)**: Colors, typography, and component themes

## 📄 License

This project is a demonstration implementation of the Sleeper fantasy sports platform concept. It is not affiliated with or endorsed by Sleeper Technologies.

## 🤝 Contributing

This is a showcase project demonstrating Flutter development capabilities. The implementation focuses on UI/UX excellence and modern Flutter patterns.

---

**Built with Flutter 💙**

*A complete mobile application showcasing modern fantasy sports platform design and functionality.*
