# Quizontal - Video Downloader Blueprint

## Overview

Quizontal is a mobile application for downloading videos from YouTube, Facebook, and TikTok. It provides a simple and intuitive interface for fetching video information, selecting download quality, and managing downloads.

## Design & Style

The application will have a modern, premium dark theme. The primary color scheme will be green on a black background, creating a vibrant and visually appealing user experience.

- **Typography:** Expressive and relevant typography will be used to create a clear visual hierarchy.
- **Color Palette:** A vibrant green color palette will be used for interactive elements, with a black background for a premium look.
- **Iconography:** Modern and intuitive icons will be used to enhance user understanding and navigation.
- **Interactivity:** Interactive elements will have a subtle "glow" effect to provide visual feedback to the user.

## Application Flow

The application will have the following flow:

1.  **Onboarding Screen:** A set of 3 introductory sliders to welcome the user and explain the app's features.
2.  **Splash Screen:** A splash screen will be displayed on app launch, leading to the onboarding or home screen.
3.  **Home Screen:** The main screen of the application, featuring a prominent URL input field for fetching video information. The app will automatically detect the platform (YouTube, Facebook, or TikTok) from the URL.
4.  **Details Screen:** After fetching video information, this screen will allow the user to select the desired video quality and format.
5.  **Downloading Screen:** A dedicated screen to display the progress of ongoing downloads.
6.  **Downloads Manager Screen:** A screen for managing active and completed downloads.

## Features

- Fetch video information from a YouTube, Facebook, or TikTok URL.
- Automatically detect the video platform from the URL.
- Select video quality and format (video or audio).
- Download videos in the background.
- Manage active and completed downloads.
- Modern, premium dark theme.
- Intuitive and easy-to-use interface.
- **Download History:** Persists a list of downloaded videos, which can be viewed and cleared.
- **Video Player:** An in-app video player to watch downloaded videos.

## Platform Support

### YouTube

- Fetches video title, author, duration, views, and thumbnail.
- Provides download links for MP4 (video) and MP3 (audio) formats.

### Facebook

- Fetches video information using the provided API.
- Provides download links for available formats.

### TikTok

- Fetches video information using the provided API.
- Provides download links for available formats.

## Architecture

- **DownloaderFactory:** A factory class that provides the correct downloader service based on the video URL.
- **DownloaderService:** An abstract class that defines the interface for downloading videos.
- **YoutubeDownloaderService, FacebookDownloaderService, TikTokDownloaderService:** Concrete implementations of the `DownloaderService` for each platform.
- **DownloadProvider:** A provider that manages the download state, progress, and history.
