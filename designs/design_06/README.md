# Design 06 — Liquid Float Navigation

A modern, polished, animated bottom navigation bar in Flutter featuring a raised circular active icon and animated text label connected to a white navigation bar surface by a smooth, morphing semicircular notch.

---

## Visual Design

- **Palette**:
  - Preview background: `#F0ECF6` (soft lavender)
  - Navigation bar: `#FFFFFF` (white surface with 32 px rounded outer bottom corners)
  - Active circular button: `#EC3E8D` (baby-pink with low-opacity soft glow shadow)
  - Active icon: `#FFFFFF` (25 px, pure white)
  - Active label: `#EC3E8D` (14.5 px, `FontWeight.w600`, medium weight)
  - Inactive icons: `#858087` (24 px, regular outlined gray)
  - Inactive labels: `#858087` (13 px, `FontWeight.normal`, regular gray)
- **Geometry & Structure**:
  - Exactly 5 tabs: Home, Search, Likes, Notifications, Profile.
  - Active element: 80 px circular button protruding above the bar, with its label positioned directly beneath the circle and above the navigation bar's main body.
  - Symmetrical semicircular scooped notch in the top edge of the white bar embracing the active cluster.

---

## Component Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `currentIndex` / `selectedIndex` | `int` | `0` | The currently active tab index (0–4). |
| `onTap` / `onTabSelected` | `ValueChanged<int>?` | `null` | Callback invoked when a tab is selected. |
| `items` | `List<LiquidFloatNavItem>` | `defaultItems` | List of navigation tab items. |
| `backgroundColor` | `Color` | `Color(0xFFFFFFFF)` | Navigation bar surface color. |
| `activeColor` | `Color` | `Color(0xFFEC3E8D)` | Accent color for active circle and active label. |
| `inactiveColor` | `Color` | `Color(0xFF858087)` | Color for inactive icons and labels. |
| `circleDiameter` | `double` | `80.0` | Diameter of the raised active circle. |
| `iconSize` | `double` | `24.0` | Inactive icon size in logical pixels. |
| `activeIconSize` | `double` | `25.0` | Active icon size inside the raised circle. |
| `barHeight` | `double` | `72.0` | Height of the navigation bar body. |
| `cornerRadius` | `double` | `32.0` | Corner radius for the bottom corners. |
| `animationDuration` | `Duration` | `380ms` | Duration of the tab-switch animation. |
| `animationCurve` | `Curve` | `LiquidGooeyBounceCurve()` | Liquid gooey bounce easing curve. |
| `useSafeArea` | `bool` | `true` | Automatically insets for bottom device safe area. |

---

## Motion & Liquid Dynamics

1. **Circle Movement**: Glides smoothly horizontally with subtle dynamic stretching (`scaleX` up to $+30\%$) along the motion axis during flight, followed by cushion squash and settling to a perfect circle.
2. **Notch Morphing**: Scooped cubic curve continuously tracks `notchX`, dynamically widening during transit to give an organic liquid feel.
3. **Label Animation**: The previous label gracefully fades and descends, while the incoming label fades in and ascends into place beneath the raised circle, preventing any text overlap.
4. **Inactive Slot Crossfade**: Inactive item at the active index fades out so the active item emerges cleanly, and returns to normal inactive gray styling when deselected.

---

## Usage Example

```dart
import 'package:flutter/material.dart';
import 'liquid_float_navigation.dart';

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
      bottomNavigationBar: LiquidFloatNavigationBar(
        selectedIndex: _currentIndex,
        onTabSelected: (index) {
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

## Standalone Preview Instructions

To run the standalone preview:

```bash
flutter run lib/designs/design_06/design_06_preview.dart
```

Or view directly on the active local web server:
- URL: `http://localhost:8085`
