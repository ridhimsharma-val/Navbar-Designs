import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'nav_item.dart';

/// Custom painter that draws a full-width white navigation surface featuring
/// a straight horizontal top edge with a smooth concave circular cutout (notch)
/// dipping symmetrically around the floating active circle.
class FullWidthNotchedSurfacePainter extends CustomPainter {
  /// The animated horizontal center of the active tab.
  final double notchX;

  /// Top coordinate where the straight horizontal surface begins.
  final double barTop;

  /// Height of the white navigation bar (excluding bottom safe area).
  final double barHeight;

  /// Height of the device's bottom safe-area inset (extends white fill to screen bottom).
  final double bottomInset;

  /// Diameter of the floating active circle.
  final double circleDiameter;

  /// Vertical protrusion of the circle above [barTop].
  final double protrusion;

  /// Visible clearance gap between the circle and the concave cutout.
  final double notchGap;

  /// Solid surface fill color (pure white).
  final Color backgroundColor;

  /// Soft shadow color along the top boundary.
  final Color shadowColor;

  const FullWidthNotchedSurfacePainter({
    required this.notchX,
    required this.barTop,
    required this.barHeight,
    required this.bottomInset,
    required this.circleDiameter,
    required this.protrusion,
    required this.notchGap,
    required this.backgroundColor,
    required this.shadowColor,
  });

  /// Constructs the path with a straight top edge and smooth concave scooped notch.
  Path buildNotchedPath(Size size) {
    final w = size.width;
    final totalBottom = barTop + barHeight + bottomInset;

    final circleRadius = circleDiameter / 2; // e.g. 39.0
    final notchRadius = circleRadius + notchGap; // e.g. 44.0
    final circleCenterY =
        barTop + circleRadius - protrusion; // e.g. barTop + 13.0

    // Arc half-angle from vertical (approx 58 degrees)
    const arcHalfAngle = 1.02;
    final leftArcX = notchX - notchRadius * math.sin(arcHalfAngle);
    final leftArcY = circleCenterY + notchRadius * math.cos(arcHalfAngle);
    final rightArcX = notchX + notchRadius * math.sin(arcHalfAngle);
    final rightArcY = circleCenterY + notchRadius * math.cos(arcHalfAngle);

    // S-curve shoulder blend width
    const shoulderWidth = 10.0;
    final shoulderStartX = leftArcX - shoulderWidth;
    final shoulderEndX = rightArcX + shoulderWidth;

    final path = Path();

    // 1. Start at top-left corner (0, barTop)
    path.moveTo(0, barTop);

    // 2. Straight horizontal top edge up to the start of the notch shoulder
    if (shoulderStartX > 0) {
      path.lineTo(shoulderStartX, barTop);
    }

    // 3. Left smooth S-curve shoulder dipping into the circular arc
    path.cubicTo(
      shoulderStartX + shoulderWidth * 0.45,
      barTop,
      leftArcX - shoulderWidth * 0.2,
      leftArcY - 2.0,
      leftArcX,
      leftArcY,
    );

    // 4. Exact circular arc curving smoothly around the bottom of the circle
    path.arcToPoint(
      Offset(rightArcX, rightArcY),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // 5. Right smooth S-curve shoulder returning to the straight top edge
    path.cubicTo(
      rightArcX + shoulderWidth * 0.2,
      rightArcY - 2.0,
      shoulderEndX - shoulderWidth * 0.45,
      barTop,
      shoulderEndX,
      barTop,
    );

    // 6. Straight horizontal top edge to the top-right corner (w, barTop)
    if (shoulderEndX < w) {
      path.lineTo(w, barTop);
    }

    // 7. Right edge down to bottom of the screen (including safe area)
    path.lineTo(w, totalBottom);

    // 8. Straight bottom edge to bottom-left corner
    path.lineTo(0, totalBottom);

    // 9. Left edge back up to (0, barTop)
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final totalBottom = barTop + barHeight + bottomInset;

    // Clip strictly to canvas bounds to eliminate any subpixel edge artifacts or slivers
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, w, totalBottom));

    final path = buildNotchedPath(size);

    // Layer 1: Extremely light top-edge shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.save();
    canvas.translate(0, -2.0);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Layer 2: Crisp white full-width surface fill
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FullWidthNotchedSurfacePainter oldDelegate) {
    return oldDelegate.notchX != notchX ||
        oldDelegate.barTop != barTop ||
        oldDelegate.barHeight != barHeight ||
        oldDelegate.bottomInset != bottomInset ||
        oldDelegate.circleDiameter != circleDiameter ||
        oldDelegate.protrusion != protrusion ||
        oldDelegate.notchGap != notchGap ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}

/// Design 01: Refined Minimal Floating Circle Bottom Navigation Bar.
///
/// Features:
/// - Full-width white navigation strip with a perfectly straight horizontal top edge.
/// - No text labels; pure icon-driven minimalist aesthetic with full accessibility semantics.
/// - Raised circular active indicator ($78\text{ px}$ diameter) protruding upward by $\approx 26\text{ px}$.
/// - Symmetrical concave scooped cutout around the lower half of the circle.
/// - Constant concentric cutout gap revealing the light lavender-pink page background (`#F0ECF6`).
/// - Vibrant pink active icon (`#EC3E8D`) and muted gray inactive outline icons (`#858087`).
/// - Synchronized horizontal glide between floating circle and concave scoop (300 ms, `Curves.easeInOutCubic`).
/// - Seamless full-width screen integration and non-destructive safe-area handling.
class MinimalCircleBottomNav extends StatelessWidget {
  /// Index of the currently active tab (0-indexed).
  final int selectedIndex;

  /// Callback fired when the user selects a tab.
  final ValueChanged<int> onItemSelected;

  /// The list of navigation items to display.
  final List<Design01NavItem> items;

  /// Background color of the navigation bar strip (pure white).
  final Color backgroundColor;

  /// Color of the active icon.
  final Color activeIconColor;

  /// Color of inactive icons.
  final Color inactiveIconColor;

  /// Shadow color for the active white circular highlight.
  final Color circleShadowColor;

  /// Subtle shadow color along the straight top edge of the surface.
  final Color topEdgeShadowColor;

  /// Duration of the selection transition animation.
  final Duration animationDuration;

  /// Curve of the selection transition animation.
  final Curve animationCurve;

  /// Height of the main navigation strip (excluding protrusion and bottom safe area).
  final double barHeight;

  /// Visible protrusion of the floating circle above the straight top edge.
  final double protrusionHeight;

  /// Clearance gap between the active circle and the concave cutout scoop.
  final double notchGap;

  /// Horizontal padding for the tab items row, ensuring edge tabs have comfortable breathing room.
  final double horizontalPadding;

  /// Maximum width constraint for the navigation bar (defaults to infinity for edge-to-edge).
  final double maxMobileWidth;

  /// Whether to automatically extend the white background behind the bottom safe area.
  final bool useSafeArea;

  const MinimalCircleBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.items = Design01NavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeIconColor = const Color(0xFFEC3E8D),
    this.inactiveIconColor = const Color(0xFF858087),
    this.circleShadowColor = const Color(0x1C7A6882),
    this.topEdgeShadowColor = const Color(0x0A000000),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOutCubic,
    this.barHeight = 68.0,
    this.protrusionHeight = 24.0,
    this.notchGap = 5.0,
    this.horizontalPadding = 16.0,
    this.maxMobileWidth = double.infinity,
    this.useSafeArea = true,
  }) : assert(items.length > 0, 'Items list cannot be empty');

  // Exact specification constants
  static const double iconSize = 24.0;
  static const double circleDiameter = 76.0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final bottomInset =
        (useSafeArea && mediaQuery != null) ? mediaQuery.padding.bottom : 0.0;

    final disableAnimations = mediaQuery?.disableAnimations ?? false;
    final effectiveDuration =
        disableAnimations ? Duration.zero : animationDuration;

    final clampedIndex = selectedIndex.clamp(0, items.length - 1);

    // Sizing and vertical calculations:
    final totalHeight = protrusionHeight + barHeight + bottomInset;
    const circleRadius = circleDiameter / 2; // 38.0

    // The circle top sits at Y = 0.0 so it protrudes by protrusionHeight (24px) above barTop
    const circleTop = 0.0;

    Widget barContent = SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final contentWidth =
              math.max(0.0, totalWidth - (horizontalPadding * 2));
          final tabWidth = contentWidth / items.length;
          final targetX = horizontalPadding + (clampedIndex + 0.5) * tabWidth;

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: targetX),
            duration: effectiveDuration,
            curve: animationCurve,
            builder: (context, animatedX, child) {
              final circleLeft = animatedX - circleRadius;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // =======================================================
                  // LAYER 1: Full-Width White Surface with Concave Cutout
                  // =======================================================
                  Positioned.fill(
                    child: CustomPaint(
                      painter: FullWidthNotchedSurfacePainter(
                        notchX: animatedX,
                        barTop: protrusionHeight,
                        barHeight: barHeight,
                        bottomInset: bottomInset,
                        circleDiameter: circleDiameter,
                        protrusion: protrusionHeight,
                        notchGap: notchGap,
                        backgroundColor: backgroundColor,
                        shadowColor: topEdgeShadowColor,
                      ),
                    ),
                  ),

                  // =======================================================
                  // LAYER 2: Floating Active White Circle with Soft Shadow
                  // =======================================================
                  Positioned(
                    left: circleLeft,
                    top: circleTop,
                    width: circleDiameter,
                    height: circleDiameter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: circleShadowColor,
                            blurRadius: 10.0,
                            spreadRadius: 0.5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: effectiveDuration,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: items[clampedIndex].buildActiveWidget(
                          context,
                          key: ValueKey<int>(clampedIndex),
                          size: iconSize,
                          color: activeIconColor,
                        ),
                      ),
                    ),
                  ),

                  // =======================================================
                  // LAYER 3: Inactive Icons & Accessible Tap Targets
                  // =======================================================
                  Positioned(
                    top: protrusionHeight,
                    left: horizontalPadding,
                    right: horizontalPadding,
                    height: barHeight,
                    child: Row(
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        final isSelected = index == clampedIndex;

                        return Expanded(
                          child: Semantics(
                            button: true,
                            selected: isSelected,
                            label: item.tooltip ?? item.label,
                            child: InkResponse(
                              onTap: () => onItemSelected(index),
                              highlightShape: BoxShape.circle,
                              radius: 36.0,
                              splashColor:
                                  activeIconColor.withValues(alpha: 0.12),
                              highlightColor: Colors.transparent,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 44.0,
                                  minHeight: 44.0,
                                ),
                                alignment: Alignment.center,
                                child: AnimatedOpacity(
                                  duration: effectiveDuration,
                                  opacity: isSelected ? 0.0 : 1.0,
                                  child: Icon(
                                    item.inactiveIcon,
                                    size: iconSize,
                                    color: inactiveIconColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );

    if (maxMobileWidth.isFinite) {
      barContent = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxMobileWidth),
        child: barContent,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: barContent,
    );
  }
}
