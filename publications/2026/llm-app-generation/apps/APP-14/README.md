# iFood Clone - Flutter App

A comprehensive food delivery application built with Flutter, inspired by iFood - Brazil's leading food delivery platform.

## 🚀 Features

### Core Functionality
- **Multi-Vertical Ordering**: Support for restaurants, supermarkets, pharmacies, and pet shops
- **Advanced Search & Discovery**: Search with filters, categories, and sorting options
- **Real-time Order Tracking**: Live order status updates and delivery tracking
- **Multiple Payment Methods**: Credit/debit cards, PIX, meal vouchers, and cash
- **Location Services**: Address management and delivery area validation
- **User Authentication**: Complete user profile and account management

### Key Screens
- **Home Screen**: Categories, promotional banners, restaurant carousels
- **Search Screen**: Advanced filtering and category-based browsing
- **Restaurant Screen**: Menu browsing and item selection
- **Product Detail**: Item customization and add to cart
- **Shopping Cart**: Order review and modification
- **Checkout**: Payment selection and order confirmation
- **Order Tracking**: Real-time delivery status with map integration
- **Profile**: User settings, addresses, payment methods, and Clube iFood

### Special Features
- **Clube iFood**: Subscription service with monthly discount coupons
- **Promotional System**: Banners, deals, and coupon management
- **Favorites**: Save preferred restaurants and items
- **Order History**: Complete order tracking and reordering
- **Address Management**: Multiple delivery addresses with location services

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── router/          # App navigation and routing
│   └── theme/           # App theme and styling
├── features/
│   ├── auth/            # Authentication and user management
│   ├── cart/            # Shopping cart functionality
│   ├── checkout/        # Order checkout process
│   ├── home/            # Home screen and widgets
│   ├── location/        # Location services and address management
│   ├── main/            # Main navigation structure
│   ├── orders/          # Order history and tracking
│   ├── product/         # Product details and customization
│   ├── profile/         # User profile and settings
│   ├── restaurant/      # Restaurant details and menu
│   ├── search/          # Search and filtering
│   └── tracking/        # Real-time order tracking
└── shared/
    ├── models/          # Data models
    ├── services/        # API and business logic
    └── widgets/         # Reusable UI components
```

### State Management
- **Provider**: Used for state management across the app
- **AuthProvider**: User authentication and profile management
- **CartProvider**: Shopping cart state and operations
- **LocationProvider**: Location services and address management

### Key Models
- **User**: User profile, addresses, and payment methods
- **Restaurant**: Restaurant information, menu, and ratings
- **Product**: Menu items with customization options
- **Order**: Order details, status, and tracking information
- **CartItem**: Shopping cart items with selections

## 🎨 Design System

### Theme
- **Primary Color**: iFood Red (#EA1D2C)
- **Secondary Color**: Orange (#FF6B35)
- **Typography**: Inter font family with various weights
- **Components**: Consistent styling for buttons, cards, and inputs

### UI Components
- **Restaurant Cards**: Horizontal and vertical layouts
- **Category Grid**: Interactive category selection
- **Promotional Banners**: Auto-scrolling promotional content
- **Address Selector**: Location-based address management
- **Search Filters**: Advanced filtering options

## 📱 Screens Overview

### Main Navigation
1. **Início (Home)**: Main discovery screen with categories and restaurants
2. **Busca (Search)**: Search and filter restaurants and items
3. **Pedidos (Orders)**: Active orders and order history
4. **Perfil (Profile)**: User account and settings

### Additional Screens
- **Restaurant Detail**: Menu browsing and item selection
- **Product Detail**: Item customization and options
- **Shopping Cart**: Order review and modification
- **Checkout**: Payment and delivery options
- **Order Tracking**: Real-time delivery status
- **Clube iFood**: Subscription service management

## 🛠️ Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `go_router`: Navigation and routing
- `google_fonts`: Typography
- `cached_network_image`: Image loading and caching

### Location & Maps
- `google_maps_flutter`: Map integration
- `geolocator`: Location services
- `geocoding`: Address geocoding

### Utilities
- `http`: API communication
- `shared_preferences`: Local storage
- `intl`: Internationalization
- `uuid`: Unique ID generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS development setup

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Configuration
- Add Google Maps API key for location services
- Configure payment gateway integration
- Set up backend API endpoints

## 🔧 Development

### Code Style
- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Implement proper error handling
- Add comments for complex logic

### Testing
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows

### Performance
- Optimize image loading with caching
- Implement lazy loading for lists
- Use efficient state management
- Minimize rebuild cycles

## 📋 TODO / Future Enhancements

- [ ] Backend API integration
- [ ] Real-time notifications
- [ ] Social features (reviews, ratings)
- [ ] Advanced analytics
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Accessibility improvements
- [ ] Performance optimizations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is for educational purposes and demonstration of Flutter development skills.

## 🙏 Acknowledgments

- Inspired by iFood's design and user experience
- Flutter community for excellent packages and resources
- Material Design guidelines for UI/UX principles