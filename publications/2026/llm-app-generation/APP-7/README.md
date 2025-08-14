# Guardian Firewall

Guardian Firewall is a device-wide security utility that acts as a shield for all your phone's internet traffic. It provides a foundational layer of security by blocking malware, invasive trackers, and phishing attempts at the source.

---

## Features

- **DNS-Based Threat Filtering:** Routes all DNS queries through a secure, encrypted service to block threats.
- **System-Wide Tracker Blocking:** Blocks known advertising and data-collection trackers across all apps.
- **App-Level Firewall Control:** Allows granular control over which apps can access the internet via Wi-Fi or Cellular data.
- **Real-time Activity Log:** Provides a live feed of all outgoing network connections.
- **Encrypted DNS Protocols:** Encrypts all DNS queries using DNS-over-HTTPS (DoH) or DNS-over-TLS (DoT).
- **Customizable Rules:** Allows advanced users to add their own custom domains to the blocklist or whitelist.

---

## Project Structure

The project is organized into the following directories:

- `lib/api`: Handles network requests, such as fetching updated blocklists.
- `lib/blocs`: Manages the app's state using the BLoC pattern.
- `lib/models`: Defines the data structures for the application.
- `lib/screens`: Contains the UI for the application's screens.
- `lib/services`: Implements background services, such as the VPN and threat filtering.
- `lib/utils`: Provides utility functions and constants.
- `lib/widgets`: Contains reusable UI components.

---

## Getting Started

To get started with the project, follow these steps:

1. **Clone the repository:** `git clone https://github.com/your-username/guardian_firewall.git`
2. **Install dependencies:** `flutter pub get`
3. **Run the app:** `flutter run`

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any improvements or features to add.
