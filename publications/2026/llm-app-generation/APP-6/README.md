# Spatial Measure

Spatial Measure is a powerful utility that transforms a modern smartphone into a portable 3D scanner and measurement tool. It leverages the device's advanced hardware—specifically the camera, LiDAR or Time-of-Flight (ToF) sensor, and Inertial Measurement Unit (IMU)—to rapidly and accurately capture the dimensions and geometry of interior spaces.

---

## Project Structure

The project follows a modular architecture, separating concerns to ensure scalability and maintainability.

```
spatial_measure/
├── lib/
│   ├── app/
│   │   ├── data/
│   │   │   ├── export/        # Logic for exporting to .GLB, .OBJ, .PDF, .DXF
│   │   │   ├── models/        # Data models (e.g., Project, Scan)
│   │   │   └── providers/     # Data sources (e.g., database, file system)
│   │   ├── modules/
│   │   │   ├── home/
│   │   │   │   ├── bindings/  # Dependency injection for Home module
│   │   │   │   ├── controllers/# State management for Home screen
│   │   │   │   └── views/     # UI for Home screen
│   │   │   ├── scanning/
│   │   │   │   ├── bindings/
│   │   │   │   ├── controllers/
│   │   │   │   └── views/
│   │   │   ├── model_viewer/
│   │   │   │   ├── bindings/
│   │   │   │   ├── controllers/
│   │   │   │   └── views/
│   │   ├── routes/
│   │   │   ├── app_pages.dart # Route definitions
│   │   │   └── app_routes.dart  # Route names
│   │   ├── theme/
│   │   │   └── app_theme.dart   # App-wide theme and styling
│   │   └── widgets/
│   │       └── common/        # Reusable widgets (buttons, cards, etc.)
│   ├── main.dart              # App entry point
...
```

### Directory Explanation

-   **`lib/app/data`**: Handles all data-related logic.
    -   **`export`**: Contains the specific implementations for exporting files into different formats (`.obj`, `.pdf`, etc.).
    -   **`models`**: Defines the core data structures of the app, such as `Project` or `ScanSession`.
    -   **`providers`**: Manages data sources, like a local database for storing project information.
-   **`lib/app/modules`**: Contains the different features of the app, organized into self-contained modules.
    -   **`home`**: The main screen, displaying the project library.
    -   **`scanning`**: The live scanning screen, including the camera feed and 3D mesh overlay.
    -   **`model_viewer`**: The screen for viewing and interacting with the 3D model and 2D floor plan.
    -   Each module contains:
        -   **`bindings`**: Sets up dependencies for the module (controllers, services, etc.).
        -   **`controllers`**: Manages the state and business logic for the views.
        -   **`views`**: Contains the UI code (widgets) for the module.
-   **`lib/app/routes`**: Defines navigation for the app.
-   **`lib/app/theme`**: Centralized place for all UI styling, including colors, fonts, and component themes.
-   **`lib/app/widgets`**: A library of custom, reusable widgets shared across the application.
-   **`lib/main.dart`**: The entry point that initializes the app and sets up the initial route.

---

## Getting Started

### Prerequisites

-   Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
-   An IDE like VS Code or Android Studio.

### Setup

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd spatial_measure
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

---

## Dependencies

The following dependencies will be used to achieve the core functionalities:

-   **`get`**: For state management, dependency injection, and routing.
-   **`camera`**: To access the device camera feed.
-   **`ar_flutter_plugin` or similar**: For handling the Augmented Reality aspects, including sensor fusion and mesh generation. (Note: A specific plugin will be chosen based on the best fit for LiDAR/ToF integration).
-   **`path_provider`**: To get the correct file system paths for saving and exporting files.
-   **`share_plus`**: To use the native platform share sheet for exporting.
-   **`permission_handler`**: To request necessary permissions (camera, storage).
-   **`model_viewer_plus`**: For rendering the 3D models in an interactive viewer.
-   **`pdf` & `printing`**: For generating PDF files for floor plans.
