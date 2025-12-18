
# Quizontal YouTube Downloader - Flutter App Blueprint

## 1. Overview

This document outlines the plan for building the Quizontal YouTube Downloader Flutter application. The app will allow users to download YouTube videos and audio in various qualities by interfacing with the provided backend API. It will be built for Android, adhering to modern development practices and the specific UI/UX designs provided.

## 2. Core Features

- **Video Metadata Fetching**: Users can paste a YouTube URL to fetch video details like title, thumbnail, duration, and views.
- **Quality Selection**: The app will display available MP4 (video) and MP3 (audio) download options.
- **File Downloading**: Users can download files directly to their device's "Download" folder.
- **Download Progress**: The UI will show real-time download progress (percentage, speed, remaining time).
- **Recent Downloads**: The home screen will display a list of recent and in-progress downloads.
- **Permissions Handling**: The app will correctly request necessary permissions for internet access and storage.
- **Settings**: A settings screen will provide options for configuration (e.g., theme, download settings).
- **Onboarding & Splash**: A welcoming user experience with splash and onboarding screens.

## 3. Technical Stack

- **Platform**: Flutter for Android (minSdkVersion 23)
- **State Management**: `provider`
- **Networking**: `dio` (for API calls)
- **File Downloading**: `flutter_file_downloader`
- **Icons**: `lucide_flutter`
- **UI & Styling**:
    - `google_fonts` for typography.
    - `percent_indicator` for progress bars.
- **Notifications**: `flutter_local_notifications` for background download progress.
- **Navigation**: Standard `Navigator` API.

## 4. Project Structure

```
lib/
├── main.dart
|
├── models/
│   └── video_info.dart         # Data models for API responses
|
├── services/
│   └── api_service.dart        # Handles API communication
|
├── providers/
│   └── download_provider.dart    # Manages app state and business logic
|
└── view/
    ├── screens/
    │   ├── splash_screen.dart
    │   ├── onboarding_screen.dart
    │   ├── home_screen.dart
    │   ├── details_screen.dart
    │   ├── downloading_screen.dart
    │   └── settings_screen.dart
    |
    ├── widgets/
    │   ├── download_item.dart
    │   └── quality_selector.dart
    |
    └── theme/
        └── app_theme.dart          # Centralized theme and color definitions

```

## 5. Implementation Plan

1.  **Setup**:
    - Initialize the Flutter project.
    - Add all dependencies to `pubspec.yaml`.
    - Configure `AndroidManifest.xml` for permissions (`INTERNET`, `WRITE_EXTERNAL_STORAGE`, `READ_EXTERNAL_STORAGE`).
    - Set `minSdkVersion` to 23 in `build.gradle.kts`.
    - Create the directory structure as outlined above.
2.  **Core Logic**:
    - Implement the data models in `video_info.dart`.
    - Build the `ApiService` to communicate with `https://yt-web-six.vercel.app/api/api`.
    - Develop the `DownloadProvider` to manage state, fetch data, and handle download logic using `flutter_file_downloader`.
3.  **UI Development**:
    - Create the main `MaterialApp` and define the dark theme in `app_theme.dart`.
    - Build the `SplashScreen` and `OnboardingScreen`.
    - Develop the `HomeScreen` with the URL input field and recent downloads list.
    - Create the `DetailsScreen` to display video metadata and download options.
    - Implement the `DownloadingScreen` with a circular progress indicator.
    - Build out the `SettingsScreen`.
4.  **Integration**:
    - Connect the UI to the `DownloadProvider` to create a reactive user experience.
    - The `flutter_file_downloader` package will handle permission requests and save files to the public "Downloads" folder.
