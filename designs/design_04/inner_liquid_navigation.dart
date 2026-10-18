import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'inner_liquid_nav_item.dart';

/// A custom fluid easing curve providing a smooth ease-in-out transit
/// with a gentle, elastic settling bounce at the destination.
class GooeyPositionCurve extends Curve {
  const GooeyPositionCurve();

  @override
  double transformInternal(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    if (t < 0.78) {
      // Fluid ease-in-out flight phase (0.0 to 0.78) -> reaches ~0.985
      final flightT = t / 0.78;
      final cubic = flightT < 0.5
          ? 4.0 * flightT * flightT * flightT
          : 1.0 - math.pow(-2.0 * flightT + 2.0, 3.0) / 2.0;
      return cubic * 0.985;
    } else {
      // Elastic landing & settle phase (0.78 to 1.0)
      final settleT = (t - 0.78) / 0.22;
      // Damped sine wave gives a gentle 1.8% overshoot then settles to 1.0
      final overshoot = math.sin(settleT * math.pi) * 0.018;
      return 0.985 + (0.015 * settleT) + overshoot;
    }
  }
}

/// Design 04: Circle with Gooey Liquid Wave Animation Bottom Navigation Bar.
///
/// Features:
/// - White bottom navigation bar spanning full width with rounded bottom corners (28 px radius).
/// - Symmetrical U-shaped pocket curved into the white bar's top boundary.
/// - Pink floating circular button elevated above the bar's top edge.
/// - Genuine gooey liquid/blob animation when switching tabs:
///   * Stretches horizontally into a soft, organic oval during flight.
///   * Compresses (squashes) and bounces gently on arrival at destination.
///   * Settles cleanly into a perfect circle at rest.
/// - White navigation bar's inner pocket continuously morphs in 100% synchrony:
///   * Dynamically widens and flattens during mid-flight stretch.
///   * Narrows and deepens on landing impact to cradle the squashed blob.
/// - Inactive icons in gray with distance-based organic fade when passed over.
/// - Full accessibility semantics and touch target compliance (>= 48x48 px).
class InnerLiquidNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final List<InnerLiquidNavItem> items;
  final Color backgroundColor;
  final Color activeCircleColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color circleShadowColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final double barHeight;
  final double barTop;
  final double circleDiameter;
  final double notchGap;
  final double maxMobileWidth;
  final bool useSafeArea;

  const InnerLiquidNavigationBar({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.items = InnerLiquidNavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeCircleColor = const Color(0xFFEC3E8D),
    this.activeIconColor = const Color(0xFFFFFFFF),
    this.inactiveIconColor = const Color(0xFF858087),
    this.circleShadowColor = const Color(0x66EC3E8D),
    this.animationDuration = const Duration(milliseconds: 520),
    this.animationCurve = const GooeyPositionCurve(),
    this.barHeight = 76.0,
    this.barTop = 28.0,
    this.circleDiameter = 74.0,
    this.notchGap = 8.0,
    this.maxMobileWidth = double.infinity,
    this.useSafeArea = true,
  }) : assert(items.length > 0, 'Items list cannot be empty');

  static const double iconSize = 26.0;

  @override
  State<InnerLiquidNavigationBar> createState() =>
      _InnerLiquidNavigationBarState();
}

class _InnerLiquidNavigationBarState extends State<InnerLiquidNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;

  // Stored pixel coordinates for interruption-free smooth retargeting
  double? _fromX;
  double? _targetX;
  double _lastAnimatedX = 0.0;
  double _lastTabWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex.clamp(0, widget.items.length - 1);

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
  void didUpdateWidget(covariant InnerLiquidNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _currentIndex) {
      final newIndex = widget.selectedIndex.clamp(0, widget.items.length - 1);
      _animateTo(newIndex);
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

  void _animateTo(int targetIndex) {
    if (targetIndex == _currentIndex && _controller.isCompleted) return;

    setState(() {
      if (_lastTabWidth > 0) {
        // Pick up smoothly from wherever the blob currently is
        _fromX = _lastAnimatedX;
        _targetX = (targetIndex + 0.5) * _lastTabWidth;
      }
      _currentIndex = targetIndex;
    });

    _controller.forward(from: 0.0);
  }

  void _handleTabTap(int index) {
    if (index >= 0 && index < widget.items.length) {
      widget.onItemSelected?.call(index);
      _animateTo(index);
    }
  }

  /// Calculates the physical gooey stretch factor during transit and landing.
  /// Positive values = horizontal stretch (oval).
  /// Negative values = vertical squash / impact bounce.
  double _calculateGooeyStretch(double t) {
    if (t <= 0.0 || t >= 1.0) return 0.0;
    if (t < 0.68) {
      // Flight phase: smooth bell curve peaking around mid-flight
      final flightT = t / 0.68;
      return math.sin(flightT * math.pi);
    } else {
      // Landing impact compression and subtle jelly rebound
      final bounceT = (t - 0.68) / 0.32;
      final decay = 1.0 - bounceT;
      return -0.42 * math.sin(bounceT * math.pi * 2.0) * decay;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final bottomInset =
        widget.useSafeArea ? (mediaQuery?.padding.bottom ?? 0.0) : 0.0;
    final totalWidgetHeight = widget.barTop + widget.barHeight + bottomInset;

    Widget barContent = SizedBox(
      height: totalWidgetHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final tabCount = widget.items.length;
          final tabWidth = w / tabCount;
          _lastTabWidth = tabWidth;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final rawProgress = _controller.value;
              final curvedProgress = _animation.value;
              final isMoving = _controller.isAnimating;

              final currentTargetX = (widget.items.length > _currentIndex)
                  ? (_currentIndex + 0.5) * tabWidth
                  : tabWidth * 0.5;
              final startX = _fromX ?? currentTargetX;
              final endX = _targetX ?? currentTargetX;

              final animatedX = _fromX == null || startX == endX
                  ? endX
                  : Tween<double>(begin: startX, end: endX)
                      .transform(curvedProgress);
              _lastAnimatedX = animatedX;

              // Gooey physics calculations:
              final travelDist = (endX - startX).abs();
              final distFactor =
                  (travelDist / (tabWidth * 1.5)).clamp(0.65, 1.4);
              final maxStretch = 0.32 * distFactor;

              final rawStretch =
                  isMoving ? _calculateGooeyStretch(rawProgress) : 0.0;
              final sx = (1.0 + rawStretch * maxStretch).clamp(0.75, 1.50);
              final sy = (1.0 / math.sqrt(sx)).clamp(0.75, 1.30);

              const circleCenterY = 6.0 + 74.0 / 2.0; // 43.0
              final blobWidth = widget.circleDiameter * sx;
              final blobHeight = widget.circleDiameter * sy;
              final blobLeft = animatedX - blobWidth / 2.0;
              final blobTop = circleCenterY - blobHeight / 2.0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // =======================================================
                  // LAYER 1: Full-Width White Bar Surface with Morphing Wave Pocket
                  // =======================================================
                  Positioned.fill(
                    child: CustomPaint(
                      size: Size(w, totalWidgetHeight),
                      painter: InnerLiquidWavePainter(
                        notchX: animatedX,
                        scaleX: sx,
                        scaleY: sy,
                        barTop: widget.barTop,
                        barHeight: widget.barHeight,
                        bottomInset: bottomInset,
                        circleDiameter: widget.circleDiameter,
                        notchGap: widget.notchGap,
                        backgroundColor: widget.backgroundColor,
                        shadowColor: const Color(0x0F000000),
                      ),
                    ),
                  ),

                  // =======================================================
                  // LAYER 2: Inactive Tab Icons & Tap Targets
                  // =======================================================
                  Positioned(
                    top: widget.barTop,
                    left: 0,
                    right: 0,
                    height: widget.barHeight,
                    child: Row(
                      children: List.generate(tabCount, (index) {
                        final item = widget.items[index];
                        final isSelected = index == _currentIndex;

                        // Fluid distance-based opacity: automatically fades out
                        // when the gooey blob is directly over this tab
                        final distToBlob =
                            (animatedX - (index + 0.5) * tabWidth).abs();
                        final fadeThreshold = blobWidth * 0.65;
                        final opacity =
                            (distToBlob / fadeThreshold).clamp(0.0, 1.0);

                        return Expanded(
                          child: Semantics(
                            button: true,
                            selected: isSelected,
                            label: item.tooltip ?? item.label,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _handleTabTap(index),
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
                                  child: opacity <= 0.0
                                      ? const SizedBox(
                                          width: InnerLiquidNavigationBar.iconSize,
                                          height:
                                              InnerLiquidNavigationBar.iconSize,
                                        )
                                      : Opacity(
                                          opacity: opacity,
                                          child: Icon(
                                            item.inactiveIcon,
                                            size:
                                                InnerLiquidNavigationBar.iconSize,
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
                  // LAYER 3: Elevated Pink Gooey Floating Blob with White Icon
                  // =======================================================
                  Positioned(
                    left: blobLeft,
                    top: blobTop,
                    width: blobWidth,
                    height: blobHeight,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.activeCircleColor,
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(
                              blobWidth / 2.0,
                              blobHeight / 2.0,
                            ),
                          ),
                          boxShadow: [
                            // Soft ambient baby-pink glow surrounding the circle
                            BoxShadow(
                              color: const Color(0xFFEC3E8D).withValues(alpha: 0.28),
                              blurRadius: 18.0,
                              spreadRadius: 2.0,
                              offset: const Offset(0, 2),
                            ),
                            // Concentrated downward soft pink shadow cradled inside the pocket
                            BoxShadow(
                              color: const Color(0xFFEC3E8D).withValues(alpha: 0.42),
                              blurRadius: 14.0,
                              spreadRadius: 0.0,
                              offset: const Offset(0, 7.5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
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

/// CustomPainter that renders a white bottom navigation bar with:
/// - A horizontal top edge.
/// - Rounded bottom corners (28 px radius) matching the mobile phone container.
/// - A smooth, organic U-shaped pocket that dynamically widens and morphs in 100%
///   synchrony with the gooey liquid blob.
/// - A subtle top-edge drop shadow.
class InnerLiquidWavePainter extends CustomPainter {
  /// The animated horizontal center of the active tab.
  final double notchX;

  /// Horizontal stretch scale of the gooey blob.
  final double scaleX;

  /// Vertical squash scale of the gooey blob.
  final double scaleY;

  /// Top coordinate where the white bar surface starts.
  final double barTop;

  /// Height of the white bar surface.
  final double barHeight;

  /// Safe-area bottom inset.
  final double bottomInset;

  /// Diameter of the floating active circle.
  final double circleDiameter;

  /// Visible clearance gap between the circle and the pocket boundary.
  final double notchGap;

  /// Solid surface fill color (pure white).
  final Color backgroundColor;

  /// Top-edge drop shadow color.
  final Color shadowColor;

  const InnerLiquidWavePainter({
    required this.notchX,
    required this.scaleX,
    required this.scaleY,
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

    // Conforming organic pocket dimensions matching gooey blob physics
    final circleRadiusX = (circleDiameter / 2.0) * scaleX;
    final circleRadiusY = (circleDiameter / 2.0) * scaleY;
    final pocketRadiusX = circleRadiusX + notchGap;
    final shoulderWidth = 14.0 + (scaleX - 1.0) * 8.0;
    final pocketHalfWidth = pocketRadiusX + shoulderWidth;

    final leftStart = notchX - pocketHalfWidth;
    final rightEnd = notchX + pocketHalfWidth;
    final nadirY = barTop + circleRadiusY + notchGap + 12.0;

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
      notchX - pocketRadiusX * 0.72,
      nadirY,
      notchX,
      nadirY,
    );

    // Right shoulder curving smoothly up from nadir to barTop
    path.cubicTo(
      notchX + pocketRadiusX * 0.72,
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
  bool shouldRepaint(covariant InnerLiquidWavePainter oldDelegate) {
    return oldDelegate.notchX != notchX ||
        oldDelegate.scaleX != scaleX ||
        oldDelegate.scaleY != scaleY ||
        oldDelegate.barTop != barTop ||
        oldDelegate.barHeight != barHeight ||
        oldDelegate.bottomInset != bottomInset ||
        oldDelegate.circleDiameter != circleDiameter ||
        oldDelegate.notchGap != notchGap ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}
