import 'package:flutter/material.dart';
import 'nav_item.dart';

/// Custom painter that draws a full-width white navigation bar surface featuring:
/// - A horizontal top edge.
/// - Rounded bottom corners (28 px radius) matching the mobile phone preview.
/// - A smooth, symmetrical U-shaped pocket dipping downward into the bar directly
///   beneath the floating pink circular button.
/// - A subtle top-edge drop shadow.
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

  /// Visible clearance gap between the circle and the pocket boundary.
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
    required this.notchGap,
    required this.backgroundColor,
    required this.shadowColor,
  });

  /// Constructs the path for the white bar with rounded bottom corners
  /// and a smooth symmetrical U-shaped pocket centered at [notchX].
  Path buildNotchedPath(Size size) {
    final w = size.width;
    final totalBottom = barTop + barHeight + bottomInset;

    final circleRadius = circleDiameter / 2.0;
    final pocketRadius = circleRadius + notchGap;
    const shoulderWidth = 14.0;
    final pocketHalfWidth = pocketRadius + shoulderWidth;

    final leftStart = notchX - pocketHalfWidth;
    final rightEnd = notchX + pocketHalfWidth;
    final nadirY = barTop + pocketRadius + 14.0;

    final path = Path();
    path.moveTo(0, barTop);

    // Straight top edge up to left shoulder
    if (leftStart > 0) {
      path.lineTo(leftStart, barTop);
    }

    // Symmetrical smooth U-shaped pocket:
    // Left shoulder curving smoothly down from barTop to nadir
    path.cubicTo(
      leftStart + shoulderWidth * 0.45,
      barTop,
      notchX - pocketRadius * 0.75,
      nadirY,
      notchX,
      nadirY,
    );

    // Right shoulder curving smoothly up from nadir to barTop
    path.cubicTo(
      notchX + pocketRadius * 0.75,
      nadirY,
      rightEnd - shoulderWidth * 0.45,
      barTop,
      rightEnd,
      barTop,
    );

    // Straight top edge to right edge of bar
    if (rightEnd < w) {
      path.lineTo(w, barTop);
    }

    // Right edge down with 28px rounded bottom corner
    path.lineTo(w, totalBottom - 28.0);
    path.arcToPoint(
      Offset(w - 28.0, totalBottom),
      radius: const Radius.circular(28.0),
    );

    // Bottom edge to 28px rounded bottom-left corner
    path.lineTo(28.0, totalBottom);
    path.arcToPoint(
      Offset(0, totalBottom - 28.0),
      radius: const Radius.circular(28.0),
    );

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final totalBottom = barTop + barHeight + bottomInset;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, w, totalBottom));

    final path = buildNotchedPath(size);

    // Subtle upward top shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawPath(path.shift(const Offset(0, -2.0)), shadowPaint);

    // Solid white bar surface
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
        oldDelegate.notchGap != notchGap ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}

/// Design 01: Circle Navigation with Smooth Wave Animation.
///
/// Features:
/// - White bottom navigation bar spanning full width with rounded bottom corners (28 px radius).
/// - Symmetrical U-shaped pocket curved into the white bar's top boundary.
/// - Pink floating circular button elevated above the bar's top edge.
/// - Selected icon displayed in crisp white inside the floating circle.
/// - Inactive icons displayed in gray directly within the white navigation bar.
/// - No visible text labels; clean icon-driven aesthetic.
/// - Fluid, synchronized wave animation moving the circle and pocket as one connected unit.
class MinimalCircleBottomNav extends StatefulWidget {
  /// Index of the currently active tab (0-indexed).
  final int selectedIndex;

  /// Callback fired when the user selects a tab.
  final ValueChanged<int> onItemSelected;

  /// The list of navigation items to display.
  final List<Design01NavItem> items;

  /// Background color of the navigation bar strip (pure white).
  final Color backgroundColor;

  /// Background color of the elevated active floating circle.
  final Color activeCircleColor;

  /// Color of the active icon inside the circle.
  final Color activeIconColor;

  /// Color of inactive icons in the white bar.
  final Color inactiveIconColor;

  /// Soft pink shadow beneath the floating circle.
  final Color circleShadowColor;

  /// Subtle shadow color along the top boundary of the surface.
  final Color topEdgeShadowColor;

  /// Duration of the wave transition animation.
  final Duration animationDuration;

  /// Curve of the wave transition animation.
  final Curve animationCurve;

  /// Height of the white navigation bar (excluding protrusion and bottom safe area).
  final double barHeight;

  /// Diameter of the floating active circle.
  final double circleDiameter;

  /// Visible protrusion of the floating circle above the straight top edge.
  final double protrusionHeight;

  /// Clearance gap between the active circle and the pocket boundary.
  final double notchGap;

  /// Maximum width constraint for the navigation bar.
  final double maxMobileWidth;

  /// Whether to automatically extend the white background behind the bottom safe area.
  final bool useSafeArea;

  const MinimalCircleBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.items = Design01NavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeCircleColor = const Color(0xFFEC3E8D),
    this.activeIconColor = const Color(0xFFFFFFFF),
    this.inactiveIconColor = const Color(0xFF858087),
    this.circleShadowColor = const Color(0x55EC3E8D),
    this.topEdgeShadowColor = const Color(0x0C000000),
    this.animationDuration = const Duration(milliseconds: 450),
    this.animationCurve = Curves.easeInOutCubic,
    this.barHeight = 72.0,
    this.circleDiameter = 72.0,
    this.protrusionHeight = 26.0,
    this.notchGap = 6.0,
    this.maxMobileWidth = double.infinity,
    this.useSafeArea = true,
  }) : assert(items.length > 0, 'Items list cannot be empty');

  static const double iconSize = 26.0;

  @override
  State<MinimalCircleBottomNav> createState() => _MinimalCircleBottomNavState();
}

class _MinimalCircleBottomNavState extends State<MinimalCircleBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex.clamp(0, widget.items.length - 1);
    _previousIndex = _currentIndex;

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant MinimalCircleBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _currentIndex) {
      final newIndex = widget.selectedIndex.clamp(0, widget.items.length - 1);
      _previousIndex = _currentIndex;
      _currentIndex = newIndex;
      _controller.forward(from: 0.0);
    }
    if (widget.animationDuration != oldWidget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final bottomInset = (widget.useSafeArea && mediaQuery != null)
        ? mediaQuery.padding.bottom
        : 0.0;

    final totalHeight =
        widget.protrusionHeight + widget.barHeight + bottomInset;
    final circleRadius = widget.circleDiameter / 2.0;
    const circleTop = 4.0;

    Widget barContent = SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          final tabCount = widget.items.length;
          final tabWidth = barWidth / tabCount;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final progress = _animation.value;
              final startX = (_previousIndex + 0.5) * tabWidth;
              final targetX = (_currentIndex + 0.5) * tabWidth;
              final animatedX = startX + (targetX - startX) * progress;
              final circleLeft = animatedX - circleRadius;

              final isMoving = _controller.isAnimating;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // =======================================================
                  // LAYER 1: Full-Width White Surface with Smooth U-Pocket
                  // =======================================================
                  Positioned.fill(
                    child: CustomPaint(
                      painter: FullWidthNotchedSurfacePainter(
                        notchX: animatedX,
                        barTop: widget.protrusionHeight,
                        barHeight: widget.barHeight,
                        bottomInset: bottomInset,
                        circleDiameter: widget.circleDiameter,
                        notchGap: widget.notchGap,
                        backgroundColor: widget.backgroundColor,
                        shadowColor: widget.topEdgeShadowColor,
                      ),
                    ),
                  ),

                  // =======================================================
                  // LAYER 2: Inactive Navigation Icons (Gray, No Labels)
                  // =======================================================
                  Positioned(
                    top: widget.protrusionHeight,
                    left: 0,
                    right: 0,
                    height: widget.barHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(tabCount, (index) {
                        final item = widget.items[index];
                        final isSelected = index == _currentIndex;

                        double opacity = 1.0;
                        if (_currentIndex == _previousIndex) {
                          opacity = isSelected ? 0.0 : 1.0;
                        } else if (index == _currentIndex) {
                          opacity = (1.0 - progress).clamp(0.0, 1.0);
                        } else if (index == _previousIndex) {
                          opacity = progress.clamp(0.0, 1.0);
                        }

                        return Expanded(
                          child: Semantics(
                            button: true,
                            selected: isSelected,
                            label: item.tooltip ?? item.label,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => widget.onItemSelected(index),
                                splashFactory: NoSplash.splashFactory,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 48.0,
                                    minHeight: 48.0,
                                  ),
                                  alignment: Alignment.center,
                                  child: (isSelected && !isMoving) || opacity <= 0.0
                                      ? const SizedBox(
                                          width: MinimalCircleBottomNav.iconSize,
                                          height:
                                              MinimalCircleBottomNav.iconSize,
                                        )
                                      : Opacity(
                                          opacity: opacity,
                                          child: Icon(
                                            item.inactiveIcon,
                                            size:
                                                MinimalCircleBottomNav.iconSize,
                                            color: widget.inactiveIconColor,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // =======================================================
                  // LAYER 3: Elevated Pink Floating Circle with White Icon
                  // =======================================================
                  Positioned(
                    left: circleLeft,
                    top: circleTop,
                    width: widget.circleDiameter,
                    height: widget.circleDiameter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.activeCircleColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.circleShadowColor,
                            blurRadius: isMoving ? 18.0 : 13.0,
                            spreadRadius: isMoving ? 1.5 : 0.5,
                            offset: Offset(0, isMoving ? 7.0 : 4.0),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: Icon(
                          widget.items[_currentIndex].activeIcon,
                          key: ValueKey<int>(_currentIndex),
                          size: 28.0,
                          color: widget.activeIconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );

    if (widget.maxMobileWidth.isFinite) {
      barContent = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxMobileWidth),
        child: barContent,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: barContent,
    );
  }
}
