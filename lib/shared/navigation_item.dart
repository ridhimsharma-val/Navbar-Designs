import 'package:flutter/material.dart';

/// Immutable model representing an individual item within a bottom navigation bar.
///
/// Encapsulates icon data, active/inactive state variations, label text,
/// optional notification badges, and accessibility metadata.
@immutable
class NavigationItem {
  /// Standard icon displayed when this item is in the inactive (unselected) state.
  final IconData icon;

  /// Optional icon displayed when this item is active (selected).
  ///
  /// If null, [icon] is displayed for both active and inactive states.
  final IconData? selectedIcon;

  /// Short, single-line label for this item (standard typography: 10–12 px).
  final String label;

  /// Optional badge count. Only rendered when explicitly provided and > 0.
  final int? badgeCount;

  /// Optional flag to render a compact dot badge when no count is needed.
  /// Defaults to `false`.
  final bool showBadgeDot;

  /// Optional accessibility tooltip and semantic label.
  /// Falls back to [label] if not provided.
  final String? tooltip;

  const NavigationItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount,
    this.showBadgeDot = false,
    this.tooltip,
  });

  // ===========================================================================
  // Standard Specification Constants
  // ===========================================================================

  /// Baseline standard icon size (24.0 px) per specification.
  static const double standardIconSize = 24.0;

  /// Minimum label font size (10.0 px) per specification.
  static const double minLabelFontSize = 10.0;

  /// Maximum label font size (12.0 px) per specification.
  static const double maxLabelFontSize = 12.0;

  /// Default label font size (11.0 px) per specification.
  static const double defaultLabelFontSize = 11.0;

  /// Minimum recommended tap target size (44.0 x 44.0 px) for accessibility.
  static const double minTapTargetSize = 44.0;

  // ===========================================================================
  // Standard 5-Item Navigation Baseline
  // ===========================================================================

  /// The standard 5 baseline navigation items:
  /// - **Home**
  /// - **Search**
  /// - **Plus** (Create/Add)
  /// - **Messages**
  /// - **Profile**
  static const List<NavigationItem> standardItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    NavigationItem(
      icon: Icons.search_rounded,
      selectedIcon: Icons.search_rounded,
      label: 'Search',
    ),
    NavigationItem(
      icon: Icons.add_rounded,
      selectedIcon: Icons.add_circle_rounded,
      label: 'Plus',
    ),
    NavigationItem(
      icon: Icons.chat_bubble_outline_rounded,
      selectedIcon: Icons.chat_bubble_rounded,
      label: 'Messages',
    ),
    NavigationItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  /// Returns the effective icon to display based on the selection state.
  IconData getIcon({required bool isSelected}) {
    if (isSelected && selectedIcon != null) {
      return selectedIcon!;
    }
    return icon;
  }

  /// Creates a copy of this navigation item with optional field replacements.
  NavigationItem copyWith({
    IconData? icon,
    IconData? selectedIcon,
    String? label,
    int? badgeCount,
    bool? showBadgeDot,
    String? tooltip,
  }) {
    return NavigationItem(
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      label: label ?? this.label,
      badgeCount: badgeCount ?? this.badgeCount,
      showBadgeDot: showBadgeDot ?? this.showBadgeDot,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationItem &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          selectedIcon == other.selectedIcon &&
          label == other.label &&
          badgeCount == other.badgeCount &&
          showBadgeDot == other.showBadgeDot &&
          tooltip == other.tooltip;

  @override
  int get hashCode =>
      icon.hashCode ^
      selectedIcon.hashCode ^
      label.hashCode ^
      badgeCount.hashCode ^
      showBadgeDot.hashCode ^
      tooltip.hashCode;
}
