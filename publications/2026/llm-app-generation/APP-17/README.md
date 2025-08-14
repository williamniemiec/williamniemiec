# Sentinel Browser

Sentinel Browser is a mobile web browser engineered for privacy and security above all else. Its purpose is to provide users with a secure and anonymous window to the internet, actively defending them against the pervasive tracking, data collection, and digital fingerprinting common in modern web browsing. The app's goal is to reclaim user privacy by default, ensuring that what you do online is your business and yours alone.

## 🚀 Features

-   **Aggressive Tracker & Ad Blocking:** Blocks ads, analytics scripts, and known trackers by default.
-   **Anti-Fingerprinting Measures:** Actively resists digital fingerprinting by randomizing or standardizing browser information.
-   **Strict Site Isolation:** Runs each tab in a sandboxed container to prevent cross-site tracking.
-   **One-Tap "Forget" Button:** Instantly closes all tabs and securely wipes all session data.
-   **JavaScript Control:** Granular, per-site control over JavaScript execution.
-   **Automatic HTTPS Upgrades:** Automatically attempts to upgrade all connections to secure HTTPS.
-   **Optional Tor Integration:** Routes all browsing traffic through the Tor network for maximum anonymity.

## 📦 Getting Started

### Prerequisites

-   Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
-   An editor like VS Code or Android Studio with the Flutter plugin.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/sentinel_browser.git
    cd sentinel_browser
    ```
2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
3.  **Run the application:**
    ```sh
    flutter run
    ```

## Layout and Components

The app's interface is designed to be minimal and unobtrusive, keeping the focus on the web content while making security controls easily accessible.

### 1. Main Browser Screen

-   **Layout:** A clean, full-screen view for web content. A persistent toolbar is anchored to the bottom for easy one-handed access.
-   **Components:**
    -   **Content Area:** The main portion of the screen where websites are rendered.
    -   **Bottom Toolbar:**
        -   **Address/Search Bar:** The central component, where users type URLs or search queries.
        -   **Shield Icon:** Located within the address bar, this icon displays a number indicating how many trackers have been blocked on the current page. Tapping it opens the Shield Menu.
        -   **Tabs Icon:** Shows the number of open tabs and opens the Tabs Screen when tapped.
        -   **"Forget" Icon (Fire 🔥):** A visually distinct button used to wipe the current session.
        -   **Settings Icon (Cogwheel):** Opens the main Settings screen.

### 2. Shield Menu

-   **Layout:** A small pop-up panel that appears above the address bar when the Shield Icon is tapped.
-   **Components:**
    -   A summary text, e.g., "**17** trackers & ads blocked on this site."
    -   A toggle switch labeled "**Protection Enabled**" to quickly disable all blocking for the current site if it's causing issues.
    -   A link to "Advanced Controls" which allows for fine-grained blocking of specific scripts or elements on the page.

### 3. Tabs Screen

-   **Layout:** A vertically scrolling list or a grid of cards, where each card is a thumbnail preview of an open tab.
-   **Components:**
    -   A "Close" (X) button on each tab preview card.
    -   A "Close All Tabs" button.
    -   A "+" button to open a new, clean tab.

### 4. Settings Screen

-   **Layout:** A standard, vertically scrolling list grouped by category.
-   **Components:**
    -   **Privacy & Security:** Toggles for enabling/disabling blocklists, configuring anti-fingerprinting intensity, and enabling Tor Mode.
    -   **Search:** A selector to choose the default private search engine (e.g., DuckDuckGo, Brave Search).
    -   **Data Management:** Options to clear specific types of browsing data on demand.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
