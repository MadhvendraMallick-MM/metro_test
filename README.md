# 🚇 Metro Navigator

### A Modern Flutter-Based Metro Navigation Experience

[![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Language-Dart-0175C2?logo=dart)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Flutter%20Supported%20Platforms-blue)](https://docs.flutter.dev/)
[![Status](https://img.shields.io/badge/Status-Development-orange)](https://github.com/MadhvendraMallick-MM/metro_test)

**Metro Navigator** is a Flutter application designed to make metro journey planning easier through station search, route information, fare estimation, station details, and a dedicated metro map interface.

The project combines practical public transport use cases with a modern glassmorphism-inspired user interface, demonstrating how mobile product design and application development can work together to improve the travel-planning experience.

> **Project note:** This repository currently uses simplified metro data and demonstration logic. Route calculations, fare estimates, station timings, facilities, and map information should not be treated as official or real-time transit information.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Key Features](#-key-features)
- [Technology Stack](#-technology-stack)
- [Application Structure](#-application-structure)
- [Getting Started](#-getting-started)
- [Project Limitations](#-project-limitations)
- [Business and Product Management Perspective](#-business-and-product-management-perspective)
- [Future Improvements](#-future-improvements)
- [Skills Demonstrated](#-skills-demonstrated)
- [CV-Ready Project Summary](#-cv-ready-project-summary)

---

## 🎯 Project Overview

Finding the right metro route involves more than selecting two stations. Commuters may also need fare estimates, station information, route details, and a simple way to navigate between these options.

Metro Navigator explores how these needs can be brought together in one mobile application.

### Project Objectives

- Simplify the process of selecting a starting station and destination.
- Present route and fare information through dedicated screens.
- Organize station details and metro map access in one interface.
- Use a modern visual design to make navigation feel intuitive.
- Build a foundation that can be extended with verified transit data and more reliable routing logic.

## ✨ Key Features

### 1. Station Search

- Enter a starting station and destination.
- View matching station suggestions while typing.
- Swap the selected origin and destination.
- Open route details after selecting both stations.

### 2. Route Details

- Display a route between selected stations.
- Present journey-related information through a dedicated screen.
- Represent stations, journey duration, and interchange information using structured data models.

**Important:** The current route-generation logic is simplified. It does not yet establish the optimal route across a complete metro network.

### 3. Fare Calculator

- Select origin and destination stations.
- Calculate a demonstration fare.
- Display token, smart-card, and off-peak fare estimates.
- Swap stations and clear selections.

The fare calculation is currently based on simplified station-list positions and sample discount assumptions. It is not an official metro fare calculator.

### 4. Station Information

- Access station-specific information through a dedicated screen.
- Represent metro lines, train timings, operating hours, and station facilities.
- Organize station details into structured data models.

The displayed information uses sample values and requires verification against official transit sources.

### 5. Metro Map Interface

- Access a dedicated metro map screen.
- Provide a foundation for presenting metro network information within the app.

The presence of a map screen does not imply that the app currently provides a complete, live, geographically accurate metro map.

### 6. Modern User Interface

- Glassmorphism-inspired cards and visual elements.
- Gradient-based screen backgrounds.
- Google Fonts integration.
- Animated screen transitions.
- Bottom navigation across the main app sections.
- Light and dark theme definitions.

### 7. Location-Aware Foundation

The project includes the `geolocator` package and sample station coordinates in its data layer. These provide a foundation for future location-based functionality.

**Current limitation:** The location icon in the station search interface does not yet perform GPS detection, so nearby-station functionality should not be considered implemented.

---

## 🛠 Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application framework |
| Dart | Application programming language |
| Material Design | Core interface components |
| Provider | State-management dependency available in the project |
| Google Fonts | Typography |
| Flutter SVG | SVG asset support |
| Geolocator | Location-related functionality |
| Glassmorphism package | Glass-style visual elements |
| Intl | Date and formatting utilities |

The listed packages are based on the project's dependency configuration. Their inclusion does not necessarily mean that every package is actively used in every screen.

---

## 📂 Application Structure

The main application is organized into screens, models, data, themes, and reusable widgets.

```text
metro_test/
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── lib/
│   ├── data/
│   │   └── metro_data.dart
│   ├── models/
│   │   └── models.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── fare_calculator_screen.dart
│   │   ├── station_info_screen.dart
│   │   ├── metro_map_screen.dart
│   │   ├── route_details_screen.dart
│   │   └── station_arrival_screen.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   └── reusable UI components
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

*This is a high-level view of the project. Additional files may exist within the folders shown.*

### Important Components

- **`main.dart`**: Initializes the application, theme, main screens, and bottom navigation.
- **`metro_data.dart`**: Holds station data, sample coordinates, fare calculations, route generation, and station information.
- **`models.dart`**: Defines data models for stations, routes, fares, line information, and train timings.
- **`screens/`**: Separates the major application experiences into individual screens.
- **`theme/`**: Defines the visual styling and theme configuration.
- **`widgets/`**: Contains reusable interface components.

---

## 🚀 Getting Started

### Prerequisites

Install the following before running the project:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart), generally included with Flutter
- [Git](https://git-scm.com/downloads)
- Android Studio, VS Code, or another compatible development environment
- An Android emulator, iOS simulator on macOS, or supported physical device

### 1. Clone the Repository

```bash
git clone https://github.com/MadhvendraMallick-MM/metro_test.git
```

### 2. Open the Project Directory

```bash
cd metro_test
```

### 3. Check Your Flutter Installation

```bash
flutter doctor
```

Resolve any required SDK or device setup issues reported by Flutter.

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the Application

```bash
flutter run
```

Make sure a compatible emulator or physical device is connected and available.

### 6. Run Static Analysis

```bash
flutter analyze
```

### 7. Run Tests

```bash
flutter test
```

Test results depend on the tests currently included in the repository.

For additional platform-specific instructions, refer to the [official Flutter documentation](https://docs.flutter.dev/).

---

## ⚠️ Project Limitations

Metro Navigator is a development project, and its current sample data and logic have important limitations.

| Area | Current limitation |
|---|---|
| Station data | The station list is incomplete and should be verified and expanded. |
| Route generation | Uses simplified list-based route generation rather than a complete network-routing algorithm. |
| Fare calculation | Uses demonstration calculations rather than official fare rules. |
| Train timings | Uses sample timings that may not match actual service schedules. |
| Station facilities | Uses generic facility lists rather than verified station-level information. |
| Location detection | Location dependencies and sample coordinates exist, but the search GPS action is not implemented. |
| Live updates | No verified live train-arrival or service-status integration is established by the current implementation. |

**Before real-world use:** Verify station connectivity, interchange logic, fares, timings, station facilities, and location permissions. Do not rely on the current estimates to make actual travel decisions.

---

## 💼 Business and Product Management Perspective

Metro Navigator is a useful project for exploring how a customer problem can be translated into a digital product experience.

### 1. Customer-Centric Product Thinking

**User problem:** Metro commuters may need to switch between different sources to plan a journey and understand travel costs.

**Product approach:** Bring station selection, route details, fare estimation, and station information into a single application.

**Business value:** A more convenient journey-planning experience can reduce user effort and make essential information easier to access.

### 2. User Experience and Information Architecture

Separating the app into dedicated screens helps organize distinct user tasks. Station selection, fare estimation, and station information each serve a specific need.

From a product perspective, this creates opportunities to evaluate navigation clarity, task completion, information hierarchy, and interface consistency.

### 3. Value Proposition

The intended value proposition is straightforward:

> Help commuters explore metro journey options and access travel-related information through one easy-to-use interface.

This proposition still needs to be validated through user feedback and reliable transit data.

### 4. Product Metrics to Consider

If the project is developed further, useful product metrics could include:

- **Task completion rate:** Percentage of users who successfully select a route.
- **Time to complete a search:** Time taken to select origin and destination.
- **Fare-calculator usage:** Number of users who use fare estimation.
- **Search abandonment rate:** Percentage of users who leave before completing a route search.
- **Data accuracy rate:** Percentage of displayed transit details verified against official information.
- **User satisfaction:** Feedback on navigation, clarity, and usefulness.

These are proposed metrics, not measured results from the current project.

### 5. Data Quality and Product Reliability

Transit applications depend on accurate station connectivity, fares, timings, and route information. The current sample-data approach highlights why data validation and clear communication of limitations are essential before a product can be trusted by commuters.

---

## 🔭 Future Improvements

The following are potential next steps, not claims about existing functionality.

- Implement graph-based route planning with suitable shortest-path algorithms.
- Add verified station connectivity and interchange relationships.
- Replace mock fares with validated fare rules and clearly state applicable assumptions.
- Add GPS-based nearest-station detection with permission handling.
- Integrate a verified and reliable source for live arrival or service information, if available.
- Improve route alternatives and estimated journey times.
- Add unit and widget tests for routing, fares, and important user flows.
- Conduct usability testing with commuters and prioritize improvements based on feedback.
- Add screenshots and a demonstration video to document the app's actual user experience.

---

## 🧠 Skills Demonstrated

### Technical

- Flutter and Dart application development
- Widget-based UI composition
- Screen navigation and state updates
- Reusable component design
- Data modeling
- Dependency management
- Static analysis and testing workflows

### Business and Product

- Problem identification
- Customer-centric thinking
- User experience planning
- Information architecture
- Value proposition development
- Product metrics selection
- Data quality and reliability awareness
- Feature prioritization

---

## 📄 CV-Ready Project Summary

**Metro Navigator | Flutter-Based Metro Navigation Application**

Developed a Flutter-based metro navigation app concept featuring station search, route-detail screens, fare estimation, station information, and a modern glassmorphism-inspired interface. Structured the application into reusable screens and data models, with opportunities for further development in route optimization, verified transit data, and location-aware functionality.

**Suggested skills to list:** Flutter, Dart, UI/UX Design, Mobile Application Development, Data Modeling, Product Thinking.

*Describe only the implementation and testing work you personally completed when adding this project to your CV.*

---

## 🔗 Project Links

- **GitHub Repository:** [MadhvendraMallick-MM/metro_test](https://github.com/MadhvendraMallick-MM/metro_test)
- **Flutter Documentation:** [docs.flutter.dev](https://docs.flutter.dev/)
- **Dart Documentation:** [dart.dev](https://dart.dev/)

---

## 👨‍💻 About

Metro Navigator explores how a thoughtfully designed mobile interface can make public transport information easier to navigate. The project combines application development with a product-oriented perspective, emphasizing user needs, clear information presentation, and the importance of reliable data.

