# ConnectCall

A seamless voice and video calling Flutter application built with Firebase, ZegoCloud, and Riverpod. 

## 🏗 Architecture Overview

This project is built using a feature-based folder structure, enforcing a clear separation of concerns using Riverpod for State Management and Dependency Injection.

### Directory Structure

```text
lib/
├── main.dart                   # Entry point and Riverpod ProviderScope
├── firebase_options.dart       # Firebase platform configurations
│
├── core/                       # App-wide configurations and utilities
│   ├── constants/              # Global variables (Cloudinary, ZegoCloud keys, Firestore collections)
│   ├── router/                 # GoRouter configuration for declarative navigation
│   ├── theme/                  # Global styling, color palettes, and typography
│   └── utils/                  # Helper classes (validators, permissions, error handling)
│
├── models/                     # Strongly typed data models
│   ├── call_model.dart         # Represents a call log entry
│   ├── user_model.dart         # Represents a user profile in Firestore
│   ├── call_type.dart          # Enum for Voice vs Video
│   └── call_status.dart        # Enum for Incoming, Outgoing, Missed
│
├── screens/                    # Full-page UI screens
│   ├── splash/                 # Initial loading and auth-check screen
│   ├── auth/                   # Authentication (Login)
│   └── home/                   # Main authenticated area
│       ├── home_screen.dart    # Shell with custom bottom navigation bar
│       └── views/              # Sub-tabs for the home screen
│           ├── dashboard_view.dart      # Welcome page with horizontal recents & contacts
│           ├── contacts_view.dart       # Vertical list of all contacts
│           ├── recent_calls_view.dart   # Vertical list of all call history
│           └── profile_view.dart        # User profile settings & sign out
│
├── services/                   # Business logic and external API integrations
│   ├── auth_service.dart       # Firebase Authentication wrapper
│   ├── user_service.dart       # Firestore User CRUD operations
│   ├── calling_service.dart    # ZegoCloud WebRTC integration
│   └── image_upload_service.dart # Cloudinary multipart image uploading
│
└── widgets/                    # Reusable UI components
    ├── call_button.dart        # Shared call initiation button
    ├── call_history_card.dart  # Formatted call log list tile
    ├── call_overlay.dart       # Floating incoming call overlay
    ├── custom_bottom_nav_bar.dart # Floating navigation widget
    ├── edit_profile_dialog.dart   # Interactive dialog to update name/avatar
    ├── horizontal_recent_calls.dart # Dashboard horizontal list
    └── user_card.dart          # Formatted contact list tile
```

## 🛠 Tech Stack

*   **Framework:** Flutter
*   **State Management / DI:** Riverpod (`flutter_riverpod`)
*   **Routing:** GoRouter
*   **Authentication & Database:** Firebase Auth + Cloud Firestore
*   **Voice/Video Engine:** ZegoCloud (Zego UI Kits)
*   **Media Storage:** Cloudinary REST API (`http`, `image_picker`)

## 🚀 Getting Started

1. Set up your Firebase project and download `google-services.json` (Android) / `GoogleService-Info.plist` (iOS).
2. Create a ZegoCloud project and put your App ID and App Sign in `lib/core/constants/app_constants.dart`.
3. Put your Cloudinary Cloud Name and Unsigned Upload Preset in `lib/core/constants/app_constants.dart`.
4. Run the app: `flutter run`
