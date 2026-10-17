import 'package:flutter/material.dart';

/// Data model representing a navigation item for Design 03:
/// Liquid Wave Navigation.
///
/// Encapsulates the label, inactive outline icon, active filled icon,
/// and an optional accessibility tooltip.
@immutable
class LiquidNavItem {
  /// The text label displayed when the tab is selected.
  final String label;

  /// Icon displayed in the inactive (unselected) state (outline variant).
  final IconData inactiveIcon;

  /// Icon displayed in the active (selected) state (filled variant).
  final IconData activeIcon;

  /// Optional accessibility tooltip or semantic label.
  /// Defaults to [label] if not provided.
  final String? tooltip;

  const LiquidNavItem({
    required this.label,
    required this.inactiveIcon,
    required this.activeIcon,
    this.tooltip,
  });

  /// The standard 3 navigation items specified for Design 03:
  /// 1. Home: [Icons.home_outlined] -> [Icons.home_rounded]
  /// 2. Plus: [Icons.add_rounded] -> [Icons.add_rounded]
  /// 3. Profile: [Icons.person_outline_rounded] -> [Icons.person_rounded]
  static const List<LiquidNavItem> defaultItems = [
    LiquidNavItem(
      label: 'Home',
      inactiveIcon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    LiquidNavItem(
      label: 'Plus',
      inactiveIcon: Icons.add_rounded,
      activeIcon: Icons.add_rounded,
    ),
    LiquidNavItem(
      label: 'Profile',
      inactiveIcon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiquidNavItem &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          inactiveIcon == other.inactiveIcon &&
          activeIcon == other.activeIcon &&
          tooltip == other.tooltip;

  @override
  int get hashCode =>
      label.hashCode ^
      inactiveIcon.hashCode ^
      activeIcon.hashCode ^
      tooltip.hashCode;
}
