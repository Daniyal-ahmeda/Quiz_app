# Scientific Quiz App 🧪

A modern, feature-rich Flutter application developed for the Mobile Application Development Final Exam (Fall 2025).

## 📱 Features

### Core Functionality

- **Take Quizzes**: Interactive quizzes with multiple-choice questions.
- **Create Quizzes**: Users can create and publish their own quizzes.
- **Real-time Data**: Powered by **Firebase Firestore**.
- **Difficulty Levels**: Filter quizzes by Easy, Medium, or Hard.
- **Search**: Find quizzes instantly with the search bar.

### User Experience

- **Authentication**: Secure Login & Registration using **Firebase Auth**.
- **User Profiles**: Custom avatars (with Image Upload), bio, and stats.
- **Dark Mode**: Beautiful, persistent dark/light theme.
- **Responsiveness**: Optimized for mobile devices.
- **Performance**: Image caching with `cached_network_image`.

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: Provider + GetIt (Service Locator)
- **Architecture**: Feature-First (Clean Architecture inspired)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.x or later)
- Firebase Account (for backend setup)

### Installation

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/yourusername/quiz_app.git
    cd quiz_app
    ```

2.  **Install Dependencies**:

    ```bash
    flutter pub get
    ```

3.  **Firebase Setup**:

    - Add your `google-services.json` to `android/app/`.
    - Enable **Authentication** (Email/Password).
    - Enable **Firestore Database**.
    - Enable **Storage**.

4.  **Run the App**:
    ```bash
    flutter run
    ```

## 📂 Project Structure

```
lib/
├── core/            # Constants, Services (Theme, Auth, Locator)
├── features/
│   ├── auth/        # Login, Register, Auth Logic
│   ├── onbording/   # Splash, Onboarding Screens
│   ├── profile/     # User Profile, Edit Profile, Stats
│   └── quiz/        # Home, Quiz Taking, Creation, Models
└── main.dart        # Entry point
```

## 🎥 Demo Video

[Link to Demo Video Placeholder]

## 🤖 AI Integration

This project was built with the assistance of AI tools. See [AI_LOG.md](AI_LOG.md) for details.
