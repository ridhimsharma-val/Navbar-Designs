# Design 07 — Dot Indicator Navigation

A minimal, elegant bottom navigation bar for Flutter featuring outline icons, an active baby-pink indicator dot directly beneath the selected icon, a straight full-width bar flush with the bottom, and a playful fluid wave bounce dot animation.

---

## Visual Design

- **Straight Edge-to-Edge Layout**: Full-width white bar (`#FFFFFF`) with a straight top edge, delicate divider line (`#F1EAF3`), soft top shadow, and seamless native bottom safe-area fill (matching the clean docked structure of previous designs).
- **Active Indicator Dot**: Circular baby-pink dot (`#EC3E8D`, `6.0 px` diameter) placed directly beneath the selected icon at rest.
- **Wave Bounce Animation**: The dot leaps upward like an organic fluid wave crest while traveling between tabs, soaring smoothly to peak height midway and settling with a gentle landing cushion under the target icon.
- **In-Place Bounce**: Tapping the currently active tab triggers a subtle, playful in-place hop wave.
- **Active Icon**: Highlighted in vivid baby pink (`#EC3E8D`) with filled icon variants (e.g. `Icons.favorite_rounded`).
- **Inactive Icons**: Muted outline gray (`#858087`, `24 px`).
- **Touch Targets**: Accessible touch targets (minimum `44 × 44` logical pixels) with full screen-reader semantics.

---

## File Structure

```
designs/design_07/
├── dot_indicator_nav_item.dart    # Tab item model with icons and accessibility labels
├── dot_indicator_navigation.dart  # Reusable dot indicator navigation component
├── design_07_preview.dart         # Standalone mobile preview screen
└── README.md                      # Documentation and usage guide
```

---

## Usage

```dart
import 'designs/design_07/dot_indicator_navigation.dart';

DotIndicatorNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) {
    setState(() => _selectedIndex = index);
  },
);
```

---

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `currentIndex` | `int` | `0` | Active tab index (0–4) |
| `onTap` | `ValueChanged<int>?` | `null` | Tab tap callback |
| `items` | `List<DotIndicatorNavItem>` | 5 default items | Navigation tab models |
| `backgroundColor` | `Color` | `#FFFFFF` | Background color of the navbar |
| `activeColor` | `Color` | `#EC3E8D` | Color of the active icon and wave dot |
| `inactiveColor` | `Color` | `#858087` | Color of inactive outline icons |
| `dotDiameter` | `double` | `6.0` | Diameter of the active indicator dot |
| `iconSize` | `double` | `24.0` | Size of navigation icons |
| `barHeight` | `double` | `64.0` | Height of the navigation strip |
| `cornerRadius` | `double` | `0.0` | Straight top edge (or top corners) |
| `horizontalMargin` | `double` | `0.0` | Flush edge-to-edge width |
| `waveBounceHeight` | `double` | `14.0` | Vertical peak rise of the wave arc |
| `animationDuration` | `Duration` | `320 ms` | Duration of the wave bounce transition |
| `animationCurve` | `Curve` | `Curves.easeInOutCubic` | Interpolation curve for smooth motion |
| `useSafeArea` | `bool` | `true` | Extends white background into safe area |

