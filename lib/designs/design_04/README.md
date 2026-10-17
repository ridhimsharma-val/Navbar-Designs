# Design 04: Inner Wave Pocket Navigation

A soft, floating white navigation bar with an upward-flowing baby-pink inner wave pocket that cradles the active icon.

## Features

- **White Floating Surface:** Straight horizontal top edge with rounded bottom corners ($28\text{ px}$) and soft shadow.
- **Inner Wave Pocket:** Symmetrical upward curve around the active icon filled with baby-pink (`#FCE7EF`).
- **Active Icon & Label:** Active icon rises slightly into the pocket; light typography label (`FontWeight.w400`, $15\text{ px}$) appears beneath in `#EC3E8D`.
- **Three Core Tabs:** Exactly three evenly distributed items: **Home**, **Plus**, and **Profile**.
- **Dynamic Fluid Morphing:** Smooth horizontal transit ($350\text{--}450\text{ ms}$) with asymmetric fluid drag.
- **Safe Area Support:** Full system inset handling without hardcoded offsets.

## Usage

```dart
InnerLiquidNavigationBar(
  selectedIndex: _selectedIndex,
  onItemSelected: (index) {
    setState(() => _selectedIndex = index);
  },
)
```
