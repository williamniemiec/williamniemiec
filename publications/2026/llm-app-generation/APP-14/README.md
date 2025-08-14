# OneList Mobile Application

OneList is an intelligent, unified list-making app. Its purpose is to completely simplify the process of managing daily tasks by combining to-do lists, shopping lists, and reminders into a single, effortless interface.

## Getting Started

To get started with the OneList app, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd one_list
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app:**
    ```bash
    flutter run
    ```

## Project Structure

The project is organized into the following directories:

-   `lib/`: Contains the main application code.
    -   `api/`: Handles Natural Language Processing and other external services.
    -   `models/`: Contains the data structures, like `ListItem`.
    -   `screens/`: Contains the main UI of the application.
    -   `services/`: For location and notification services.
    -   `utils/`: Contains shared utilities and helper functions.
    -   `widgets/`: For reusable UI components.
-   `test/`: Contains the test suite for the application.
