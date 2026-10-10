# GenToLo - Random Number Generator

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white)
![Version](https://img.shields.io/badge/version-1.1.0-blue)
![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

> 🌐 **Language / Lingua**: [Italiano](README.md) | **English**

**GenToLo** (an acronym for *"Generatore numeri per Tombola e Lotterie"*, i.e. *"Number Generator for Tombola and Lotteries"*) is a fully configurable simulator and random generator of number combinations, developed in **Flutter & Dart** with a custom animation engine and 3D vector graphics rendering on Canvas.

The application lets you freely customize the number of values drawn simultaneously (from 1 to 10) and the upper limit of the drawable numbers (range from 1 to $X$, with $X \le 90$), and includes a **Tombola** mode for progressive draws without replacement.

The project is a modern rewrite and expansion of amateur software written in Visual Basic 6 between 2001 and 2005.

---

## Key Features

### 1. Configurable Draws and Tombola Mode
* **Customizable parameters**: Through the settings dialog, accessible from the badge at the top, the user can choose:
  * **Draw quantity**: from 1 to 10 numbers drawn simultaneously.
  * **Numeric range**: draw from 1 up to a configurable maximum (up to 90).
* **Tombola mode**: Allows sequential progressive draws without replacement of numbers that have already been drawn. A real-time counter tracks the numbers remaining on the board until the game is complete.
* **Automatic saving**: Draw preferences are stored locally on the device.

### 2. The Three Draw Methods
* 🎲 **Random**: Direct random selection of $N$ numbers without repetition. At the end of the chaotic motion simulation, the drawn numbers rise into the upper slots while growing larger, and the remaining ones return in order to the board.
* ❌ **Exclusion**: Random selection of $(Total - N)$ numbers, which are progressively discarded and expelled from the screen with a dedicated animation. The remaining $N$ surviving numbers make up the drawn combination.
* 🔀 **Combination**: Generation of a random permutation of the numbers on the board, followed by the random selection of $N$ positions. The numbers placed in the selected cells are highlighted and moved into the upper slots.

### 3. Functionality
* **Smooth transitions**: When a button is pressed during or after a draw, the balls return in an orderly fashion to the board before the new draw starts.
* **Dynamic sorting**: **Sort (1 ➔ 90)** button to toggle between the natural ascending order and the original draw order.
* **Quick sharing**: Dedicated button to instantly share the drawn numbers through the native system share menu.
* **Offline operation**: No network permissions required, zero telemetry, no tracking and no ads.

### 4. 3D Graphics and Rendering Optimization
* **Canvas rendering**: Custom vector drawing with top-down lighting, light gradients, dark outlines and cast shadows to achieve a realistic spherical effect.
* **Optimized performance**: Text pre-caching and reuse of graphic objects to keep animations smooth and reduce the risk of stutter.

### 5. Random Number Generation
* **Cryptographic source**: The draw engine uses Dart's cryptographically secure generator (`Random.secure()`), based on the operating system's CSPRNG. The available entropy depends on the kernel implementation and on the hardware of each individual device.
* **Algorithmic uniform probability**: Random selection without repetition uses the Fisher-Yates permutation algorithm, guaranteeing the same uniform probability for every draw.

---

## Project Structure

```text
assets/
└── app_icon.png                    # High-resolution source application icon (1024x1024)

lib/
├── controllers/
│   └── lottery_controller.dart         # State management and animation coordination
├── l10n/
│   ├── app_it.arb                      # Italian localization dictionary
│   └── app_localizations.dart          # Localization classes
├── models/
│   ├── extraction_settings.dart        # Settings data model (quantity, range, tombola)
│   └── lottery_ball.dart               # Ball model (coordinates, states and trajectories)
├── painters/
│   ├── ball_3d_painter.dart            # 3D vector rendering of the spheres and slots
│   ├── ball_render_item.dart           # Data model for rendering
│   ├── lottery_scene_painter.dart      # Board and grid rendering
│   └── trajectory_calculator.dart      # Kinematics, turbulence and mathematical trajectories
├── screens/
│   └── lottery_screen.dart             # Main screen and system bar handling
├── services/
│   ├── extraction_service.dart         # Draw algorithms (Random, Exclusion, Combination)
│   └── settings_service.dart           # Local settings persistence via SharedPreferences
├── theme/
│   └── app_theme.dart                  # Centralized color palettes
└── widgets/
    ├── control_panel.dart              # Control panel with the draw buttons
    ├── extraction_settings_dialog.dart # Modal to configure quantity, range and tombola
    ├── info_dialog.dart                # Info window, methods guide and notes
    └── top_bar.dart                    # Top bar with settings badge, info and share buttons
```

---

## Requirements

* **Dart SDK**: >= 3.11.5
* **Flutter SDK**: >= 3.38.0
* **Android SDK**: API 29+ (Android 10+) minSdk
* **Application ID**: `com.ruggio81b.gentolo`

> [!NOTE]
> **Platform Compatibility**: The source code is written in standard Flutter and is architecturally designed to run on both **Android** and **iOS**. However, development and field testing were carried out specifically on **Android** (API 29+).

---

## Flutter Commands

```bash
# Install dependencies
flutter pub get

# Run automated tests
flutter test

# Run static code analysis
flutter analyze

# Launch the application
flutter run
```

---

## Documentation and Notes

* [Full Changelog](CHANGELOG.en.md)
* [Privacy Policy](PRIVACY_POLICY.en.md)
* [Software License](LICENSE)

---

## Purpose of the Software

**GenToLo** is independent software developed exclusively for recreational purposes.

* The application runs entirely locally and offline: it does not handle bets, does not involve real-money transactions and does not guarantee any winnings.
* The software has no connection or affiliation with any official lottery or prize-contest organizations, brands or operators.
* The GitHub issue tracker is reserved exclusively for reporting software bugs and proposing technical improvements to the code.

---

## License and Credits

- **Author**: Fabrizio Ruggiano
- **Development**: The source code of the modern application was entirely generated with Google Antigravity, with the aim of testing the potential of *vibe coding* in rewriting and reworking an existing application developed in an obsolete programming language.
- Developed starting from the idea of an amateur Visual Basic 6 program (2001–2005).
- Released as open source software under the [GNU General Public License v3.0 (GPL-3.0)](LICENSE).

### Graphic Assets and Icon
- The application icon and the original graphic assets were conceived by the author with the support of artificial intelligence tools (Google Gemini), and are distributed under the [Creative Commons Attribution 4.0 International (CC-BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license.

### Third-Party Licenses
- **Flutter Framework & Dart SDK**: [BSD 3-Clause](https://github.com/flutter/flutter/blob/master/LICENSE) license (© The Flutter Authors / The Dart Authors).
- **share_plus**: [BSD 3-Clause](https://github.com/fluttercommunity/plus_plugins/blob/main/packages/share_plus/share_plus/LICENSE) license (© The Flutter Community).
- **shared_preferences**: [BSD 3-Clause](https://github.com/fluttercommunity/plus_plugins/blob/main/packages/shared_preferences/shared_preferences/LICENSE) license (© The Flutter Community).
- **Material Design Icons**: [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license (© Google LLC).
- **Cupertino Icons**: [MIT](https://github.com/flutter/packages/blob/main/packages/cupertino_icons/LICENSE) and [SIL Open Font License 1.1](https://scripts.sil.org/OFL) licenses.
