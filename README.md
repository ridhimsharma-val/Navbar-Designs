# Flutter Bottom Navigation Component Library

A modular, reusable Flutter component library of independent, beautifully crafted bottom navigation bar designs.

Designed to serve as a portable component repository where each navigation design is isolated, self-contained, and ready to be dropped into any Flutter project with zero coupled dependencies on backend, authentication, or routing.

---

## 1. Library Architecture & Folder Structure

```text
animations/
├── pubspec.yaml                 # Flutter package / library configuration
├── README.md                    # Root library documentation (this file)
├── shared/                      # Minimal shared tokens and models
│   ├── navigation_colors.dart   # White & Baby Pink baseline color tokens
│   └── navigation_item.dart     # Standard NavigationItem model & constants
├── designs/                     # Self-contained bottom navigation designs
│   ├── README.md                # Design guide, conventions, and implementation template
│   ├── design_01/               # (Future design)
│   │   ├── custom_bottom_nav.dart
│   │   ├── nav_item.dart
│   │   └── README.md
│   └── ...
└── preview/                     # Interactive testing harness & catalog
    └── navigation_preview.dart  # Preview screen with live diagnostics & tab switching
```

---

## 2. Core Principles

1. **Strict Self-Containment**:
   Each design inside `designs/` is completely decoupled. UI layout, styling, and animation logic are encapsulated within that design's folder.
2. **Zero Project-Specific Coupling**:
   Designs do not depend on application routes, screen widgets, state managers (Bloc/Riverpod/Provider), database, or network requests.
3. **Pluggable & Configurable**:
   Each widget accepts essential control properties:
   - `currentIndex`: Currently active tab index
   - `onTap`: Callback fired when a tab is pressed (`ValueChanged<int>`)
   - `items`: Configurable list of items (`NavigationItem`)
   - Visual tokens: `backgroundColor`, `activeColor`, `inactiveColor`
4. **Standard 5-Item Navigation Baseline**:
   - Items: **Home**, **Search**, **Plus**, **Messages**, **Profile**
   - Palette: **White** & **Baby Pink** (`#FF8DA1`)
   - Standard Icon Size: **24 px**
   - Standard Label Size: **10–12 px** (single line)
   - Minimum Tap Target: **44 × 44 px**
5. **Rock-Solid Safe-Area Awareness**:
   System home indicator and gesture navigation areas are never covered or misaligned.

---

## 3. Safe-Area & Home Indicator Handling

Safe-area handling is a strict requirement for all navigation components in this library:

- **Never Cover the System Indicator**: The OS home indicator (iOS pill / Android gesture bar) must remain unobstructed and visually distinct.
- **Dynamic Inset Resolution**: Always resolve bottom insets dynamically using `MediaQuery.of(context).padding.bottom` or `SafeArea`. Never hardcode `34 px` or any arbitrary padding.
- **Avoid Double-Counting**: If a host application wraps its `Scaffold.body` or parent in a `SafeArea`, the bottom inset passed to the navigation bar may already be `0.0`. Components should adjust naturally.
- **Docked vs Floating Nav Bars**:
  - *Docked*: Extend the solid background to the bottom of the device window, but keep interactive icons and tap targets padded above `padding.bottom`.
  - *Floating*: Elevate the bar with an explicit margin of `baseMargin + padding.bottom`.

---

## 4. How to Add a New Navigation Design

Follow this simple 4-step workflow to implement a new design:

### Step 1: Create the Design Folder
Create a dedicated subfolder under `designs/` using sequential naming:
```text
designs/design_01/
├── custom_bottom_nav.dart
├── nav_item.dart
└── README.md
```

### Step 2: Implement the Component
Create `custom_bottom_nav.dart` exposing the standard properties:
```dart
import 'package:flutter/material.dart';
import '../../shared/navigation_colors.dart';
import '../../shared/navigation_item.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = NavigationItem.standardItems,
    this.backgroundColor = NavigationColors.surfaceWhite,
    this.activeColor = NavigationColors.primaryPink,
    this.inactiveColor = NavigationColors.inactiveGrey,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    // Build your animated navigation bar here...
  }
}
```

### Step 3: Add Individual Documentation
Create `designs/design_01/README.md` detailing:
- Visual preview description
- List of constructor properties
- Minimal copy-paste code example

### Step 4: Register in Preview
Open `preview/navigation_preview.dart` and register your design in `NavigationPreviewRegistry.designs`:
```dart
NavigationPreviewRegistry.designs.add(
  NavigationDesignMeta(
    id: 'design_01',
    title: 'Design 01: [Title]',
    description: '[Description of animation and style]',
    builder: ({required context, required currentIndex, required onIndexChanged, required items}) =>
        CustomBottomNav(
          currentIndex: currentIndex,
          onTap: onIndexChanged,
          items: items,
        ),
  ),
);
```

---

## 5. How to Use a Design in Another Flutter Project

You have two flexible integration options:

### Option A: Direct Copy (Zero External Dependencies)
1. Copy the specific design folder (e.g., `designs/design_01/`) into your target project's `lib/components/navigation/` directory.
2. If your design references `NavigationItem` or `NavigationColors`, copy `shared/navigation_item.dart` and `shared/navigation_colors.dart` into your project, or inline the model directly.
3. Embed in any `Scaffold`:
```dart
Scaffold(
  body: _pages[_selectedIndex],
  bottomNavigationBar: CustomBottomNav(
    currentIndex: _selectedIndex,
    onTap: (index) => setState(() => _selectedIndex = index),
  ),
)
```

### Option B: Package Reference
Reference this folder directly as a local path dependency in your app's `pubspec.yaml`:
```yaml
dependencies:
  animations:
    path: ../path/to/animations
```

---

## 6. Dependencies

- **Flutter SDK**: `>=3.0.0`
- **Dart SDK**: `>=3.0.0 <4.0.0`
- **External Packages**: **Zero third-party dependencies required**. Standard designs rely solely on Flutter's built-in `package:flutter/material.dart` and animation primitives.

---

## 7. Running the Interactive Preview

To run the standalone preview harness with live device diagnostics, tab state switching, and safe-area metrics:

```bash
flutter run -t preview/navigation_preview.dart
```
