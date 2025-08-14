# Momentum for Reddit

## Purpose

**Momentum for Reddit** is a lightweight, high-performance, third-party client for Reddit, designed to provide the fastest, smoothest, and most battery-efficient browsing experience possible. It is built for users who are frustrated with the official app's lag, intrusive ads, and cluttered interface. Our goal is to deliver pure content with zero friction.

## Features

- **Jank-Free Infinite Scrolling:** A perfectly smooth, 60/120 FPS scrolling experience, achieved through UI virtualization and intelligent content pre-fetching.
- **Optimized Network Layer:** An efficient networking stack that batches API calls and parses JSON data with minimal overhead.
- **Instant Media Loading:** A high-performance image and video caching library that pre-fetches and pre-warms the cache for media that is about to scroll into view.
- **Minimalist, Ad-Free Interface:** A stripped-down UI with no ads, no promotional posts, and no unnecessary animations, resulting in longer battery life.
- **Efficient Comment Rendering:** A highly optimized comment rendering system that only renders visible comments and intelligently collapses deep threads.

## Getting Started

### Prerequisites

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- An IDE such as Visual Studio Code or Android Studio.

### Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/momentum_reddit.git
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd momentum_reddit
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

- `lib/api`: Contains the `RedditApiService` for handling all interactions with the Reddit API.
- `lib/bloc`: Contains the BLoCs for managing the state of the app's screens.
- `lib/models`: Contains the data models for posts, comments, and other Reddit objects.
- `lib/screens`: Contains the main screens of the app, such as the feed and post detail screens.
- `lib/widgets`: Contains reusable UI components, such as the `PostCard` and `CommentWidget`.
- `lib/services`: Contains services such as the `CacheService`.

## Usage

- **Browse the feed:** Simply scroll down to view more posts. The feed will automatically load new content as you scroll.
- **View a post:** Tap on a post to view its content and comments.
- **View media:** Tap on a media thumbnail to open the full-screen media viewer.
- **Dismiss media:** Swipe down on the media viewer to dismiss it and return to the feed.
