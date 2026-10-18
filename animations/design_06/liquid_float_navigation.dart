import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'liquid_float_nav_item.dart';

export 'liquid_float_nav_item.dart';

/// Refined liquid easing curve delivering a smooth horizontal glide
/// with gentle fluid settling (340 ms).
class LiquidFloatCurve extends Curve {
  const LiquidFloatCurve();

  @override
  double transformInternal(double t) {
    if (t >= 1.0) return 1.0;
    if (t <= 0.0) return 0.0;

    // Smooth cubic ease-out with minimal soft cushion
    final easeOut = 1.0 - math.pow(1.0 - t, 3.0);
    final liquidCushion =
        math.pow(math.sin(t * math.pi), 1.6) * math.pow(t, 1.4) * 0.12;

    return (easeOut + liquidCushion).clamp(0.0, 1.05);
  }
}

/// Design 06: Liquid Float Navigation Bar.
///
/// Features:
/// - White, full-width, pill-shaped bottom navigation bar with rounded ends (32 px).
/// - Exactly five evenly spaced items: Home, Search, Likes, Notifications, Profile.
/// - Inactive items rest inside the bar with gray icons (#858087, 24 px) and regular-weight labels (#858087, 13.5 px).
/// - On selecting an icon, the label pushes upward from within the bar, visibly driving the circular
///   icon upward with it as both emerge smoothly into an elevated floating position.
/// - The bar's top edge deforms into a smooth, shallow upward liquid wave connecting the raised item to the bar.
/// - Active icon centered inside a baby-pink circle (#EC3E8D, 64 px diameter) protruding above the bar.
/// - Active label in vibrant pink (#EC3E8D, 14 px, medium weight) pushed cohesively beneath the circle.
/// - Smooth fade-like transitions with gentle opacity crossfades.
class LiquidFloatNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onTabSelected;
  final List<LiquidFloatNavItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color shadowColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final double circleDiameter;
  final double iconSize;
  final double activeIconSize;
  final double barHeight;
  final double cornerRadius;
  final double waveRise;
  final double waveWidth;
  final bool useSafeArea;

  const LiquidFloatNavigationBar({
    super.key,
    int? selectedIndex,
    int? currentIndex,
    ValueChanged<int>? onTabSelected,
    ValueChanged<int>? onTap,
    this.items = LiquidFloatNavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeColor = const Color(0xFFEC3E8D),
    this.inactiveColor = const Color(0xFF858087),
    this.shadowColor = const Color(0x18000000),
    this.animationDuration = const Duration(milliseconds: 340),
    this.animationCurve = const LiquidFloatCurve(),
    this.circleDiameter = 64.0,
    this.iconSize = 24.0,
    this.activeIconSize = 24.0,
    this.barHeight = 86.0,
    this.cornerRadius = 32.0,
    this.waveRise = 14.0,
    this.waveWidth = 104.0,
    this.useSafeArea = true,
  })  : currentIndex = selectedIndex ?? currentIndex ?? 0,
        onTap = onTabSelected ?? onTap,
        onTabSelected = onTabSelected ?? onTap;

  @override
  State<LiquidFloatNavigationBar> createState() =>
      _LiquidFloatNavigationBarState();
}

class _LiquidFloatNavigationBarState extends State<LiquidFloatNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;
  int _previousIndex = 0;

  double? _fromX;
  double? _targetX;
  double _lastAnimatedX = 0.0;
  double _lastTabWidth = 0.0;

  // Geometry top offset for the bar surface
  static const double _barTop = 18.0;

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
  void didUpdateWidget(covariant LiquidFloatNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentIndex) {
      _handleIndexChange(widget.currentIndex);
    }
  }

  void _handleIndexChange(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.items.length) return;
    if (newIndex == _currentIndex && !_controller.isAnimating) return;

    final startX = _controller.isAnimating
        ? _lastAnimatedX
        : (_lastTabWidth > 0 ? (_currentIndex + 0.5) * _lastTabWidth : null);

    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = newIndex;
      _fromX = startX;
      _targetX = _lastTabWidth > 0 ? (newIndex + 0.5) * _lastTabWidth : null;
    });

    _controller.forward(from: 0.0);
  }

  void _handleTabTap(int index) {
    widget.onTap?.call(index);
    if (index == _currentIndex) {
      if (!_controller.isAnimating) {
        _controller.forward(from: 0.0);
      }
      return;
    }
    _handleIndexChange(index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        widget.useSafeArea ? MediaQuery.of(context).padding.bottom : 0.0;
    final totalWidgetHeight = _barTop + widget.barHeight + bottomPadding;
    final tabCount = widget.items.length;

    return Semantics(
      container: true,
      label: 'Bottom Navigation Bar',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          final tabWidth = tabCount > 0 ? barWidth / tabCount : 0.0;
          _lastTabWidth = tabWidth;

          final currentTargetX = (tabWidth * (_currentIndex + 0.5));
          if (_targetX == null || !_controller.isAnimating) {
            _targetX = currentTargetX;
          }

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final progress = _animation.value;

              final startX = _fromX ?? currentTargetX;
              final endX = _targetX ?? currentTargetX;

              final animatedX = _fromX == null || startX == endX
                  ? endX
                  : Tween<double>(begin: startX, end: endX).transform(progress);
              _lastAnimatedX = animatedX;

              // Subtle liquid stretch along the travel axis
              double stretchX = 0.0;
              if (_controller.isAnimating && startX != endX) {
                final u = _controller.value;
                if (u < 0.65) {
                  stretchX = math.sin((u / 0.65) * math.pi) * 0.20;
                } else if (u < 0.92) {
                  final reboundU = (u - 0.65) / 0.27;
                  stretchX = -math.sin(reboundU * math.pi) * 0.09;
                } else {
                  stretchX = 0.0;
                }
              }

              final scaleX = (1.0 + stretchX).clamp(0.88, 1.25);
              final scaleY = (1.0 - stretchX * 0.45).clamp(0.85, 1.15);

              // Wave dynamically stretches slightly during transit
              final currentWaveWidth =
                  widget.waveWidth * (1.0 + stretchX * 0.20);

              // Tactile "label pushing the icon upward" dynamics:
              // As progress runs, the label surges upward first and lifts the circle out of the bar
              final animVal = _controller.isAnimating ? _controller.value : 1.0;

              // Circle push-up: label thrusts up from below, causing the circle to lift out and cushion-settle
              final double circleLiftProgress;
              if (animVal < 0.15) {
                circleLiftProgress = (animVal / 0.15) * 0.10;
              } else {
                final t = (animVal - 0.15) / 0.85;
                final ease = 1.0 - math.pow(1.0 - t, 3.0);
                final bounce =
                    math.sin(t * math.pi) * math.pow(1.0 - t, 1.2) * 0.14;
                circleLiftProgress = (ease + bounce).clamp(0.0, 1.15);
              }
              final circleUpwardOffset = (1.0 - circleLiftProgress) * 14.0;

              // Base resting center for the active circle (protrudes 26 px above the straight bar top)
              const baseCircleCenterY = _barTop + 6.0;
              final currentCircleCenterY =
                  baseCircleCenterY + circleUpwardOffset;
              final circleTop =
                  currentCircleCenterY - (widget.circleDiameter / 2.0);

              // Label upward thrust: rises smoothly right beneath the circle, pushing upward
              final labelUpwardOffset =
                  (1.0 - Curves.easeOutCubic.transform(animVal)) * 16.0;
              final activeLabelTop = currentCircleCenterY +
                  (widget.circleDiameter / 2.0) +
                  3.0 +
                  (labelUpwardOffset * 0.4);

              return SizedBox(
                width: barWidth,
                height: totalWidgetHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // =========================================================
                    // LAYER 1: White Navigation Bar with Smooth Liquid Wave
                    // =========================================================
                    Positioned.fill(
                      child: CustomPaint(
                        painter: LiquidFloatBarPainter(
                          waveX: animatedX,
                          barTop: _barTop,
                          barHeight: widget.barHeight,
                          bottomInset: bottomPadding,
                          waveWidth: currentWaveWidth,
                          waveRise: widget.waveRise,
                          cornerRadius: widget.cornerRadius,
                          backgroundColor: widget.backgroundColor,
                          shadowColor: widget.shadowColor,
                        ),
                      ),
                    ),

                    // =========================================================
                    // LAYER 2: Five Navigation Tabs inside the Bar
                    // =========================================================
                    Positioned(
                      left: 0,
                      right: 0,
                      top: _barTop,
                      height: widget.barHeight,
                      child: Row(
                        children: List.generate(tabCount, (index) {
                          final item = widget.items[index];
                          final isSelected = index == _currentIndex;

                          // Smooth crossfade factor for the inactive state
                          double slotFade;
                          if (index == _currentIndex) {
                            slotFade = (1.0 - progress).clamp(0.0, 1.0);
                          } else if (index == _previousIndex) {
                            slotFade = progress.clamp(0.0, 1.0);
                          } else {
                            slotFade = 1.0;
                          }

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
                                    child: Opacity(
                                      opacity: slotFade,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            item.icon,
                                            size: widget.iconSize,
                                            color: widget.inactiveColor,
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            item.label,
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.normal,
                                              color: widget.inactiveColor,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ],
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

                    // =========================================================
                    // LAYER 3: Raised Pink Circular Button Lifted by Label
                    // =========================================================
                    Positioned(
                      left: animatedX - (widget.circleDiameter / 2.0),
                      top: circleTop,
                      width: widget.circleDiameter,
                      height: widget.circleDiameter,
                      child: IgnorePointer(
                        child: Transform.scale(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          alignment: Alignment.center,
                          child: Container(
                            key: const ValueKey('liquid_float_raised_circle'),
                            width: widget.circleDiameter,
                            height: widget.circleDiameter,
                            decoration: BoxDecoration(
                              color: widget.activeColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.activeColor
                                      .withValues(alpha: 0.30),
                                  blurRadius: 14.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(0, 5.0),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) {
                                return FadeTransition(
                                  opacity: anim,
                                  child: ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.85,
                                      end: 1.0,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: anim,
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                widget.items[_currentIndex].icon,
                                key: ValueKey<int>(_currentIndex),
                                size: widget.activeIconSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // =========================================================
                    // LAYER 4: Selected Label Pushing Upward Beneath Circle
                    // =========================================================
                    Positioned(
                      left: animatedX - 60.0,
                      top: activeLabelTop,
                      width: 120.0,
                      height: 20.0,
                      child: IgnorePointer(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            transitionBuilder: (child, anim) {
                              return FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.40),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: anim,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              widget.items[_currentIndex].label,
                              key: ValueKey<int>(_currentIndex),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: widget.activeColor,
                                letterSpacing: 0.1,
                              ),
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

/// Custom painter that renders a white, pill-shaped navigation bar with:
/// - Rounded ends (28–36 px radius).
/// - A smooth, shallow upward liquid wave crest around [waveX] connecting the raised item.
/// - Soft diffused drop shadow along the outer contour.
class LiquidFloatBarPainter extends CustomPainter {
  final double waveX;
  final double barTop;
  final double barHeight;
  final double bottomInset;
  final double waveWidth;
  final double waveRise;
  final double cornerRadius;
  final Color backgroundColor;
  final Color shadowColor;

  const LiquidFloatBarPainter({
    required this.waveX,
    required this.barTop,
    required this.barHeight,
    required this.bottomInset,
    required this.waveWidth,
    required this.waveRise,
    this.cornerRadius = 32.0,
    required this.backgroundColor,
    required this.shadowColor,
  });

  /// Constructs the path of the white bar with rounded ends and shallow upward wave.
  Path buildBarPath(Size size) {
    final w = size.width;
    final totalBottom = barTop + barHeight + bottomInset;
    final halfW = waveWidth / 2.0;

    final leftWaveX = (waveX - halfW).clamp(0.0, w);
    final rightWaveX = (waveX + halfW).clamp(0.0, w);
    final crestY = barTop - waveRise;

    final path = Path();

    // 1. Start at top-left corner arc
    path.moveTo(cornerRadius, barTop);

    // 2. Left straight edge up to wave start
    if (leftWaveX > cornerRadius) {
      path.lineTo(leftWaveX, barTop);
    }

    // 3. Smooth upward liquid wave crest around waveX
    path.cubicTo(
      waveX - halfW * 0.52,
      barTop,
      waveX - halfW * 0.40,
      crestY,
      waveX,
      crestY,
    );
    path.cubicTo(
      waveX + halfW * 0.40,
      crestY,
      waveX + halfW * 0.52,
      barTop,
      rightWaveX,
      barTop,
    );

    // 4. Right straight edge to top-right corner
    if (rightWaveX < w - cornerRadius) {
      path.lineTo(w - cornerRadius, barTop);
    }

    // 5. Rounded top-right corner
    path.arcToPoint(
      Offset(w, barTop + cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // 6. Right edge down to rounded bottom-right corner
    path.lineTo(w, totalBottom - cornerRadius);
    path.arcToPoint(
      Offset(w - cornerRadius, totalBottom),
      radius: Radius.circular(cornerRadius),
    );

    // 7. Bottom edge to rounded bottom-left corner
    path.lineTo(cornerRadius, totalBottom);
    path.arcToPoint(
      Offset(0, totalBottom - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // 8. Left edge up to rounded top-left corner
    path.lineTo(0, barTop + cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, barTop),
      radius: Radius.circular(cornerRadius),
    );

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = buildBarPath(size);

    // Soft diffused drop shadow along top boundary and wave
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);
    canvas.drawPath(path.shift(const Offset(0, -2.0)), shadowPaint);

    // Solid white surface fill
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant LiquidFloatBarPainter oldDelegate) {
    return oldDelegate.waveX != waveX ||
        oldDelegate.barTop != barTop ||
        oldDelegate.barHeight != barHeight ||
        oldDelegate.bottomInset != bottomInset ||
        oldDelegate.waveWidth != waveWidth ||
        oldDelegate.waveRise != waveRise ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}
