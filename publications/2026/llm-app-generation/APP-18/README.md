# Inkflow

Inkflow is a vector drawing and brainstorming app designed for immediate creative expression. Its core purpose is to provide a digital canvas that feels as responsive and fluid as drawing with a pen on paper.

## Project Structure

The project is organized into the following directories:

- `lib/`: Contains the Dart source code for the application.
  - `core/`: Core application logic and utilities.
  - `features/`: Contains the different features of the app.
    - `drawing/`: The main drawing feature.
      - `models/`: Data models for points and lines.
      - `notifiers/`: State management notifiers.
      - `widgets/`: UI components for the drawing feature.
  - `main.dart`: The main entry point of the application.
- `test/`: Contains the application's tests.

## Getting Started

To get started with the project, clone the repository and run the following commands:

```sh
flutter pub get
flutter run
```

This will install the necessary dependencies and launch the application on your connected device or simulator.
