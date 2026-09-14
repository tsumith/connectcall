# ConnectCall

*Connect with anyone, anywhere.*

## 📝 Project Description
ConnectCall is a functional 1-to-1 voice and video calling application built with Flutter. It allows users to create accounts, view contacts, make and receive real-time audio and video calls, and check their call history. The application emphasizes clean architecture, robust state management, and real-time backend synchronization.

## ✨ Features
- **Authentication**: Secure sign in and account creation via Firebase Authentication.
- **Contacts**: Browse a list of registered users with online/offline status indicators.
- **Audio Calling**: 1-to-1 functional audio calls with mute/unmute and speaker controls.
- **Video Calling**: 1-to-1 functional video calls with camera toggling, front/rear camera switching, and microphone controls.
- **Incoming Calls**: Receive calls, with options to accept or decline.
- **Call History**: View past calls (Caller/callee, Call type, Time, Duration, and Call status such as Missed, Rejected, or Completed).
- **User Profile**: View and edit user profile details, including uploading custom avatars.
- **Permissions Handling**: Proper handling of Camera and Microphone permissions prior to calls.
- **Dynamic UI/UX**: Custom bottom navigation bar, dynamic call overlays, and dark/light mode support.

## 📱 Flutter Version
- **Flutter SDK:** `^3.12.2` (or above)

## 📦 Packages Used
- `flutter_riverpod` (^3.4.3): State management and dependency injection.
- `firebase_core` (^4.14.0), `firebase_auth` (^6.6.1), `cloud_firestore` (^6.9.0): Backend integration (Authentication, Real-time Database).
- `zego_uikit_prebuilt_call` (^4.24.4): Real-time calling SDK for WebRTC.
- `go_router` (^18.0.1): Declarative and scalable routing.
- `flutter_dotenv` (^5.1.0): Secure environment variable management.
- `permission_handler` (^12.0.3): Managing and requesting device permissions.
- `image_picker` (^1.2.3), `http` (^1.6.0): Image selection and HTTP requests for uploading to Cloudinary.
- `shared_preferences` (^2.5.5): Local persistent storage.
- `intl` (^0.20.2): Date and time formatting for call history.

## 🏗 Architecture
This project is built using a feature-based folder structure, enforcing a clear separation of concerns.

```text
lib/
├── main.dart                   # Entry point and Riverpod ProviderScope
├── firebase_options.dart       # Firebase platform configurations
│
├── core/                       # App-wide configurations and utilities
│   ├── constants/              # Global variables and environment keys
│   ├── router/                 # GoRouter configuration
│   ├── theme/                  # Global styling, light/dark themes
│   └── utils/                  # Helper classes and formatters
│
├── models/                     # Strongly typed data models (User, Call, CallStatus)
│
├── screens/                    # Full-page UI screens (splash, auth, home, views)
│
├── services/                   # Business logic and external API integrations
│   ├── auth_service.dart       
│   ├── user_service.dart       
│   ├── calling_service.dart    
│   └── image_upload_service.dart
│
└── widgets/                    # Reusable UI components (buttons, cards, overlays)
```

## 🗄 Backend Used
- **Firebase Authentication**: Used for real authentication (Email/Password).
- **Firebase Cloud Firestore**: Used as the primary real-time database to store user profiles, online statuses, and call history logs.
- **Cloudinary**: Used via REST API for storing and serving user profile avatars.

## 📞 Calling SDK Used
- **ZegoCloud (Zego UI Kits)**: Selected for its robust Flutter support, pre-built UI components that significantly speed up development, cross-platform stability, and reliable real-time communication infrastructure for both audio and video calls. It seamlessly handles connection states and background integrations.

## 🚀 Setup Instructions
1. **Clone the repository.**
2. **Install dependencies:** Run `flutter pub get`.
3. **Configure Firebase:**
   - Set up a Firebase project and add Android/iOS apps.
   - Download and place `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) in their respective directories.
4. **Configure ZegoCloud:**
   - Create a project on the ZegoCloud console.
   - Obtain the App ID and App Sign.
5. **Set up Environment Variables:** Create a `.env` file in the root directory (see *Environment variables/configuration* below).
6. **Run the app:** Use `flutter run`.

## ⚙️ Environment Variables/Configuration
Create a `.env` file in the root directory of the project with the following keys. Make sure the values match your backend services.

```env
# ZegoCloud 
ZEG0_APP_ID=your_zego_app_id
ZEG0_APP_SIGN=your_zego_app_sign

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_cloudinary_upload_preset
```

## ⚠️ Known Limitations
- Push notifications for background incoming calls may require additional native platform setup depending on the OS (APNs for iOS, FCM for Android via ZegoCloud console).
- App currently assumes a reliable internet connection; edge cases like switching networks during an active call might cause temporary disconnections.
- Cloudinary requires an unsigned upload preset to function properly from the client side.

## 🤖 AI Tools Used
- **Gemini  via Antigravity IDE**: Used for AI-assisted development, code generation, refactoring, and documentation drafting.
