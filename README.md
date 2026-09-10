# ConnectCall

**ConnectCall** is a functional 1-to-1 audio and video calling application built with Flutter.

*Tagline:* Connect with anyone, anywhere.

## Project Description
ConnectCall is a real-time communication application designed to facilitate seamless 1-to-1 audio and video calls. It includes user authentication, contact management, call history, and robust call controls, providing a complete calling experience.

## Features
- **Authentication:** Sign in and Registration.
- **Contacts:** View user list, search users, and see online/offline status.
- **User Profile:** View and edit profile details, and log out.
- **Audio Calling:** 1-to-1 audio calls with mute/unmute and speaker controls.
- **Video Calling:** 1-to-1 video calls with camera toggle, front/rear switch, and microphone controls.
- **Incoming Calls:** Accept or decline incoming calls.
- **Call History:** View past calls including caller, time, duration, and status (Missed, Rejected, Ended, etc.).
- **Permissions Handling:** Graceful handling of camera and microphone permissions.

## Flutter Version
*To be documented (e.g., Flutter 3.24.x)*

## Packages Used
*To be updated as development progresses. Expected packages include state management, permissions, backend integration, and a calling SDK.*

## Architecture
The application follows a clean, structured architecture:
```
lib/
├── core/         # Constants, themes, and utilities
├── models/       # Data models
├── services/     # API, Backend, and SDK integrations
├── screens/      # UI screens and navigation
├── widgets/      # Reusable UI components
└── main.dart     # Application entry point
```

## Backend Used
*To be selected (e.g., Firebase Authentication & Firestore)*

## Calling SDK Used
*To be selected (e.g., ZEGOCLOUD, Agora, WebRTC, or Stream Video)*

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone <repository_url>
   ```
2. Navigate to the project directory:
   ```bash
   cd connectcall
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure the environment variables for the chosen Backend and Calling SDK (see below).
5. Run the application:
   ```bash
   flutter run
   ```

## Environment Variables / Configuration
To securely manage secrets, create a `.env` file in the root directory (this file is ignored by Git). Add your API keys and configuration values as needed:

```env
# Example .env file structure
BACKEND_API_KEY=your_backend_api_key
CALLING_SDK_APP_ID=your_calling_sdk_app_id
CALLING_SDK_APP_SIGN=your_calling_sdk_app_sign
```

## Known Limitations
*To be documented (e.g., limitations with background push notifications or unsupported platforms).*

## AI Tools Used
*To be disclosed by the developer (e.g., Gemini, Copilot, Cursor) along with how they were utilized.*
