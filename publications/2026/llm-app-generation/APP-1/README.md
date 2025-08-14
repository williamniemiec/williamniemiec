# Photon Gallery

A blazingly fast media gallery app engineered for performance.

## App Purpose

**Photon Gallery** is designed to provide an exceptionally fluid and responsive experience for users with massive photo and video libraries (10,000+ items). It eliminates common frustrations of lag, stuttering, and long loading times found in standard gallery apps.

## Features

- **Instantaneous Grid Scrolling:** Scroll through a grid of tens of thousands of thumbnails with zero lag or stutter.
- **UI Virtualization:** Only renders UI elements for items currently visible on the screen.
- **Intelligent Background Caching:** Generates a dedicated cache of thumbnails in the background.
- **Predictive Pre-fetching:** Anticipates user scrolling direction and pre-fetches thumbnails.
- **Efficient Memory Management:** Decodes media to the exact size needed for display.
- **Fluid Grid Resizing:** Adjust the grid size with a pinch-to-zoom gesture.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- An IDE (e.g., Android Studio, VS Code)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd photon_gallery
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

- For Android:
  ```bash
  flutter run
  ```
- For iOS:
  ```bash
  flutter run
  ```

## Project Structure

- `lib/`: Contains the main source code.
  - `screens/`: Contains the main screens of the app.
  - `widgets/`: Contains reusable UI components.
  - `services/`: Contains business logic and services.
  - `utils/`: Contains utility functions and constants.

## Dependencies

- `flutter_staggered_grid_view`: For UI virtualization and grid layout.
- `permission_handler`: For handling permissions.
- `photo_manager`: For accessing photos and videos.
- `cached_network_image`: For efficient image loading and caching.
- `provider`: For state management.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
