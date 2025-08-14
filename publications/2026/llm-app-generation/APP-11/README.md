# Quantum Trade

**Quantum Trade** is a mobile trading platform designed for active traders who demand institutional-grade responsiveness. Its purpose is to deliver the lowest possible latency in both receiving market data and executing trade orders. The entire application is engineered to provide immediate feedback, from real-time price updates to instant order confirmations, ensuring users can react to market movements as quickly as they happen.

---

## Features

- **Real-Time Streaming Data:** The app uses a persistent **WebSocket connection** to stream market data directly from the source. Prices, quotes, and order book updates appear on the screen tick-by-tick, with no polling or refresh delays. 📈
- **Fluid Interactive Charts:** Candlestick charts are rendered using a high-performance graphics engine. Users can **pan, zoom, and scrub** through historical data with perfect fluidity. Placing a finger on the chart instantly brings up a crosshair with detailed price information for that exact point in time.
- **One-Tap Order Execution:** The interface for placing trades is optimized for speed. Once a user has configured a trade, a single tap on the "BUY" or "SELL" button sends the order to the exchange in milliseconds. The button provides **instant haptic feedback** to confirm the input was received.
- **Instantaneous Order Status Notifications:** The moment a trade order is submitted, filled, or canceled by the exchange, the app displays an immediate, non-intrusive on-screen notification. This provides critical feedback without requiring the user to navigate to a different screen.
- **Responsive "Live" Watchlist:** The user's watchlist is not a static list of prices. It's a living dashboard where prices and percentage change figures **flash green or red in real-time** as the market moves, providing an immediate, at-a-glance understanding of market dynamics.
- **Low-Latency Interface:** Every tap, swipe, and gesture within the app results in an immediate UI response. Screens transition instantly, and data appears as soon as it's available, with no spinners or loading bars.

---

## Getting Started

### Prerequisites

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Dart SDK: [https://dart.dev/get-dart](https://dart.dev/get-dart)
- An IDE such as Android Studio or Visual Studio Code

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/quantum_trade.git
   ```
2. Navigate to the project directory:
   ```bash
   cd quantum_trade
   ```
3. Install the dependencies:
   ```bash
   flutter pub get
   ```

---

## Running the Application

To run the application, use the following command:
```bash
flutter run
```

---

## Project Structure

The project is structured as follows:

```
quantum_trade/
├── android/            # Android specific files
├── ios/                # iOS specific files
├── lib/
│   ├── main.dart       # Main entry point of the application
│   ├── api/            # WebSocket connection and data handling
│   ├── models/         # Data models for assets, orders, etc.
│   ├── screens/        # UI screens (Dashboard, Asset Detail)
│   ├── services/       # Business logic and services
│   └── widgets/        # Reusable UI components (charts, buttons)
├── test/               # Unit and widget tests
└── pubspec.yaml        # Project dependencies and configuration
```

---

## Dependencies

The following dependencies are used in this project:

- `flutter/material.dart`: For UI components
- `web_socket_channel`: For WebSocket communication
- `candlestick_chart`: For candlestick charts
- `haptic_feedback`: For haptic feedback on button taps
- `provider`: For state management

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
