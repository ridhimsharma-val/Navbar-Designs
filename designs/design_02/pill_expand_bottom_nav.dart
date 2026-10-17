import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'pill_nav_item.dart';

/// Design 02: Pill-Expand Bottom Navigation Bar.
///
/// Features:
/// - Perfectly straight, horizontal top edge with subtle drop shadow,
///   following the clean docked surface treatment of Design 01.
/// - Full-width white navigation surface (`#FFFFFF`) extending across the bottom.
/// - Selected item expands smoothly into a soft baby-pink capsule pill (`#FCE7EF`)
///   revealing a vibrant filled icon (`#EC3E8D`) and crisp label (`#EC3E8D`).
/// - Inactive items display clean outline icons (`#858087`) vertically centered
///   with no visible text labels.
/// - Smooth horizontal expansion/contraction transitions (300 ms, `Curves.easeInOutCubic`).
/// - Guaranteed accessible tap targets (>= 48 x 48 logical pixels per item).
/// - Non-destructive safe-area handling for system home indicators.
class PillExpandBottomNav extends StatelessWidget {
  /// Index of the currently selected tab (0-indexed).
  final int selectedIndex;

  /// Callback fired when the user taps a tab item.
  final ValueChanged<int> onItemSelected;

  /// The list of navigation items (defaults to standard 4: Home, Wallet, Analytics, Settings).
  final List<PillNavItem> items;

  /// Background color of the navigation bar.
  final Color backgroundColor;

  /// Background color of the selected expanded pill capsule.
  final Color activeBackgroundColor;

  /// Color of the active icon inside the pill.
  final Color activeIconColor;

  /// Color of the active text label inside the pill.
  final Color activeLabelColor;

  /// Color of inactive outline icons.
  final Color inactiveIconColor;

  /// Soft shadow color along the straight top edge.
  final Color shadowColor;

  /// Duration of the pill expand/contract animation.
  final Duration animationDuration;

  /// Curve of the pill expand/contract animation.
  final Curve animationCurve;

  /// Main height of the white navigation container (excluding bottom safe area).
  final double barHeight;

  /// Height of the active expanded pill capsule.
  final double pillHeight;

  /// Horizontal padding for the tab items inside the navigation bar.
  final double horizontalPadding;

  /// Outer horizontal margin from the screen edges (0.0 for docked edge-to-edge bar).
  final double horizontalMargin;

  /// Outer bottom margin from the screen bottom (0.0 for docked bar).
  final double bottomMargin;

  /// Corner radius of the white navigation container (0.0 for straight-top edge).
  final double cornerRadius;

  /// Maximum width constraint for desktop/wide displays.
  final double maxMobileWidth;

  /// Whether to automatically account for the bottom safe-area inset.
  final bool useSafeArea;

  const PillExpandBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.items = PillNavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeBackgroundColor = const Color(0xFFFCE7EF),
    this.activeIconColor = const Color(0xFFEC3E8D),
    this.activeLabelColor = const Color(0xFFEC3E8D),
    this.inactiveIconColor = const Color(0xFF858087),
    this.shadowColor = const Color(0x0C000000),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOutCubic,
    this.barHeight = 72.0,
    this.pillHeight = 50.0,
    this.horizontalPadding = 16.0,
    this.horizontalMargin = 0.0,
    this.bottomMargin = 0.0,
    this.cornerRadius = 0.0,
    this.maxMobileWidth = double.infinity,
    this.useSafeArea = true,
  }) : assert(items.length > 0, 'Items list cannot be empty');

  // Exact icon and typography specifications
  static const double iconSize = 24.0;
  static const double labelFontSize = 15.0;
  static const FontWeight labelFontWeight = FontWeight.w400;
  static const double labelLetterSpacing = 0.1;
  static const double iconToLabelGap = 8.0;
  static const double pillHorizontalPadding = 18.0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final bottomInset =
        (useSafeArea && mediaQuery != null) ? mediaQuery.padding.bottom : 0.0;

    final disableAnimations = mediaQuery?.disableAnimations ?? false;
    final effectiveDuration =
        disableAnimations ? Duration.zero : animationDuration;

    final clampedIndex = selectedIndex.clamp(0, items.length - 1);

    final effectiveBottomMargin =
        bottomInset > 0 ? math.max(0.0, bottomMargin) : bottomMargin;

    Widget navContainer = Container(
      height: barHeight + bottomInset,
      margin: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        bottom: effectiveBottomMargin,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            cornerRadius > 0 ? BorderRadius.circular(cornerRadius) : null,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10.0,
            spreadRadius: 0.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: bottomInset,
      ),
      alignment: Alignment.center,
      child: SizedBox(
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == clampedIndex;

            return _PillNavItemWidget(
              item: item,
              isSelected: isSelected,
              onTap: () => onItemSelected(index),
              animationDuration: effectiveDuration,
              animationCurve: animationCurve,
              pillHeight: pillHeight,
              activeBackgroundColor: activeBackgroundColor,
              activeIconColor: activeIconColor,
              activeLabelColor: activeLabelColor,
              inactiveIconColor: inactiveIconColor,
            );
          }),
        ),
      ),
    );

    if (maxMobileWidth.isFinite) {
      navContainer = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxMobileWidth),
        child: navContainer,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: navContainer,
    );
  }
}

/// Internal item widget that handles smooth expansion and contraction of the pill.
class _PillNavItemWidget extends StatelessWidget {
  final PillNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration animationDuration;
  final Curve animationCurve;
  final double pillHeight;
  final Color activeBackgroundColor;
  final Color activeIconColor;
  final Color activeLabelColor;
  final Color inactiveIconColor;

  const _PillNavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.animationDuration,
    required this.animationCurve,
    required this.pillHeight,
    required this.activeBackgroundColor,
    required this.activeIconColor,
    required this.activeLabelColor,
    required this.inactiveIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: item.tooltip ?? item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(pillHeight / 2),
          splashColor: activeIconColor.withValues(alpha: 0.12),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            height: pillHeight,
            padding: EdgeInsets.symmetric(
              horizontal:
                  isSelected ? PillExpandBottomNav.pillHorizontalPadding : 14.0,
            ),
            decoration: BoxDecoration(
              color: isSelected ? activeBackgroundColor : Colors.transparent,
              borderRadius: BorderRadius.circular(pillHeight / 2),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon (smoothly switches between outline gray and filled pink)
                AnimatedSwitcher(
                  duration: animationDuration,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Icon(
                    isSelected ? item.activeIcon : item.inactiveIcon,
                    key: ValueKey<bool>(isSelected),
                    size: PillExpandBottomNav.iconSize,
                    color: isSelected ? activeIconColor : inactiveIconColor,
                  ),
                ),

                // Label (smoothly expands and fades in on selection)
                ClipRect(
                  child: AnimatedAlign(
                    duration: animationDuration,
                    curve: animationCurve,
                    alignment: Alignment.centerLeft,
                    widthFactor: isSelected ? 1.0 : 0.0,
                    child: AnimatedOpacity(
                      duration: animationDuration,
                      curve: animationCurve,
                      opacity: isSelected ? 1.0 : 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: PillExpandBottomNav.iconToLabelGap,
                        ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: PillExpandBottomNav.labelFontSize,
                            fontWeight: PillExpandBottomNav.labelFontWeight,
                            color: activeLabelColor,
                            letterSpacing:
                                PillExpandBottomNav.labelLetterSpacing,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
