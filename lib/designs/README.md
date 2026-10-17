# Navigation Designs Directory (`designs/`)

This directory is the home for all individual bottom navigation bar designs in the library.

> [!IMPORTANT]
> **Strict Isolation Principle**: Every design in this directory must be 100% self-contained. Any design folder (e.g., `design_01/`) can be copied into another Flutter project independently without dragging in extraneous application dependencies.

---

## 1. Directory Structure for Each Design

When creating a new design, create a dedicated folder formatted as `design_XX/` (e.g., `design_01`, `design_02`, etc.):

```text
designs/
├── README.md                 <-- (This file)
├── design_01/
│   ├── custom_bottom_nav.dart <-- Main exported navigation bar widget
│   ├── nav_item.dart          <-- Design-specific item component or tile
│   └── README.md              <-- Documentation, props, and standalone usage
├── design_02/
│   ├── custom_bottom_nav.dart
│   ├── nav_item.dart
│   └── README.md
└── ...
```

---

## 2. Standard Baseline Specification

Unless explicitly instructed otherwise, every design must adhere to these standard baseline specifications:

| Requirement | Specification |
| :--- | :--- |
| **Color Theme** | White (`NavigationColors.surfaceWhite`) & Baby Pink (`NavigationColors.primaryPink`) |
| **Navigation Items** | Standard 5 items: **Home**, **Search**, **Plus**, **Messages**, **Profile** |
| **Icon Size** | `24.0` px |
| **Label Typography** | `10.0` – `12.0` px, short, sweet, single-line text |
| **Minimum Tap Target** | `44.0` × `44.0` px (for accessibility compliance) |
| **States** | Distinct active and inactive states (icon fill/variation, color, or indicator animations) |
| **Separation** | Subtle border (`NavigationColors.borderSubtle`) or elevation/contrast separating bar from content |
| **Notification Badges** | Only displayed when explicitly requested or when `badgeCount != null` / `showBadgeDot == true` |

---

## 3. Safe Area & Home Indicator Rules

Every design must handle system safe areas flawlessly across Android and iOS devices:

1. **Never cover the home indicator**:
   The iOS home indicator and Android gesture bar must never be covered, recolored, or overlapped by interactive tab buttons.
2. **Docked vs. Floating Designs**:
   - **Docked Bar** (spans full width, touches screen bottom):
     Extend the background container down to the bottom of the screen, but wrap the interactive bar contents in a bottom safe-area pad:
     ```dart
     final bottomPadding = MediaQuery.of(context).padding.bottom;
     // Add bottomPadding to the container's bottom padding
     ```
   - **Floating / Island Bar** (floats above screen bottom):
     Offset the floating container by the bottom safe area:
     ```dart
     final bottomPadding = MediaQuery.of(context).padding.bottom;
     margin: EdgeInsets.only(bottom: 16.0 + bottomPadding, left: 16.0, right: 16.0),
     ```
3. **Avoid double-counting**:
   If the parent screen or scaffold already wraps the widget in a `SafeArea`, `MediaQuery.padding.bottom` will be `0.0`. Never hardcode an artificial `34.0` px constant onto all devices.

---

## 4. Design Widget Signature Template

When implementing `custom_bottom_nav.dart`, expose standard configurable properties:

```dart
import 'package:flutter/material.dart';
import '../../shared/navigation_colors.dart';
import '../../shared/navigation_item.dart';

class CustomBottomNav extends StatelessWidget {
  /// Currently selected tab index (0-indexed).
  final int currentIndex;

  /// Callback invoked when the user selects a tab.
  final ValueChanged<int> onTap;

  /// Navigation items to render (defaults to standard 5 items).
  final List<NavigationItem> items;

  /// Background color of the navigation bar.
  final Color backgroundColor;

  /// Active accent color (default: baby pink).
  final Color activeColor;

  /// Inactive item color (default: subtle grey).
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
    // Implementation
  }
}
```

---

## 5. Registering in the Preview

Once a new design is created, register it in `preview/navigation_preview.dart` by adding an entry to `NavigationPreviewRegistry.designs`:

```dart
NavigationPreviewRegistry.designs.add(
  NavigationDesignMeta(
    id: 'design_01',
    title: 'Design 01: [Descriptive Name]',
    description: '[Brief description of visual style and animation]',
    builder: ({
      required BuildContext context,
      required int currentIndex,
      required ValueChanged<int> onIndexChanged,
      required List<NavigationItem> items,
    }) {
      return Design01BottomNav(
        currentIndex: currentIndex,
        onTap: onIndexChanged,
        items: items,
      );
    },
  ),
);
```

The preview screen will automatically provide a dropdown selector to preview the design.
