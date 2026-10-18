import 'package:flutter/material.dart';

/// Represents a single tab item for Design 06: Liquid Float Navigation.
class LiquidFloatNavItem {
  final IconData icon;
  final String label;
  final String? tooltip;

  const LiquidFloatNavItem({
    required this.icon,
    required this.label,
    this.tooltip,
  });

  /// Default five navigation items matching the baby-pink/lavender theme.
  static const List<LiquidFloatNavItem> defaultItems = [
    LiquidFloatNavItem(
      icon: Icons.home_outlined,
      label: 'Home',
      tooltip: 'Home',
    ),
    LiquidFloatNavItem(
      icon: Icons.search_rounded,
      label: 'Search',
      tooltip: 'Search',
    ),
    LiquidFloatNavItem(
      icon: Icons.favorite_border_rounded,
      label: 'Likes',
      tooltip: 'Likes',
    ),
    LiquidFloatNavItem(
      icon: Icons.notifications_none_rounded,
      label: 'Notifications',
      tooltip: 'Notifications',
    ),
    LiquidFloatNavItem(
      icon: Icons.person_outline_rounded,
      label: 'Profile',
      tooltip: 'Profile',
    ),
  ];
}
