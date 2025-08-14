# Recipe Rover

Recipe Rover is a smart cooking assistant designed to solve the common problem of "what can I make with what I have?" Its core purpose is to connect to an external recipe database via an API to find delicious and practical recipes based on the ingredients a user already has in their pantry or fridge. The app aims to reduce food waste, spark culinary inspiration, and simplify meal planning by acting as a dynamic, searchable cookbook powered by real-time data.

## Features

-   **Ingredient-Based Recipe Search:** The app's primary function. Users can enter multiple ingredients, and the app sends these as a query to a recipe API to fetch a list of matching recipes.
-   **Dynamic Recipe Filtering:** The app leverages API parameters to allow users to filter the search results. Users can filter by cuisine, diet, or meal type to narrow down the options.
-   **Detailed Recipe View:** When a user selects a recipe from the results, the app makes a second, more specific API call using the recipe's ID. This fetches comprehensive details including a high-quality photo, step-by-step cooking instructions, preparation time, and nutritional information.
-   **"Missing Ingredients" Highlighting:** The app intelligently compares the user's input ingredients with the full ingredient list returned by the API for a selected recipe. It then clearly highlights which ingredients the user is missing, making it easy to create a shopping list.
-   **Similar Recipe Suggestions:** On the detail screen of a recipe, the app can make another API call to find and display a list of "similar" recipes, helping users discover new variations of dishes they enjoy.

## Getting Started

### Prerequisites

-   Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
-   An API key from Spoonacular: [https://spoonacular.com/food-api](https://spoonacular.com/food-api)

### Setup

1.  **Clone the repository:**
    ```
    git clone https://github.com/your-username/recipe_rover.git
    ```
2.  **Navigate to the project directory:**
    ```
    cd recipe_rover
    ```
3.  **Install dependencies:**
    ```
    flutter pub get
    ```
4.  **Add your Spoonacular API key:**
    Open the `lib/utils/constants.dart` file and replace `YOUR_API_KEY` with your actual Spoonacular API key.
    ```dart
    const String apiKey = 'YOUR_API_KEY';
    ```

### Running the App

To run the app, use the following command:
```
flutter run
```

This will launch the app on your connected device or emulator.
