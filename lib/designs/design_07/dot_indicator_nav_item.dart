import 'package:flutter/material.dart';

/// Represents a single navigation tab item for Design 07: Dot Indicator Navigation.
class DotIndicatorNavItem {
  /// Primary outline icon used in the inactive state.
  final IconData icon;

  /// Optional filled or active variant icon used when the tab is selected.
  /// If null, [icon] will be displayed with active coloring.
  final IconData? activeIcon;

  /// Human-readable label for accessibility semantics and tooltips.
  final String label;

  /// Optional tooltip override for assistive technology.
  final String? tooltip;

  const DotIndicatorNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.tooltip,
  });

  /// Default five navigation items matching the baby-pink/lavender aesthetic.
  static const List<DotIndicatorNavItem> defaultItems = [
    DotIndicatorNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      tooltip: 'Home',
    ),
    DotIndicatorNavItem(
      icon: Icons.search_rounded,
      activeIcon: Icons.search_rounded,
      label: 'Search',
      tooltip: 'Search',
    ),
    DotIndicatorNavItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Likes',
      tooltip: 'Likes',
    ),
    DotIndicatorNavItem(
      icon: Icons.notifications_none_rounded,
      activeIcon: Icons.notifications_rounded,
      label: 'Notifications',
      tooltip: 'Notifications',
    ),
    DotIndicatorNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      tooltip: 'Profile',
    ),
  ];
}
