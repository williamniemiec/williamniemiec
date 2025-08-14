# Aegis Vault

Aegis Vault is a zero-knowledge secure enclave for your mobile device. Its purpose is to provide a military-grade encrypted space where users can store their most sensitive files, notes, passwords, and other digital assets. The app is designed to protect user data from all external threats, including device theft, unauthorized access, and remote data breaches, by ensuring that only the user—and no one else, not even the app's developers—can ever access the contents of the vault.

## Features

- **Zero-Knowledge Architecture:** The entire app is built on the principle that the service provider has zero knowledge of the user's data. The user's master password, which encrypts and decrypts their data, is never transmitted to or stored on our servers.
- **End-to-End Encryption (E2EE):** All data is encrypted on the user's device using the AES-256 standard before it is ever written to storage or synced to the cloud.
- **Strong Authentication:**
    - **Master Password:** The vault is sealed with a single, user-created master password that is heavily processed through a key derivation function (PBKDF2) to resist brute-force attacks.
    - **Multi-Factor Authentication (MFA):** Users can add extra layers of security by requiring a second factor for login, including biometrics (Face ID/Fingerprint).
- **Secure Data Storage:** The app leverages platform-native, hardware-backed secure storage for cryptographic keys. This includes the iOS Keychain and the Android Keystore.
- **Runtime Application Self-Protection (RASP):** The app actively defends itself against tampering. It includes checks to detect if it is running on a compromised (jailbroken or rooted) device.

## Getting Started

### Prerequisites

- Flutter SDK: Make sure you have the Flutter SDK installed on your machine. You can find the installation instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install).
- An emulator or a physical device to run the app.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/aegis-vault.git
   ```
2. Navigate to the project directory:
   ```bash
   cd aegis-vault
   ```
3. Install the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

The project is organized into the following directories:

- `lib/`: Contains the main source code of the application.
    - `data/`: Contains the data providers and repositories.
    - `models/`: Contains the data models.
    - `screens/`: Contains the UI screens.
    - `services/`: Contains the business logic services.
    - `utils/`: Contains the utility functions and constants.
    - `widgets/`: Contains the reusable UI widgets.
- `test/`: Contains the unit and widget tests.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you find a bug or have a suggestion for a new feature.
