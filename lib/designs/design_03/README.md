# Design 03: Liquid Wave Navigation Bar

A playful, fluid, and gooey Flutter bottom navigation bar featuring a **filled, connected baby-pink liquid wave** that organically rises around the active icon and flows playfully across exactly three tabs: **Home**, **Plus**, and **Profile**.

---

## 1. Visual Characteristics

- **Three-Tab Structure**: Exactly three tabs evenly distributed across equal-width slots:
  1. **Home**
  2. **Plus**
  3. **Profile**
- **Docked White Surface**: Solid white (`#FFFFFF`) navigation bar with a straight, horizontal top edge across all inactive regions.
- **Filled, Connected Liquid Wave**:
  - The wave is drawn as a **full, solid, filled baby-pink fluid body** (`#FCE7EF`) that seamlessly connects to the white bar without any detached stroked outlines.
  - Rises organically $24\text{ px}$ above the baseline around the selected tab.
  - Subtle glossy highlight sheen gives fluid depth and water-droplet realism.
- **Gooey Viscous Physics**:
  - **Horizontal Stretch**: While traveling between tabs ($520\text{ ms}$, `Curves.easeInOutCubic`), the liquid wave stretches horizontally ($36\text{ px}$ expansion) in the direction of motion.
  - **Mass Conservation**: The wave height dips slightly during peak velocity.
  - **Elastic Rebound**: Upon reaching the destination tab, the wave snaps together and settles with a soft, bouncy overshoot and gentle rebound.
- **Floating Active Icon & Typography**:
  - The active icon is gently elevated ($8\text{ px}$) into the crest in vibrant pink (`#EC3E8D`, $24\times24\text{ px}$).
  - Active label is rendered in light, graceful typography (`15.0 px`, `FontWeight.w400`, `#EC3E8D`, letter-spacing `0.1`), centered right below the icon.
- **Inactive Items**:
  - Refined gray outline icons (`#858087`, $24\times24\text{ px}$) centered in their respective slots with hidden labels.
- **Touch Target & Accessibility**:
  - Equal-width tap target of $\ge 48 \times 48\text{ logical pixels}$ per item.
  - Full `Semantics` support for accessibility screen readers (active tab semantics, button role, and label).
- **Safe Area Aware**: Automatically queries `MediaQuery.of(context).padding.bottom` and extends the white background through the device's bottom safe area without shifting the navigation row.

---

## 2. Navigation Items

Design 03 features exactly three items evenly distributed in the specified order:

| # | Label | Inactive Icon | Active Icon |
|---|---|---|---|
| 1 | **Home** | `Icons.home_outlined` (Outline home) | `Icons.home_rounded` (Filled home) |
| 2 | **Plus** | `Icons.add_rounded` (Plus) | `Icons.add_rounded` (Plus) |
| 3 | **Profile** | `Icons.person_outline_rounded` (Outline person) | `Icons.person_rounded` (Filled person) |

---

## 3. Widget API & Properties

`LiquidWaveNavigationBar` is located in `designs/design_03/liquid_wave_navigation.dart`.

```dart
LiquidWaveNavigationBar(
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
| `selectedIndex` | `int` | `0` | Current selected tab index (0 to 2). |
| `onItemSelected` | `ValueChanged<int>?` | `null` | Optional callback triggered when a tab is tapped. |
| `items` | `List<LiquidNavItem>` | `LiquidNavItem.defaultItems` | List of items to display (defaults to standard 3: Home, Plus, Profile). |
| `backgroundColor` | `Color` | `Color(0xFFFFFFFF)` | Navigation surface background color. |
| `activeColor` | `Color` | `Color(0xFFEC3E8D)` | Tint color of the active icon and active label. |
| `liquidWaveColor` | `Color` | `Color(0xFFFCE7EF)` | Soft baby-pink tint for the filled liquid wave body. |
| `inactiveColor` | `Color` | `Color(0xFF858087)` | Tint color of inactive outline icons. |
| `animationDuration` | `Duration` | `Duration(milliseconds: 520)` | Transition duration for wave movement and gooey morphing. |
| `barHeight` | `double` | `72.0` | Height of the main navigation strip (excluding wave crest and safe area). |
| `waveHeight` | `double` | `24.0` | Upward height of the liquid wave crest above the straight top edge. |
| `waveWidth` | `double` | `96.0` | Resting horizontal width of the wave crest. |
| `maxMobileWidth` | `double` | `double.infinity` | Maximum width constraint for desktop viewports. |
| `useSafeArea` | `bool` | `true` | Automatically extends white surface through device safe area. |

---

## 4. How to Use in Any Flutter Screen

```dart
import 'package:flutter/material.dart';
import 'liquid_wave_navigation.dart';
import 'liquid_nav_item.dart';

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
      bottomNavigationBar: LiquidWaveNavigationBar(
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
1. `useSafeArea: true` (default): Automatically queries `MediaQuery.of(context).padding.bottom` and extends the white navigation surface through the bottom inset without shifting or compressing the 72 px tab row.
2. The operating system's native gesture indicator (iOS or Android) is never covered, overlapped, or obscured.
3. If the host screen already wraps the bottom in a `SafeArea`, set `useSafeArea: false` to avoid double-spacing.

---

## 6. How to Copy This Component into Another Flutter Project

This design is 100% self-contained:
1. Copy the `designs/design_03/` folder into your target Flutter project (e.g. `lib/components/design_03/`).
2. Import `liquid_wave_navigation.dart` and `liquid_nav_item.dart`.
3. No third-party dependencies or external packages are required (pure Flutter Material).

---

## 7. Running the Standalone Preview

To launch the standalone preview screen for Design 03:

```bash
flutter run -t designs/design_03/design_03_preview.dart
```

Or view it in the multi-design preview:

```bash
flutter run -d web-server --web-port 8085 -t lib/main.dart
```
