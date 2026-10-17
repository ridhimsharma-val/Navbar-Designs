import 'package:flutter/material.dart';

/// Standard color palette and design tokens for the bottom navigation library.
///
/// Baseline theme: **White & Baby Pink**.
///
/// Designed to be self-contained and modular so each navigation design can
/// either consume these standard defaults or accept custom color overrides
/// via widget constructor parameters.
class NavigationColors {
  NavigationColors._();

  // ===========================================================================
  // Baby Pink Palette & Active Accents
  // ===========================================================================

  /// Primary baby pink accent used for active icons, indicator pills, and
  /// highlighted text labels.
  static const Color primaryPink = Color(0xFFFF8DA1);

  /// Softer pastel baby pink used for subtle selection backgrounds, chips, and
  /// pill highlights.
  static const Color softPink = Color(0xFFFFD1DC);

  /// Ultra-light pastel pink tint for gentle container backgrounds, active tab
  /// backdrops, or hover/pressed ripples.
  static const Color lightPinkTint = Color(0xFFFFF0F3);

  /// Deeper rose-pink accent for notification badges or high-contrast active
  /// states.
  static const Color deepPink = Color(0xFFE91E63);

  // ===========================================================================
  // Neutral Surfaces & Inactive States
  // ===========================================================================

  /// Pure crisp white surface for navigation bar backgrounds.
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// Subtle muted off-white for background contrast, preview canvases, and
  /// elevated card backdrops.
  static const Color surfaceMuted = Color(0xFFF8F9FA);

  /// Standard inactive icon and label color. Balanced for readability without
  /// competing with the active tab.
  static const Color inactiveGrey = Color(0xFF8E8E93);

  /// Lighter grey for subtle icons, unselected outlines, or disabled states.
  static const Color lightGrey = Color(0xFFD1D1D6);

  // ===========================================================================
  // Visual Separation & Elevation Tokens
  // ===========================================================================

  /// Subtle top-border/divider color used to separate the navigation bar from
  /// the main screen content.
  static const Color borderSubtle = Color(0xFFEEEEEE);

  /// Soft shadow color for floating or elevated navigation bars (~5% opacity black).
  static const Color shadow = Color(0x0D000000);

  // ===========================================================================
  // Notification Badge Tokens
  // ===========================================================================

  /// Default notification badge background color.
  static const Color badgeBackground = Color(0xFFFF4D6D);

  /// Default notification badge text/dot color.
  static const Color badgeText = Color(0xFFFFFFFF);
}
