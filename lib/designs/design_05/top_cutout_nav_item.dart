import 'package:flutter/material.dart';

/// Navigation item model for Design 05: Top-Cutout Navigation Bar.
class TopCutoutNavItem {
  final String id;
  final String label;
  final IconData icon;
  final String? tooltip;

  const TopCutoutNavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.tooltip,
  });

  /// The standard five navigation items for Design 05:
  /// 1. Home — Icons.home_outlined
  /// 2. Search — Icons.search_rounded
  /// 3. Likes — Icons.favorite_border_rounded
  /// 4. Notifications — Icons.notifications_none_rounded
  /// 5. Profile — Icons.person_outline_rounded
  static const List<TopCutoutNavItem> defaultItems = [
    TopCutoutNavItem(
      id: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
      tooltip: 'Home',
    ),
    TopCutoutNavItem(
      id: 'search',
      label: 'Search',
      icon: Icons.search_rounded,
      tooltip: 'Search',
    ),
    TopCutoutNavItem(
      id: 'likes',
      label: 'Likes',
      icon: Icons.favorite_border_rounded,
      tooltip: 'Likes',
    ),
    TopCutoutNavItem(
      id: 'notifications',
      label: 'Notifications',
      icon: Icons.notifications_none_rounded,
      tooltip: 'Notifications',
    ),
    TopCutoutNavItem(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      tooltip: 'Profile',
    ),
  ];
}
