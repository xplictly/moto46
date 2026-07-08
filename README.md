# MotoGP macOS Widget App (moto46)

A native macOS widget application that delivers real-time motorsport data directly to your desktop environment. Stay up to date with the latest from the track, right from your Mac.

## Features

- **Three Distinct Widget Modules:** 
  - **Race Calendar:** Keep track of upcoming MotoGP events and schedules.
  - **Driver Standings:** Monitor the current championship points and rankings of your favorite riders.
  - **Constructor Standings:** Stay informed on the tight battle between manufacturers.
- **Flawless Responsiveness:** Optimized layouts for `.systemSmall`, `.systemMedium`, and `.systemLarge` form factors.

## Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Widget Framework:** WidgetKit

## UI / Design Highlights

- **Premium Dark-Mode UI:** Features a high-fidelity, native macOS aesthetic designed specifically for dark mode environments.
- **Advanced Layouts:** Utilizes complex nested layouts and custom styling to present data clearly.
- **Edge-to-Edge Design:** Implements seamless edge-to-edge `.containerBackground` for a modern, bezel-less appearance.

## Architecture & Data Flow

- **WidgetKit Integration:** Built completely using Apple's modern WidgetKit framework.
- **Robust State Management:** Asynchronous updates and state management are handled robustly via `TimelineProvider`, ensuring your widgets are optimized for system resources.
- **Data Source Architecture:** To maintain a decoupled and scalable architecture, the application's data layer currently utilizes static, mocked JSON data. While the UI and presentation logic are fully production-ready, active integration with a live motorsport API is temporarily deferred due to the prohibitive cost of commercial motorsport telemetry APIs for a personal project. This approach ensures the widget remains fully functional for demonstration purposes while standing ready for a seamless live data plug-in.

## Installation / Running Locally

1. Clone the repository to your local machine.
2. Open `moto46.xcodeproj` in Xcode (requires Xcode 15+).
3. Ensure your macOS deployment target is set correctly for WidgetKit compatibility.
4. Select the `MotoGPWidgetsExtension` scheme in Xcode.
5. Hit **Run** (`Cmd + R`) to build and run the widget. You can also add the widget directly to your macOS Desktop or Notification Center to test it in its native environment.
