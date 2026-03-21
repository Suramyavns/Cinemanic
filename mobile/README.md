# Cinemanic Mobile - Flutter Application

Cinemanic is a sleek, modern movie and TV show discovery application built with Flutter. It provides users with a premium experience for browsing trending content, searching for movies, and managing their watchlists.

## 🚀 Getting Started

Follow these instructions to get the mobile application up and running on your local machine for development and testing.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version recommended)
- [Dart SDK](https://dart.dev/get-started/sdk)
- Android Studio / VS Code with Flutter extension
- An Android Emulator, iOS Simulator, or a physical device

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Suramyavns/Cinemanic.git
    cd cinemanic/mobile
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Environment Setup:**
    Create a `.env` file in the `mobile` root directory and add the following variables:
    ```env
    SERVER_URL=https://cinemanic.vercel.app
    FIREBASE_WEB_CLIENT_ID=your_firebase_web_client_id
    IMAGE_BASE_URL=https://image.tmdb.org/t/p/w500
    ```
    *(Note: Replace `your_firebase_web_client_id` with your actual Firebase Web Client ID found in your Firebase console).*

4.  **Run the application:**
    ```bash
    # Run in debug mode
    flutter run
    ```

## 🛠️ Environment Variables

The application uses a `.env` file for configuration. Ensure the following keys are present:

| Key | Description | Example Value |
| :--- | :--- | :--- |
| `SERVER_URL` | The base URL for the backend API
| `FIREBASE_WEB_CLIENT_ID` | OAuth Client ID for Google Sign-In
| `IMAGE_BASE_URL` | Base URL for fetching TMDb images

## 📱 Features

- **Modern UI**: "Adventure Dark" design system for a premium feel.
- **Content Discovery**: Browse trending movies and TV shows via TMDb integration.
- **Authentication**: Secure login using Firebase (Phone & Google).
- **Watchlist**: Manage your personal list of content to watch.
- **Responsive Design**: Optimized for various screen sizes using `LayoutBuilder`.

## 📂 Project Structure

- `lib/`: Main source code.
    - `screens/`: UI screens (Home, Profile, Search, etc.).
    - `widgets/`: Reusable UI components.
    - `services/`: API and Firebase service logic.
    - `models/`: Data models for movies, shows, etc.
- `assets/`: Images, fonts, and local resources.
- `android/` & `ios/`: Platform-specific configurations.
