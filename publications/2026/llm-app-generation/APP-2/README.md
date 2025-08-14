# SwiftScan

SwiftScan is an industrial-grade, high-performance barcode and QR code scanning utility for Flutter. It leverages a highly optimized computer vision engine to detect, track, and decode multiple barcodes simultaneously from a live video stream.

## Features

- **Real-time Multi-Code Detection:** Detects and highlights numerous barcodes and QR codes in a single frame.
- **High-Performance Parallel Decoding:** Uses a multi-threaded process to decode dozens of codes per second.
- **Continuous Scan Mode:** Accumulates a running list of all unique codes successfully decoded.
- **Efficient Augmented Reality (AR) Overlay:** Provides instant feedback with color-coded bounding boxes:
    - **Green:** A new, unique code has been successfully scanned.
    - **Yellow:** A duplicate code has been detected.
    - **Red:** A damaged or unsupported barcode has been detected but could not be decoded.
- **Instant Data Export:** Export the accumulated list of scanned barcode data as a CSV or plain text file.

## Getting Started

### Prerequisites

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- An editor like Visual Studio Code or Android Studio.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/swift_scan.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd swift_scan
   ```
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

### Running the Application

1. **Connect a device or start an emulator.**
2. **Run the app:**
   ```bash
   flutter run
   ```

## Usage

1. **Launch the app.** The main scanning screen will immediately activate the camera.
2. **Tap "Start Session"** to begin scanning.
3. **Pan the camera** across the barcodes or QR codes you want to scan.
4. **Monitor the live data panel** at the bottom of the screen to see the number of unique and duplicate scans, as well as the most recently scanned code.
5. **Tap "Pause Session"** to pause the scanning process.
6. **Tap "Clear List"** to reset the scanned data.
7. **Tap "Export"** to share the scanned data as a CSV file.
