import 'package:flutter/material.dart';

/// Navigation item model for Design 04: Inner Wave Pocket Navigation.
class InnerLiquidNavItem {
  final String id;
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String? tooltip;

  const InnerLiquidNavItem({
    required this.id,
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    this.tooltip,
  });

  /// The standard three navigation items for Design 04:
  /// 1. Home (Icons.home_rounded / Icons.home_outlined)
  /// 2. Plus (Icons.add_rounded for both states)
  /// 3. Profile (Icons.person_rounded / Icons.person_outline_rounded)
  static const List<InnerLiquidNavItem> defaultItems = [
    InnerLiquidNavItem(
      id: 'home',
      label: 'Home',
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      tooltip: 'Home',
    ),
    InnerLiquidNavItem(
      id: 'plus',
      label: 'Plus',
      activeIcon: Icons.add_rounded,
      inactiveIcon: Icons.add_rounded,
      tooltip: 'Plus',
    ),
    InnerLiquidNavItem(
      id: 'profile',
      label: 'Profile',
      activeIcon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      tooltip: 'Profile',
    ),
  ];
}
