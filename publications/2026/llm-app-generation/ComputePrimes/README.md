# ComputePrime

ComputePrime is a high-performance, offline mobile tool for computationally intensive number theory calculations. It is designed for mathematics students, educators, researchers, and hobbyists who need a powerful computational tool for prime number operations.

## Features

- **Check Primality:** Determine if a given number is prime.
- **Find Primes in Range:** Find all prime numbers within a specified range.
- **Calculate Next Prime:** Find the next prime number after a given number.

## Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/ComputePrime.git
   cd ComputePrime
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Run the application:**
   - **Android:**
     ```bash
     npx react-native run-android
     ```
   - **iOS:**
     ```bash
     npx react-native run-ios
     ```

## Usage

1. **Enter a number or range:**
   - For "Check Primality" and "Calculate Next Prime," enter a single integer.
   - For "Find Primes in Range," enter a range in the format `start-end`.

2. **Select an operation:**
   - Choose one of the three available operations using the radio buttons.

3. **Execute the calculation:**
   - Press the "EXECUTE" button to start the calculation. The UI will become unresponsive until the calculation is complete.

4. **View the result:**
   - The result of the calculation will be displayed in the text area at the bottom of the screen.
