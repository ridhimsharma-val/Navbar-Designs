import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'top_cutout_nav_item.dart';

/// A refined easing curve that glides smoothly across tabs and delivers
/// a noticeable yet restrained gooey cushion bounce (~6.5% overshoot) before settling cleanly.
class SubtleGooeyBounceCurve extends Curve {
  const SubtleGooeyBounceCurve();

  @override
  double transformInternal(double t) {
    if (t >= 1.0) return 1.0;
    if (t <= 0.0) return 0.0;

    // Smooth cubic ease-out
    final easeOut = 1.0 - math.pow(1.0 - t, 3.0);
    // Smooth sinusoidal cushion bounce reaching peak overshoot (~6.5%) around t ≈ 0.75
    // and gently easing to 0 at t = 1.0.
    final bounce = math.pow(math.sin(t * math.pi), 1.8) * math.pow(t, 1.8) * 0.22;

    return easeOut + bounce;
  }
}

/// Design 05: Top-Cutout Navigation Bar.
///
/// Features:
/// - Straight white navigation bar surface (`#FFFFFF`) with a smooth semi-circular cutout dipping at the active tab.
/// - Exactly five items: Home, Search, Likes, Notifications, Profile.
/// - Inactive items in light, regular-weight outlined gray (`#757575` icon, `#787878` label, `FontWeight.w400`).
/// - Active item highlighted in vibrant baby-pink (`#EC3E8D`, `FontWeight.w600`).
/// - Baby-pink circular ball nestled inside the semi-circular cutout.
/// - Synchronized gooey bouncy animation: ball stretches and cutout widens during transit,
///   followed by cushion squash bounce before settling cleanly (360 ms).
/// - Full accessibility semantics and responsive layout across any screen width.
class TopCutoutNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<TopCutoutNavItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color dotColor;
  final double dotDiameter;
  final double dotYOffset;
  final Color inactiveIconColor;
  final Color inactiveLabelColor;
  final Color shadowColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final double barHeight;
  final double cornerRadius;
  final double notchWidth;
  final double notchDepth;
  final double horizontalMargin;
  final double bottomMargin;
  final bool useSafeArea;

  const TopCutoutNavigationBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.items = TopCutoutNavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeColor = const Color(0xFFEC3E8D),
    Color? dotColor,
    this.dotDiameter = 11.0,
    this.dotYOffset = 7.0,
    this.inactiveIconColor = const Color(0xFF757575),
    this.inactiveLabelColor = const Color(0xFF787878),
    this.shadowColor = const Color(0x18000000),
    this.animationDuration = const Duration(milliseconds: 360),
    this.animationCurve = const SubtleGooeyBounceCurve(),
    this.barHeight = 104.0,
    this.cornerRadius = 0.0,
    this.notchWidth = 52.0,
    this.notchDepth = 20.0,
    this.horizontalMargin = 0.0,
    this.bottomMargin = 0.0,
    this.useSafeArea = true,
  }) : dotColor = dotColor ?? const Color(0xFFEC3E8D);

  static const double iconSize = 26.0;
  static const double labelFontSize = 12.0;

  @override
  State<TopCutoutNavigationBar> createState() => _TopCutoutNavigationBarState();
}

class _TopCutoutNavigationBarState extends State<TopCutoutNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;
  int _previousIndex = 0;

  // Track coordinates for interruption-free smooth retargeting
  double? _fromX;
  double? _targetX;
  double _lastAnimatedX = 0.0;
  double _lastTabWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex.clamp(0, widget.items.length - 1);
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
  void didUpdateWidget(covariant TopCutoutNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentIndex) {
      final newIndex = widget.currentIndex.clamp(0, widget.items.length - 1);
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
        _fromX = _lastAnimatedX;
        _targetX = (targetIndex + 0.5) * _lastTabWidth;
      }
      _previousIndex = _currentIndex;
      _currentIndex = targetIndex;
    });

    _controller.forward(from: 0.0);
  }

  void _handleTabTap(int index) {
    if (index >= 0 && index < widget.items.length) {
      widget.onTap?.call(index);
      _animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final bottomInset =
        widget.useSafeArea ? (mediaQuery?.padding.bottom ?? 0.0) : 0.0;
    final effectiveBottomMargin =
        bottomInset > 0 ? math.max(0.0, widget.bottomMargin) : widget.bottomMargin;

    return Padding(
      padding: EdgeInsets.only(
        left: widget.horizontalMargin,
        right: widget.horizontalMargin,
        bottom: effectiveBottomMargin,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          final tabCount = widget.items.length;
          final tabWidth = barWidth / tabCount;
          _lastTabWidth = tabWidth;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final progress = _animation.value;

              final currentTargetX = (tabCount > _currentIndex)
                  ? (_currentIndex + 0.5) * tabWidth
                  : tabWidth * 0.5;
              final startX = _fromX ?? currentTargetX;
              final endX = _targetX ?? currentTargetX;

              final animatedNotchX = _fromX == null || startX == endX
                  ? endX
                  : Tween<double>(begin: startX, end: endX).transform(progress);
              _lastAnimatedX = animatedNotchX;

              // Gel-like gooey stretch and squash deformation synchronized for cutout and ball
              double stretchX = 0.0;
              if (_controller.isAnimating && startX != endX) {
                final u = _controller.value;
                if (u < 0.65) {
                  // Phase 1: High-speed transit stretch along motion axis
                  stretchX = math.sin((u / 0.65) * math.pi) * 0.38;
                } else if (u < 0.92) {
                  // Phase 2: Deceleration cushion squash at the destination
                  final reboundU = (u - 0.65) / 0.27;
                  stretchX = -math.sin(reboundU * math.pi) * 0.20;
                } else {
                  // Phase 3: Settle cleanly to rest
                  stretchX = 0.0;
                }
              }

              final scaleX = (1.0 + stretchX).clamp(0.78, 1.45);
              final scaleY = (1.0 - stretchX * 0.55).clamp(0.75, 1.25);

              final currentNotchWidth =
                  widget.notchWidth * (1.0 + stretchX * 0.35);
              final currentNotchDepth =
                  widget.notchDepth * (1.0 - stretchX * 0.25);

              return SizedBox(
                width: barWidth,
                height: widget.barHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // =========================================================
                    // LAYER 1: Straight White Surface with Gooey Semi-Circular Cutout
                    // =========================================================
                    Positioned.fill(
                      child: CustomPaint(
                        painter: TopCutoutBarPainter(
                          notchX: animatedNotchX,
                          notchWidth: currentNotchWidth,
                          notchDepth: currentNotchDepth,
                          cornerRadius: widget.cornerRadius,
                          backgroundColor: widget.backgroundColor,
                          shadowColor: widget.shadowColor,
                          isDocked: widget.bottomMargin == 0.0,
                        ),
                      ),
                    ),

                    // =========================================================
                    // LAYER 2: Five Navigation Items with Smooth Color Transition
                    // =========================================================
                    Positioned.fill(
                      child: Row(
                        children: List.generate(tabCount, (index) {
                          final item = widget.items[index];
                          final isSelected = index == _currentIndex;

                          // Compute smooth color interpolation
                          final double colorProgress;
                          if (index == _currentIndex) {
                            colorProgress = progress.clamp(0.0, 1.0);
                          } else if (index == _previousIndex) {
                            colorProgress = (1.0 - progress).clamp(0.0, 1.0);
                          } else {
                            colorProgress = 0.0;
                          }

                          final iconColor = Color.lerp(
                            widget.inactiveIconColor,
                            widget.activeColor,
                            colorProgress,
                          )!;

                          final labelColor = Color.lerp(
                            widget.inactiveLabelColor,
                            widget.activeColor,
                            colorProgress,
                          )!;

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
                                      minWidth: 44.0,
                                      minHeight: 44.0,
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          item.icon,
                                          size: TopCutoutNavigationBar.iconSize,
                                          color: iconColor,
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          item.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: TopCutoutNavigationBar.labelFontSize,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: labelColor,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // =========================================================
                    // LAYER 3: Selected Pink Ball Nestled in Cutout with Gooey Bounce
                    // =========================================================
                    Positioned(
                      left: animatedNotchX - (widget.dotDiameter / 2),
                      top: widget.dotYOffset - (widget.dotDiameter / 2),
                      width: widget.dotDiameter,
                      height: widget.dotDiameter,
                      child: IgnorePointer(
                        child: Transform.scale(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          alignment: Alignment.center,
                          child: Container(
                            key: const ValueKey('top_cutout_selected_dot'),
                            width: widget.dotDiameter,
                            height: widget.dotDiameter,
                            decoration: BoxDecoration(
                              color: widget.dotColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      widget.dotColor.withValues(alpha: 0.18),
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                  offset: Offset.zero,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// CustomPainter that renders a white navigation surface with:
/// - Completely straight horizontal top edge across the entire bar.
/// - Smooth semi-circular cutout at [notchX] dipping to [notchDepth] when selected.
/// - Clean outer edges (straight by default, with optional rounded corners if cornerRadius > 0).
/// - Diffused drop shadow along the straight top edge and semi-circular cutout.
class TopCutoutBarPainter extends CustomPainter {
  final double notchX;
  final double notchWidth;
  final double notchDepth;
  final double cornerRadius;
  final Color backgroundColor;
  final Color shadowColor;
  final bool isDocked;

  const TopCutoutBarPainter({
    this.notchX = 0.0,
    this.notchWidth = 0.0,
    this.notchDepth = 0.0,
    this.cornerRadius = 0.0,
    required this.backgroundColor,
    required this.shadowColor,
    this.isDocked = true,
  });

  /// Constructs a path for the white bar with a straight horizontal top edge,
  /// a smooth semi-circular cutout dipping at [notchX], and straight or rounded outer corners.
  Path buildBarPath(Size size) {
    final w = size.width;
    final h = size.height;
    final r = cornerRadius;
    final path = Path();

    if (notchWidth <= 0.0 || notchDepth <= 0.0) {
      if (r <= 0) {
        return Path()..addRect(Rect.fromLTWH(0, 0, w, h));
      } else {
        return Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, w, h),
              Radius.circular(r),
            ),
          );
      }
    }

    final halfW = notchWidth / 2.0;
    final leftNotchX = (notchX - halfW).clamp(0.0, w);
    final rightNotchX = (notchX + halfW).clamp(0.0, w);

    // 1. Top-left corner
    path.moveTo(0, 0);

    // 2. Straight horizontal top edge to the left shoulder of the notch
    if (leftNotchX > 0) {
      path.lineTo(leftNotchX, 0);
    }

    // 3. Smooth semi-circular scooped cutout dipping to notchDepth at notchX
    path.cubicTo(
      notchX - halfW * 0.55,
      0.0,
      notchX - halfW * 0.48,
      notchDepth,
      notchX,
      notchDepth,
    );
    path.cubicTo(
      notchX + halfW * 0.48,
      notchDepth,
      notchX + halfW * 0.55,
      0.0,
      rightNotchX,
      0.0,
    );

    // 4. Straight horizontal top edge to the top-right corner
    if (rightNotchX < w) {
      path.lineTo(w, 0);
    }

    // 5. Down right edge, across bottom, and up left edge
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    if (r > 0) {
      final outerRRect = Path()
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, w, h),
          Radius.circular(r),
        ));
      return Path.combine(PathOperation.intersect, path, outerRRect);
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = buildBarPath(size);

    // Soft diffused drop shadow along the top edge and semi-circle cutout
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);
    final shadowOffset = isDocked ? const Offset(0, -2.0) : const Offset(0, 2.0);
    canvas.drawPath(path.shift(shadowOffset), shadowPaint);

    // Solid surface fill
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant TopCutoutBarPainter oldDelegate) {
    return oldDelegate.notchX != notchX ||
        oldDelegate.notchWidth != notchWidth ||
        oldDelegate.notchDepth != notchDepth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.isDocked != isDocked;
  }
}
