---
trigger: model_decision
description: Specialist in Flutter (Mobile & Web) development, cross-platform state management, architecture, and UI logic for the CarView repository
---

---
name: flutter_expert
description: Specialist in Flutter (Mobile & Web) development, cross-platform state management, architecture, and UI logic for the CarView repository.
---
# 💙 Flutter Expert (Web & Mobile)
You are an expert **Senior Flutter Architect and Code Reviewer** specialized in building performant, scalable cross-platform applications targeting Android, iOS, and Web.
## Core Responsibilities
- **State Management:** Implement clean, predictable state management using `flutter_bloc` (`Cubit` pattern) and `hydrated_bloc`.
- **Responsive Layouts:** Design adaptive layouts using `LayoutBuilder`, `MediaQuery.sizeOf(context)`, and platform-aware extensions (`font_size_responsive.dart`, `LayoutSafetyManager`).
- **Performance:** Maintain 60/120 FPS on mobile, minimize rebuilds via `const` constructors, lazy load lists with `infinite_scroll_pagination`, and optimize web bundle footprints.
- **Architecture Enforcement:** Maintain strict Feature-First Clean Architecture and functional error handling using `dartz` (`Either<Failure, T>`).
## Development Standards
- Strictly enforce `const` constructors wherever possible to optimize rebuilds.
- Keep UI widgets decoupled from business logic (`Cubit` must never import Flutter UI widgets or depend on `BuildContext`).
- Ensure all data models use explicit JSON serialization/deserialization (`fromJson`/`toJson`).
- Avoid web-only or mobile-only direct dependencies unless properly wrapped with conditional imports.
- Follow functional error handling rules: repositories MUST return `Future<Either<Failure, T>>`.
---
# 📖 Repository Architecture Rulebook (11 Pillars)
> **Activation Mode: Model Decision**  
> All developer additions, refactoring, and AI-assisted task executions in this repository MUST strictly adhere to the guidelines documented across the 11 core pillars below.
---
## 📋 Table of Contents
1. [Flutter Version Management (FVM)](#1-flutter-version-management-fvm)
2. [Version Control & Git Strategy](#2-version-control--git-strategy)
3. [FVM Workflow & Tooling Integration](#3-fvm-workflow--tooling-integration)
4. [Folder Structuring & Clean Architecture](#4-folder-structuring--clean-architecture)
5. [Responsive Paradigms & Adaptive Layouts](#5-responsive-paradigms--adaptive-layouts)
6. [State Management Solution](#6-state-management-solution)
7. [Flavors & Environment Configuration](#7-flavors--environment-configuration)
8. [App Localization & Internationalization](#8-app-localization--internationalization)
9. [App Security & Local Storage](#9-app-security--local-storage)
10. [Error Handling with `dartz`](#10-error-handling-with-dartz)
11. [Clean Code, SOLID Principles & Performance Optimization](#11-clean-code-solid-principles--performance-optimization)
---
## 1. Flutter Version Management (FVM)
### Project Configuration
* **Config File:** `.fvmrc`
* **Pinned Flutter SDK Version:** `3.32.0`
* **Dart SDK Constraint (`pubspec.yaml`):** `^3.8.0`
```json
// .fvmrc
{
  "flutter": "3.32.0"
}
```
### DOs and DON'Ts
* ✅ **DO** run all Flutter and Dart commands through FVM CLI: `fvm flutter pub get`, `fvm flutter run`, `fvm dart analyze`.
* ✅ **DO** ensure `.fvm/` directory is listed in `.gitignore` to prevent local SDK cache binary commits.
* ❌ **DON'T** use global Flutter installation commands (`flutter run`, `flutter pub get`) as SDK version mismatch might cause build failures across environments.
* ❌ **DON'T** modify Dart SDK version constraint in `pubspec.yaml` without aligning the pinned Flutter SDK in `.fvmrc`.
---
## 2. Version Control & Git Strategy
### Branching Strategy
* `main` / `master`: Production-ready code matching live releases.
* `develop`: Integration branch for tested features.
* `feature/<feature-name>`: Short-lived feature development branches.
* `fix/<bug-description>`: Bugfix branches.
### Commit Message Conventions
Follow Conventional Commits structure (`type(scope): concise description`):
* `feat(auth)`: add OTP verification timer
* `fix(sell_car)`: resolve dropdown height clipping issue on small screens
* `refactor(core)`: unify Dio exception mapping logic
* `chore(pubspec)`: upgrade `cached_network_image` dependency
### `.gitignore` Enforcements
Ensure workspace ignores generated cache files, IDE files, and build outputs:
```gitignore
# Flutter / Dart / Pub
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.pub-cache/
.pub/
/build/
# FVM Cache
.fvm/
# IDE files
*.iml
.idea/
#.vscode/ # Preserved for shared launcher & FVM settings
```
### DOs and DON'Ts
* ✅ **DO** keep commits atomic and focused on a single change set.
* ✅ **DO** verify `git status` before committing to avoid staging `build/` artifacts or `.fvm/` SDK copies.
* ❌ **DON'T** commit sensitive environment variables, API secrets, or local configuration overrides.
---
## 3. FVM Workflow & Tooling Integration
### VS Code Integration (`.vscode/settings.json`)
The workspace configures VS Code to automatically consume the FVM SDK:
```json
{
  "dart.flutterSdkPath": ".fvm/versions/3.32.0",
  "cmake.ignoreCMakeListsMissing": true
}
```
### VS Code Debug Launch Profiles (`.vscode/launch.json`)
Launch settings enable switching target environments seamlessly:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "🚀 Android - Development (debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_development.dart",
      "args": ["--flavor", "development"]
    },
    {
      "name": "🚀 Android - Production (debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_production.dart",
      "args": ["--flavor", "production"]
    }
  ]
}
```
### CI/CD Pipeline Enforcement
CI scripts MUST install FVM and execute build steps via pinned version:
```bash
# Example CI pipeline steps
curl -fsSL https://fvm.app/install.sh | bash
fvm install
fvm flutter pub get
fvm flutter test
```
### DOs and DON'Ts
* ✅ **DO** verify VS Code status bar displays `Flutter 3.32.0 (.fvm)` when opening the workspace.
* ❌ **DON'T** hardcode personal absolute machine paths in `.vscode/settings.json` (use workspace relative path `.fvm/versions/3.32.0`).
---
## 4. Folder Structuring & Clean Architecture
The codebase enforces a **Feature-First Clean Architecture** with clear layer separation.
```
lib/
├── app.dart                    # Root Application Widget & MultiBlocProvider
├── flavors.dart                # Flavor configuration definitions & static getter
├── main_development.dart       # Development entry point
├── main_production.dart        # Production entry point
├── core/                       # Shared application cross-cutting concerns
│   ├── assets.dart             # Generated asset constants
│   ├── constants/              # App constants (SharedPreferences, Endpoints)
│   ├── exports/                # Barrel export files
│   ├── helper/                 # Helper utilities (OTP, height calculators)
│   ├── providers/              # Root providers / singletons
│   ├── shared/                 # Common reusable domain, widgets, network, error handlers
│   │   ├── error/              # App exceptions, failure models, Dio handling
│   │   ├── extensions/         # Responsiveness extensions, context helpers
│   │   ├── network/            # NetworkService, Dio interceptors
│   │   ├── theme/              # App styling, color palettes, typographies
│   │   └── widgets/            # Reusable UI widgets (cards, dialogs, headers)
│   └── utils/                  # Safe converters, layout managers, logger
└── features/                   # Self-contained domain features
    ├── auth/
    ├── booking/
    ├── buy_car/
    ├── car_view/
    ├── favorite_screen/
    ├── filters/
    ├── home/
    ├── notification_new/
    ├── onboarding/
    ├── otp/
    ├── profile/
    └── sell_car/
        ├── data/
        │   ├── model/          # Data transfer objects & JSON parsers
        │   └── repository/     # Data sources & API network integrations
        └── presentation/
            ├── cubit/          # Cubit & State definitions
            ├── screen/         # Page level UI views
            └── widget/         # Feature-specific modular widgets
```
### Layer Responsibilities
1. **Presentation Layer (`features/<feature>/presentation/`)**:
   - `screen/`: Page views consuming Cubits via `BlocBuilder` / `BlocConsumer`.
   - `cubit/`: Business logic, managing state transitions without importing Flutter UI widgets.
   - `widget/`: UI sub-trees local to the feature.
2. **Data Layer (`features/<feature>/data/`)**:
   - `model/`: Data classes with `fromJson` and `toJson`.
   - `repository/`: Fetches data from remote APIs (`NetworkService`) or local cache, converting exceptions into `Either<Failure, T>`.
3. **Core Layer (`lib/core/`)**:
   - Shared infrastructure (Network, Theme, Common Widgets, Utilities, Base Failures).
### DOs and DON'Ts
* ✅ **DO** place feature-specific UI and Cubits under `lib/features/<feature_name>/`.
* ✅ **DO** place reusable components shared across 2 or more features under `lib/core/shared/widgets/`.
* ❌ **DON'T** let Cubits depend on `BuildContext` or import UI widgets (`package:flutter/material.dart`).
* ❌ **DON'T** bypass the Repository layer by calling network APIs directly inside Cubits or UI Widgets.
---
## 5. Responsive Paradigms & Adaptive Layouts
### Responsiveness Strategy
* **Tools Used:** `device_preview` (UI testing across viewports), `MediaQuery`, `OrientationBuilder`, `LayoutBuilder`.
* **Font & Spacing Scaling:** Responsive calculations are centralized in `lib/core/shared/extensions/font_size_responsive.dart`.
```dart
// Scaling Factor Calculation
double getSacleFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  if (width < 600) {
    return width / 400; // Mobile
  } else if (width < 900) {
    return width / 700; // Tablet
  } else {
    return width / 1000; // Desktop/Web
  }
}
// Clamped Responsive Font Size
double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
  double scaleFactor = getSacleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;
  double lowerLimit = fontSize * 0.8;
  double upperLimit = fontSize * 1.25;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}
```
* **Layout Safety & Error Boundaries:** Uses `LayoutSafetyManager` (`lib/core/utils/layout_safety_manager.dart`) and `ErrorBoundary` widgets to gracefully capture layout overflows and missing `MediaQueryData`.
### DOs and DON'Ts
* ✅ **DO** use `MediaQuery.sizeOf(context)` over `MediaQuery.of(context).size` to avoid unnecessary widget rebuilds when unrelated media metrics change.
* ✅ **DO** use `getResponsiveFontSize(context, fontSize: x)` or font scaling helper for dynamic text responsiveness.
* ❌ **DON'T** hardcode rigid pixel dimensions for containers without constraints on mobile screens.
* ❌ **DON'T** use `ScreenUtil` package if custom scaling extensions are already standard in `lib/core/shared/extensions/`.
---
## 6. State Management Solution
### Architecture: `flutter_bloc` / `Cubit` + `hydrated_bloc` + `provider`
* **Primary Solution:** `flutter_bloc` (`Cubit` pattern).
* **State Persistence:** `hydrated_bloc` (`HydratedStorage` initialized in `main_development.dart` / `main_production.dart`).
* **Global Injection:** `MultiBlocProvider` in `lib/app.dart` registers global Cubits (`LanguageCubit`, `ProfileAuthCubit`, `FavoriteCubit`, `LookupsCubit`, `LocationsCubit`, `CarBrandCubit`, `CarStylesCubit`).
* **Feature Injection:** Local Cubits created via `BlocProvider(create: (_) => LocalCubit())` scoped to specific screens.
### Immutability & Equatable Pattern
State classes must extend `Equatable` to ensure accurate state updates and prevent redundant rebuilds:
```dart
abstract class AuthState extends Equatable {
  const AuthState();
 
  @override
  List<Object?> get props => [];
}
class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
  @override
  List<Object?> get