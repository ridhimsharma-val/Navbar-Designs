import 'package:flutter/material.dart';

/// Data model representing a navigation item for Design 02:
/// Pill-Expand Bottom Navigation Bar.
///
/// Encapsulates the label, inactive icon (outline), active icon (filled),
/// and an optional accessibility tooltip.
@immutable
class PillNavItem {
  /// The text label displayed inside the active capsule pill.
  final String label;

  /// Icon displayed in the inactive (unselected) state (outline variant).
  final IconData inactiveIcon;

  /// Icon displayed in the active (selected) state (filled variant).
  final IconData activeIcon;

  /// Optional accessibility tooltip or semantic label.
  /// Defaults to [label] if not provided.
  final String? tooltip;

  const PillNavItem({
    required this.label,
    required this.inactiveIcon,
    required this.activeIcon,
    this.tooltip,
  });

  /// The standard 4 navigation items specified for Design 02:
  /// 1. Home: [Icons.home_outlined] -> [Icons.home_rounded]
  /// 2. Wallet: [Icons.account_balance_wallet_outlined] -> [Icons.account_balance_wallet]
  /// 3. Analytics: [Icons.pie_chart_outline_rounded] -> [Icons.pie_chart_rounded]
  /// 4. Settings: [Icons.settings_outlined] -> [Icons.settings_rounded]
  static const List<PillNavItem> defaultItems = [
    PillNavItem(
      label: 'Home',
      inactiveIcon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    PillNavItem(
      label: 'Wallet',
      inactiveIcon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
    ),
    PillNavItem(
      label: 'Analytics',
      inactiveIcon: Icons.pie_chart_outline_rounded,
      activeIcon: Icons.pie_chart_rounded,
    ),
    PillNavItem(
      label: 'Settings',
      inactiveIcon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PillNavItem &&
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
