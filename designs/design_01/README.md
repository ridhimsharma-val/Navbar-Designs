# Design 01: Minimal Circle Bottom Navigation Bar

A modern, reusable, and self-contained Flutter bottom navigation bar with an animated white circular highlight and baby-pink accents, faithfully reproducing the reference design.

---

## 1. Visual Characteristics

- **Full-Width Surface**: Solid white (`#FFFFFF`) navigation strip that extends edge-to-edge across the screen with a **perfectly straight horizontal top edge**.
- **No Visible Text Labels**: Pure icon-driven minimalist aesthetic; all 4 items communicate through clean visual iconography and accessible screen-reader semantics.
- **Genuine Concave Scooped Cutout**: The straight horizontal top edge features a smooth, symmetrical concave circular dip (`FullWidthNotchedSurfacePainter`) around the floating active circle.
- **Floating Active Circle**: An elevated white circular disc (`76 px` diameter) with a soft, defined shadow (`#1C7A6882`) protruding upward $\approx 24\text{ px}$ above the straight top edge.
- **Concentric Separation**: A consistent 5 px cutout gap where the light lavender-pink page background (`#F0ECF6`) shows through, cleanly isolating the white circle from the white bar.
- **Synchronized Lockstep Motion**: Both the floating white circle and the concave scoop are driven by a single unified horizontal coordinate (`TweenAnimationBuilder`), guaranteeing 100% synchronization without lag or drift during transitions.
- **Active State**: Vibrant pink filled icon (`#EC3E8D`) centered inside the floating white circle.
- **Inactive State**: Refined gray outline icons (`#858087`) vertically centered within the white strip.
- **Dimensions & Tap Target**:
  - Icons: Exactly `24.0` × `24.0` logical pixels.
  - Interactive Target: Minimum `44.0` × `44.0` logical pixels per tab (accessible).
- **Home Indicator**: Seamlessly extends the white background through the device's bottom safe-area while leaving the native OS home indicator untouched.

---

## 2. Navigation Items

Design 01 features exactly four items evenly distributed across the full width:

| # | Tab Semantics | Inactive Icon | Active Icon |
|---|---|---|---|
| 1 | **Home** | `Icons.home_outlined` (Outline house) | `Icons.home_rounded` (Filled house) |
| 2 | **Search** | `Icons.search_rounded` (Outline magnifying glass) | `BoldSearchIcon` (Bold filled magnifying glass) |
| 3 | **History** | `Icons.access_time_rounded` (Outline clock) | `Icons.watch_later_rounded` (Filled clock) |
| 4 | **Profile** | `Icons.person_outline_rounded` (Outline person) | `Icons.person_rounded` (Filled person) |

---

## 3. Widget API & Properties

`MinimalCircleBottomNav` is located in `designs/design_01/minimal_circle_bottom_nav.dart`.

```dart
MinimalCircleBottomNav(
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
| `onItemSelected` | `ValueChanged<int>` | *required* | Callback triggered upon tab selection. |
| `items` | `List<Design01NavItem>` | `Design01NavItem.defaultItems` | List of items to display. |
| `backgroundColor` | `Color` | `Color(0xFFFFFFFF)` | Navigation surface background color. |
| `activeIconColor` | `Color` | `Color(0xFFEC3E8D)` | Active icon tint. |
| `inactiveIconColor` | `Color` | `Color(0xFF858087)` | Inactive icon tint. |
| `circleShadowColor` | `Color` | `Color(0x1C7A6882)` | Soft shadow around the floating active circle. |
| `topEdgeShadowColor` | `Color` | `Color(0x0A000000)` | Subtle shadow along the straight top edge. |
| `animationDuration` | `Duration` | `Duration(milliseconds: 300)` | Transition duration for circle and cutout scoop. |
| `animationCurve` | `Curve` | `Curves.easeInOutCubic` | Curve for the horizontal glide motion. |
| `barHeight` | `double` | `68.0` | Height of the main navigation strip (excluding protrusion and safe area). |
| `protrusionHeight` | `double` | `24.0` | Upward protrusion allowance for the active circle above the top edge. |
| `notchGap` | `double` | `5.0` | Concentric gap between the circle and concave cutout. |
| `horizontalPadding` | `double` | `16.0` | Horizontal padding for the tab items row, keeping edge tabs comfortable. |
| `maxMobileWidth` | `double` | `double.infinity` | Maximum width constraint (defaults to infinity for edge-to-edge full width). |
| `useSafeArea` | `bool` | `true` | Automatically extends the white background through the bottom safe area. |

---

## 4. How to Use in Any Flutter Screen

```dart
import 'package:flutter/material.dart';
import 'minimal_circle_bottom_nav.dart';

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
      bottomNavigationBar: MinimalCircleBottomNav(
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

The widget includes built-in, non-destructive safe area handling:
1. `useSafeArea: true` (default): Automatically reads `MediaQuery.of(context).padding.bottom` and appends it to the bottom of the container.
2. The operating system's native gesture indicator / home pill (iOS or Android) is never covered, overlapped, or recolored.
3. If the host screen already wraps the bottom in a `SafeArea`, set `useSafeArea: false` to avoid double-padding.

---

## 6. How to Copy This Component into Another Flutter Project

This design is 100% self-contained:
1. Copy the `designs/design_01/` folder into your target Flutter project (e.g. `lib/components/design_01/`).
2. Import `minimal_circle_bottom_nav.dart`.
3. No third-party dependencies or external packages are needed (pure Flutter Material).

---

## 7. Running the Preview

To launch the standalone preview screen for Design 01:

```bash
flutter run -t preview/navigation_preview.dart
```
