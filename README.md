# Scientific Quizzes App 🧠

A modern, comprehensive quiz application built with Flutter, designed to test your knowledge in programming and DevOps topics.

## Features 🚀

- **📚 Diverse Categories**: Test your skills in **Linux**, **SQL**, **Docker**, and **DevOps**.
- **🎚️ Difficulty Levels**: Filter quizzes by **Easy**, **Medium**, or **Hard**.
- **🌙 Dark Mode**: A sleek, high-contrast dark theme that persists across sessions.
- **🔒 Secure**: API keys are reliably managed using environment variables (`.env`).
- **⚡ Optimized**: Parallel API requests ensure fast loading times.
- **🛡️ Robust**: Gracefully handles network errors and API rate limits (HTTP 429) with retry options.
- **✨ Polished UI**: Smooth animations, theme-aware components, and a user-friendly interface.

## Screenshots 📸

|          Light Mode           |          Dark Mode           |
| :---------------------------: | :--------------------------: |
| _(Add Light Mode Screenshot)_ | _(Add Dark Mode Screenshot)_ |

## Getting Started 🛠️

### Prerequisites

- Flutter SDK installed
- An API Key from [quizapi.io](https://quizapi.io/)

### Installation

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/yourusername/quiz_app.git
    cd quiz_app
    ```

2.  **Install dependencies**:

    ```bash
    flutter pub get
    ```

3.  **Configure API Key**:

    - Create a file named `.env` in the root directory.
    - Add your API key:
      ```env
      QUIZ_API_KEY=YOUR_API_KEY_HERE
      ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

## Tech Stack 💻

- **Framework**: [Flutter](https://flutter.dev/)
- **Network**: [http](https://pub.dev/packages/http)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Configuration**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- **Fonts**: [google_fonts](https://pub.dev/packages/google_fonts)

## Project Structure 📂

```
lib/
├── core/
│   ├── constants/    # App colors, icons, and strings
│   ├── services/     # ThemeService, ServiceLocator
│   └── widgets/      # Reusable widgets (CommonButton)
├── features/
│   └── quiz/
│       ├── data/     # API services and Models
│       └── presentation/
│           ├── pages/    # HomePage, QuizPage, ResultPage
│           └── widgets/  # ChoiceTile
└── main.dart         # Entry point & App Configuration
```
