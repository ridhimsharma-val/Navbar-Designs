import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dot_indicator_nav_item.dart';

export 'dot_indicator_nav_item.dart';

/// Design 07 — Dot Indicator Navigation
///
/// A minimal, elegant bottom navigation bar featuring:
/// - Five evenly spaced outline icons without visible text labels.
/// - Straight full-width white navigation bar across the bottom of the screen.
/// - A tiny, vibrant baby-pink circular indicator dot (`#EC3E8D`) positioned directly beneath the active icon.
/// - Fluid wave bounce animation: the dot arcs upward like a wave crest while traveling between tabs and settles softly.
/// - Active icon highlighted in baby pink with natural filled variants.
/// - Inactive icons styled in muted gray (`#858087`) with outline style.
/// - Full-width straight bottom edge and safe-area integration.
class DotIndicatorNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onTabSelected;
  final List<DotIndicatorNavItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color borderColor;
  final Color shadowColor;
  final double dotDiameter;
  final double iconSize;
  final double barHeight;
  final double cornerRadius;
  final double horizontalMargin;
  final double waveBounceHeight;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool useSafeArea;

  const DotIndicatorNavigationBar({
    super.key,
    int? selectedIndex,
    int? currentIndex,
    ValueChanged<int>? onTabSelected,
    ValueChanged<int>? onTap,
    this.items = DotIndicatorNavItem.defaultItems,
    this.backgroundColor = Colors.white,
    this.activeColor = const Color(0xFFEC3E8D),
    this.inactiveColor = const Color(0xFF858087),
    this.borderColor = const Color(0xFFF1EAF3),
    this.shadowColor = const Color(0x0E7E6E88),
    this.dotDiameter = 6.0,
    this.iconSize = 24.0,
    this.barHeight = 64.0,
    this.cornerRadius = 0.0,
    this.horizontalMargin = 0.0,
    this.waveBounceHeight = 14.0,
    this.animationDuration = const Duration(milliseconds: 320),
    this.animationCurve = Curves.easeInOutCubic,
    this.useSafeArea = true,
  })  : currentIndex = selectedIndex ?? currentIndex ?? 0,
        onTap = onTabSelected ?? onTap,
        onTabSelected = onTabSelected ?? onTap;

  @override
  State<DotIndicatorNavigationBar> createState() =>
      _DotIndicatorNavigationBarState();
}

class _DotIndicatorNavigationBarState extends State<DotIndicatorNavigationBar>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;

  late AnimationController _controller;
  late Animation<double> _animation;

  double? _fromX;
  double? _targetX;
  double _lastAnimatedX = 0.0;
  double _lastTabWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex.clamp(0, widget.items.length - 1);

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );
  }

  @override
  void didUpdateWidget(covariant DotIndicatorNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentIndex) {
      _animateToTab(widget.currentIndex.clamp(0, widget.items.length - 1));
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

  void _animateToTab(int newIndex) {
    final tabCount = widget.items.length;
    if (tabCount == 0) return;

    final currentX = _lastAnimatedX > 0.0
        ? _lastAnimatedX
        : (_currentIndex + 0.5) * _lastTabWidth;
    final nextX = (newIndex + 0.5) * _lastTabWidth;

    setState(() {
      _currentIndex = newIndex;
      _fromX = currentX;
      _targetX = nextX;
    });

    _controller.forward(from: 0.0);
  }

  void _handleTabTap(int index) {
    if (index < 0 || index >= widget.items.length) return;
    widget.onTap?.call(index);
    if (index != _currentIndex) {
      _animateToTab(index);
    } else if (!_controller.isAnimating) {
      // Gentle in-place wave bounce feedback when tapping active tab
      _animateToTab(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        widget.useSafeArea ? MediaQuery.of(context).padding.bottom : 0.0;
    final totalHeight = widget.barHeight + bottomInset;
    final tabCount = widget.items.length;

    return Semantics(
      container: true,
      label: 'Minimal Dot Indicator Bottom Navigation Bar',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
        height: totalHeight,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.cornerRadius > 0
              ? BorderRadius.only(
                  topLeft: Radius.circular(widget.cornerRadius),
                  topRight: Radius.circular(widget.cornerRadius),
                )
              : null,
          border: Border(
            top: BorderSide(
              color: widget.borderColor,
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              blurRadius: 16.0,
              spreadRadius: 0.0,
              offset: const Offset(0.0, -4.0),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final tabWidth = barWidth / (tabCount > 0 ? tabCount : 1);
              _lastTabWidth = tabWidth;

              final currentTargetX = (_currentIndex + 0.5) * tabWidth;
              final startX = _fromX ?? currentTargetX;
              final endX = _targetX ?? currentTargetX;
              final travelDistance = (endX - startX).abs();

              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final progress = _animation.value;
                  final animatedX = _fromX == null || startX == endX
                      ? endX
                      : Tween<double>(begin: startX, end: endX)
                          .transform(progress);
                  _lastAnimatedX = animatedX;

                  // Wave bounce physics calculation
                  double waveRise = 0.0;
                  double scaleX = 1.0;
                  double scaleY = 1.0;

                  if (_controller.isAnimating) {
                    final jumpTabs = tabWidth > 0
                        ? (travelDistance / tabWidth).round().clamp(1, 4)
                        : 1;
                    final effectivePeak = startX == endX
                        ? 10.0
                        : (widget.waveBounceHeight + (jumpTabs - 1) * 2.5);

                    if (progress < 0.78) {
                      // Phase 1: High-flying fluid wave arc
                      final arcT = progress / 0.78;
                      waveRise = math.sin(arcT * math.pi) * effectivePeak;

                      // Mid-flight wave elongation along horizontal transit
                      final stretch = math.sin(arcT * math.pi);
                      scaleX = 1.0 + stretch * 0.28;
                      scaleY = 1.0 - stretch * 0.16;
                    } else {
                      // Phase 2: Gentle landing cushion ripple & settling
                      final settleT = (progress - 0.78) / 0.22;
                      waveRise = math.sin(settleT * math.pi) *
                          (effectivePeak * 0.18) *
                          (1.0 - settleT);

                      // Landing impact cushion compression
                      final cushion =
                          math.sin(settleT * math.pi) * (1.0 - settleT);
                      scaleX = 1.0 + cushion * 0.16;
                      scaleY = 1.0 - cushion * 0.14;
                    }
                  }

                  const baseDotBottom = 9.0;
                  final currentDotBottom = baseDotBottom + waveRise;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 1. Navigation Icons Row
                      Positioned.fill(
                        child: Row(
                          children: List.generate(tabCount, (index) {
                            final item = widget.items[index];
                            final isSelected = index == _currentIndex;

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
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: TweenAnimationBuilder<Color?>(
                                        duration: widget.animationDuration,
                                        curve: widget.animationCurve,
                                        tween: ColorTween(
                                          begin: isSelected
                                              ? widget.inactiveColor
                                              : widget.activeColor,
                                          end: isSelected
                                              ? widget.activeColor
                                              : widget.inactiveColor,
                                        ),
                                        builder: (context, color, _) {
                                          return AnimatedScale(
                                            scale: isSelected ? 1.0 : 0.95,
                                            duration: widget.animationDuration,
                                            curve: widget.animationCurve,
                                            child: Icon(
                                              isSelected
                                                  ? (item.activeIcon ??
                                                      item.icon)
                                                  : item.icon,
                                              size: widget.iconSize,
                                              color: color,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      // 2. Active Indicator Pink Dot (Wave Arc Bounce & Transit)
                      Positioned(
                        key: const ValueKey('dot_indicator_active_dot'),
                        left: animatedX - (widget.dotDiameter / 2.0),
                        bottom: currentDotBottom,
                        width: widget.dotDiameter,
                        height: widget.dotDiameter,
                        child: IgnorePointer(
                          child: Transform.scale(
                            scaleX: scaleX,
                            scaleY: scaleY,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.activeColor,
                                shape: BoxShape.circle,
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
        ),
      ),
    );
  }
}
