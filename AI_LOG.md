# AI Integration Log 🤖

## 1. Project Planning & Architecture

- **Tool**: Google Gemini (Antigravity Agent) / Deepmind Coding Agent
- **Usage**:
  - Breakdown of exam requirements into weekly tasks.
  - Architecture design (feature-first folder structure).
  - State management selection (Provider + GetIt).
- **Prompt Example**: "Create a comprehensive implementation plan for a Flutter Quiz App based on these exam requirements..."

## 2. Code Generation & Refactoring

- **Tool**: Google Gemini
- **Usage**:
  - Generating boilerplate code for Models (`Quiz`, `Question`, `Character`).
  - Creating reusable widgets (`QuizTextField`, `ChoiceTile`).
  - Refactoring huge files (e.g., splitting `HomePage` into smaller widgets).
  - Fixing lint errors and build issues.
- **Prompt Example**: "Refactor `HomePage` to use extracted widgets for better readability."

## 3. Debugging & Problem Solving

- **Tool**: Google Gemini
- **Usage**:
  - diagnosing "White Screen" issues (Firebase initialization checks).
  - Resolving Gradle build errors (plugin management).
  - Fixing `UnimplementedError` in `QuizService` when switching to Firestore.
- **Prompt Example**: "I'm getting a Gradle error about `pluginManagement`. How do I fix this only in `settings.gradle`?"

## 4. Design & Assets

- **Tool**: Google Gemini (Image Generation - Conceptual)
- **Usage**:
  - Generating placeholder images for placeholders (if needed).
  - Designing color palettes (Material 3 implementation).
- **Prompt Example**: "Suggest a dark mode color scheme for a scientific quiz app."

## 5. Documentation

- **Tool**: Google Gemini
- **Usage**:
  - Writing this log file.
  - Generating the README.md with setup instructions.
  - Creating the Walkthrough.md for final presentation.

## 6. Performance Optimization

- **Tool**: Google Gemini
- **Usage**:
  - Identifying performance bottlenecks in image loading.
  - Integrating `cached_network_image` for efficient memory usage.
  - Optimizing `ProfilePage` and `EditProfilePage` rebuilds.
- **Prompt Example**: "How do I cache network images in Flutter to save bandwidth?"
