# Design 05: Top-Cutout Navigation Bar

A refined, minimalist bottom navigation design for Flutter featuring a completely straight horizontal navigation bar (not rounded) with a floating baby-pink circular indicator dot and subtle gooey bounce animation.

---

## 🌟 Key Features

- **Straight Navigation Bar**: The white container maintains a clean, straight edge across the bottom from left to right (not rounded), docked flush with the edges consistent with Designs 01–04.
- **Subtle Gooey Bounce Animation**:
  - Motion is driven by `SubtleGooeyBounceCurve` (cubic ease-out with a gentle cushion overshoot settling at 360 ms).
  - The floating pink dot features elastic gel deformation (subtle horizontal stretch during peak velocity, soft cushion squash on arrival, returning to a crisp circle).
- **Refined Visual Weights**:
  - Inactive tabs: Regular-weight typography (`FontWeight.w400`) and clean outlined icons in light muted gray (`#757575` icon, `#787878` label).
  - Selected tab: Accentuated in baby-pink (`#EC3E8D`) with `FontWeight.w600`.
- **Floating Selected Pink Dot**:
  - A small circular baby-pink dot ($\approx 11\text{ px}$, `#EC3E8D`) floats cleanly above the selected tab without cutting into or distorting the straight white bar.
  - Floats subtly above the top edge with an understated soft pink shadow.
  - Automatically glides horizontally across the straight bar when tabs are switched.
- **Accessible & Responsive**:
  - Minimum touch target: $\ge 44 \times 44\text{ px}$ per tab with full semantic labeling.
  - Adapts to any viewport width while preventing text clipping on compact devices.
  - Non-destructive safe-area handling for physical and gesture-navigation devices.

---

## 📐 Architecture & Shape Construction

```
   (0, 0) ┌────────────────────────────────────────────────────────────────┐ (w, 0)
          │                                                                │
          │    [Icon 0]      [Icon 1]      [Icon 2]      [Icon 3]      [Icon 4]    │
          │    [Label]       [Label]       [Label]       [Label]       [Label]     │
          │                                                                │
   (0, h) └────────────────────────────────────────────────────────────────┘ (w, h)
```

The notch is calculated using horizontal tangents ($C^1$ continuity):
- Tangent at `leftStart`: $0.0$
- Tangent at `notchX` (bottom of cutout): $0.0$
- Tangent at `rightEnd`: $0.0$

---

## 🚀 Usage

```dart
import 'package:flutter/material.dart';
import 'animations/design_05/top_cutout_navigation.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TopCutoutNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
```
