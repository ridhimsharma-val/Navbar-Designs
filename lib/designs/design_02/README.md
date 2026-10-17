# Design 02: Pill-Expand Bottom Navigation Bar

A modern, standalone, and reusable Flutter bottom navigation bar featuring a **docked white surface with a perfectly straight horizontal top edge**, where the selected navigation item expands smoothly into a soft baby-pink capsule pill revealing an active filled icon and readable text label, while inactive items remain compact gray outline icons.

---

## 1. Visual Characteristics

- **Straight Top Edge**: Perfectly straight, uninterrupted horizontal top edge with a subtle, soft drop shadow (`#0C000000`), following the docked navigation surface treatment of Design 01 (without cutout scoops).
- **Docked White Surface**: Solid white (`#FFFFFF`) surface extending horizontally across the entire width of the mobile viewport.
- **Pill-Expand Selection Mechanism**: The active item expands horizontally into a soft baby-pink pill capsule (`#FCE7EF`) of height `50 px` with fully rounded capsule corners (`25 px` radius).
- **Smooth Animation Transitions**:
  - Horizontal pill expansion & contraction: `300 ms` with `Curves.easeInOutCubic`.
  - Icon cross-fade: Smooth cross-fade between outline and filled glyphs via `AnimatedSwitcher`.
  - Label reveal: Fluid horizontal clipping and opacity fade via `AnimatedAlign` + `AnimatedOpacity`.
- **Active State**:
  - Soft baby-pink capsule pill background: `#FCE7EF`.
  - Vibrant filled active icon: `#EC3E8D` (`24 x 24 px`).
  - Graceful regular active label: `#EC3E8D` (`15.0 px`, weight 400, letter spacing `0.1`).
- **Inactive State**:
  - Subtle gray outline icon: `#858087` (`24 x 24 px`).
  - No visible label text.
  - Transparent item background with minimum accessible tap area ($52 \times 50\text{ px}$).
- **Touch Target & Accessibility**:
  - Minimum tap target of $\ge 48 \times 48\text{ logical pixels}$ per navigation item.
  - Full `Semantics` support for accessibility screen readers (active tab semantics, button role, and label).
- **Safe Area & Home Indicator**: Built-in non-destructive safe-area handling with `useSafeArea: true` that extends the white background through the device's bottom safe-area while leaving the native system gesture bar untouched.

---

## 2. Navigation Items

Design 02 features exactly four items evenly distributed in the specified order:

| # | Label | Inactive Icon | Active Icon |
|---|---|---|---|
| 1 | **Home** | `Icons.home_outlined` (Outline home) | `Icons.home_rounded` (Filled home) |
| 2 | **Wallet** | `Icons.account_balance_wallet_outlined` (Outline wallet) | `Icons.account_balance_wallet` (Filled wallet) |
| 3 | **Analytics** | `Icons.pie_chart_outline_rounded` (Outline pie chart) | `Icons.pie_chart_rounded` (Filled pie chart) |
| 4 | **Settings** | `Icons.settings_outlined` (Outline gear) | `Icons.settings_rounded` (Filled gear) |

---

## 3. Widget API & Properties

`PillExpandBottomNav` is located in `designs/design_02/pill_expand_bottom_nav.dart`.

```dart
PillExpandBottomNav(
  selectedIndex: _selectedIndex,
  onItemSelected: (index) {
    setState(() {
      _selectedIndex = index;
    });
  },
)
```

### Full Property Reference

| Property | Type | Default | Description |
|---|---|---|---|
| `selectedIndex` | `int` | *required* | Current selected tab index (0 to 3). |
| `onItemSelected` | `ValueChanged<int>` | *required* | Callback triggered when a tab is tapped. |
| `items` | `List<PillNavItem>` | `PillNavItem.defaultItems` | List of items to display (defaults to standard 4). |
| `backgroundColor` | `Color` | `Color(0xFFFFFFFF)` | Navigation surface background color. |
| `activeBackgroundColor` | `Color` | `Color(0xFFFCE7EF)` | Background color of the active expanded pill capsule. |
| `activeIconColor` | `Color` | `Color(0xFFEC3E8D)` | Tint color of the active filled icon. |
| `activeLabelColor` | `Color` | `Color(0xFFEC3E8D)` | Text color of the active label. |
| `inactiveIconColor` | `Color` | `Color(0xFF858087)` | Tint color of inactive outline icons. |
| `shadowColor` | `Color` | `Color(0x0C000000)` | Soft drop shadow along the straight top edge. |
| `animationDuration` | `Duration` | `Duration(milliseconds: 300)` | Transition duration for pill expand/contract. |
| `animationCurve` | `Curve` | `Curves.easeInOutCubic` | Animation curve for fluid expansion. |
| `barHeight` | `double` | `72.0` | Height of the navigation strip (excluding bottom safe area). |
| `pillHeight` | `double` | `50.0` | Height of the active expanded capsule pill. |
| `horizontalPadding` | `double` | `16.0` | Horizontal padding for tab items inside the bar. |
| `horizontalMargin` | `double` | `0.0` | Outer left/right margin (0.0 for full-width docked bar). |
| `bottomMargin` | `double` | `0.0` | Outer bottom margin (0.0 for docked bar). |
| `cornerRadius` | `double` | `0.0` | Outer container corner radius (0.0 for straight edge). |
| `maxMobileWidth` | `double` | `double.infinity` | Maximum width constraint for desktop viewports. |
| `useSafeArea` | `bool` | `true` | Automatically extends white background through device safe area. |

---

## 4. How to Use in Any Flutter Screen

```dart
import 'package:flutter/material.dart';
import 'pill_expand_bottom_nav.dart';
import 'pill_nav_item.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0ECF6),
      body: Center(
        child: Text('Active Tab Index: $_currentIndex'),
      ),
      bottomNavigationBar: PillExpandBottomNav(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
```

---

## 5. Safe Area & Home Indicator Guidance

The component includes built-in non-destructive safe area handling:
1. `useSafeArea: true` (default): Automatically queries `MediaQuery.of(context).padding.bottom` and extends the white navigation background through the bottom inset without shifting or compressing the 72 px tab row.
2. The operating system's native gesture indicator (iOS or Android) is never covered, overlapped, or obscured.
3. If the host screen already wraps the bottom in a `SafeArea`, set `useSafeArea: false` to avoid double-spacing.

---

## 6. How to Copy This Component into Another Flutter Project

This design is 100% self-contained:
1. Copy the `designs/design_02/` folder into your target Flutter project (e.g. `lib/components/design_02/`).
2. Import `pill_expand_bottom_nav.dart` and `pill_nav_item.dart`.
3. No third-party dependencies or external packages are required (pure Flutter Material).

---

## 7. Running the Standalone Preview

To launch the standalone preview screen for Design 02:

```bash
flutter run -t designs/design_02/design_02_preview.dart
```

Or view it in the multi-design preview:

```bash
flutter run -d web-server --web-port 8085 -t lib/main.dart
```
