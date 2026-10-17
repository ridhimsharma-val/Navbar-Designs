import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'liquid_nav_item.dart';

/// Design 03: Liquid Wave Navigation Bar.
///
/// A reusable, standalone Flutter bottom navigation bar with exactly three
/// tabs (Home, Plus, Profile), featuring a continuous, filled baby-pink liquid
/// wave that organically rises around the active icon and flows playfully
/// with gooey stretching and bouncy settling transitions.
///
/// Features:
/// - Exactly 3 tabs evenly distributed: Home, Plus, and Profile.
/// - Base white navigation surface (`#FFFFFF`) with a straight horizontal top edge.
/// - Filled, connected baby-pink liquid wave (`#FCE7EF` fluid body with `#F8C8DD` depth
///   and glossy highlight) that rises seamlessly from the navigation surface.
/// - Fluid gooey animation: stretches horizontally in the direction of travel,
///   dips slightly in height during transit, and settles with an elastic rebound.
/// - Active icon gently elevated into the liquid crest in bright pink (`#EC3E8D`).
/// - Light, elegant active label (`15.0 px`, `FontWeight.w400`, `#EC3E8D`).
/// - Inactive outline icons (`#858087`, `24 x 24 px`) with hidden labels.
/// - Non-destructive safe-area handling for system gesture bars.
/// - Equal-width touch areas exceeding 44 x 44 logical pixels.
class LiquidWaveNavigationBar extends StatefulWidget {
  /// Currently selected tab index (0-indexed).
  final int selectedIndex;

  /// Callback invoked when the user selects a tab.
  final ValueChanged<int>? onItemSelected;

  /// The list of navigation items (defaults to standard 3 items: Home, Plus, Profile).
  final List<LiquidNavItem> items;

  /// Background color of the main navigation surface.
  final Color backgroundColor;

  /// Primary color for the active icon and active label.
  final Color activeColor;

  /// Color for the filled liquid wave body.
  final Color liquidWaveColor;

  /// Color for inactive outline icons.
  final Color inactiveColor;

  /// Duration of the liquid wave transition (recommended: 450-600 ms).
  final Duration animationDuration;

  /// Height of the white navigation bar (excluding upward wave crest and safe area).
  final double barHeight;

  /// Upward height of the liquid wave crest above the straight horizontal top edge.
  final double waveHeight;

  /// Resting width of the liquid wave around the active tab.
  final double waveWidth;

  /// Maximum width constraint for desktop/wide displays.
  final double maxMobileWidth;

  /// Whether to automatically extend the white surface behind the bottom safe area.
  final bool useSafeArea;

  const LiquidWaveNavigationBar({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.items = LiquidNavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeColor = const Color(0xFFEC3E8D),
    this.liquidWaveColor = const Color(0xFFFCE7EF),
    this.inactiveColor = const Color(0xFF858087),
    this.animationDuration = const Duration(milliseconds: 520),
    this.barHeight = 72.0,
    this.waveHeight = 24.0,
    this.waveWidth = 96.0,
    this.maxMobileWidth = double.infinity,
    this.useSafeArea = true,
  }) : assert(items.length > 0, 'Items list cannot be empty');

  // Exact typography & sizing constants
  static const double iconSize = 24.0;
  static const double labelFontSize = 15.0;
  static const FontWeight labelFontWeight = FontWeight.w400;
  static const double labelLetterSpacing = 0.1;

  @override
  State<LiquidWaveNavigationBar> createState() =>
      _LiquidWaveNavigationBarState();
}

class _LiquidWaveNavigationBarState extends State<LiquidWaveNavigationBar>
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
      curve: Curves.easeInOutCubic,
    );

    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant LiquidWaveNavigationBar oldWidget) {
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
      _previousIndex = _currentIndex;
      _currentIndex = targetIndex;
    });

    _controller.forward(from: 0.0);
  }

  void _handleTabTap(int index) {
    if (index >= 0 && index < widget.items.length) {
      _animateTo(index);
      widget.onItemSelected?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final bottomInset = (widget.useSafeArea && mediaQuery != null)
        ? mediaQuery.padding.bottom
        : 0.0;

    // Total component height = upward wave protrusion + main bar + bottom safe area
    final totalHeight = widget.barHeight + widget.waveHeight + bottomInset;

    Widget navWidget = SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          final tabCount = widget.items.length;
          final tabWidth = barWidth / tabCount;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = _animation.value;

              // Compute horizontal centers for previous and target tabs
              final startX = (_previousIndex + 0.5) * tabWidth;
              final targetX = (_currentIndex + 0.5) * tabWidth;

              // Physics of fluid transit:
              // 1. Leading edge leads eagerly, trailing edge lags due to liquid viscosity
              // 2. Wave stretches horizontally up to +52px in flight
              // 3. Fluid volume conservation: wave height compresses slightly in flight
              // 4. Elastic rebound: wave overshoots and oscillates into its settled bulge
              final travelDist = targetX - startX;
              final isMoving = travelDist.abs() > 0.01;
              final travelDirection =
                  isMoving ? (travelDist > 0 ? 1.0 : -1.0) : 0.0;

              // Velocity factor: bell curve peaking at progress = 0.5
              final velocity = isMoving ? math.sin(progress * math.pi) : 0.0;

              // Center position of the wave with an organic easeInOutCubic curve
              final waveCenterX = startX +
                  travelDist * Curves.easeInOutCubic.transform(progress);

              // Pronounced horizontal stretch during transit (up to 52px wider)
              final stretchFactor = velocity * 52.0;
              final currentWaveWidth = widget.waveWidth + stretchFactor;

              // Dynamic height: fluid compresses during fast travel, then overshoots with an elastic rebound
              final dip = velocity * 7.0;
              final rebound = (progress > 0.65)
                  ? math.sin((progress - 0.65) / 0.35 * math.pi) *
                      5.5 *
                      (1.0 - progress)
                  : 0.0;
              final currentWaveHeight =
                  math.max(12.0, widget.waveHeight - dip + rebound);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // -----------------------------------------------------------
                  // 1. Custom Painted Filled Liquid Wave & White Surface
                  // -----------------------------------------------------------
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _FilledLiquidWavePainter(
                        waveCenterX: waveCenterX,
                        waveWidth: currentWaveWidth,
                        waveHeight: currentWaveHeight,
                        barHeight: widget.barHeight,
                        waveProtrusion: widget.waveHeight,
                        bottomInset: bottomInset,
                        backgroundColor: widget.backgroundColor,
                        activeColor: widget.activeColor,
                        liquidWaveColor: widget.liquidWaveColor,
                        travelDirection: travelDirection,
                        velocity: velocity,
                      ),
                    ),
                  ),

                  // -----------------------------------------------------------
                  // 2. Interactive 3-Tab Items Row (Home, Plus, Profile)
                  // -----------------------------------------------------------
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: widget.barHeight + widget.waveHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(tabCount, (index) {
                        final item = widget.items[index];
                        final isSelected = index == _currentIndex;

                        // Fraction of active state for this tab (0.0 to 1.0)
                        double activeFraction = 0.0;
                        if (_currentIndex == _previousIndex) {
                          activeFraction = isSelected ? 1.0 : 0.0;
                        } else if (index == _currentIndex) {
                          activeFraction = progress;
                        } else if (index == _previousIndex) {
                          activeFraction = 1.0 - progress;
                        }

                        return Expanded(
                          child: _LiquidTabItem(
                            item: item,
                            isSelected: isSelected,
                            activeFraction: activeFraction,
                            onTap: () => _handleTabTap(index),
                            activeColor: widget.activeColor,
                            inactiveColor: widget.inactiveColor,
                            waveHeight: widget.waveHeight,
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

    if (widget.maxMobileWidth.isFinite) {
      navWidget = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxMobileWidth),
        child: navWidget,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: navWidget,
    );
  }
}

/// Custom painter that renders a genuinely connected, filled baby-pink liquid
/// wave that seamlessly bulges out of the straight top edge of the navigation surface.
///
/// Ensures:
/// - Perfectly straight horizontal top edge across the entire bar.
/// - Around the selected tab, a smooth organic liquid bulge rises upward without
///   any gap, internal seam, or overlapping line.
/// - Pure solid baby-pink fill (#FCE7EF) with no white lines inside.
/// - Drop shadow tracks the composite continuous outline.
class _FilledLiquidWavePainter extends CustomPainter {
  final double waveCenterX;
  final double waveWidth;
  final double waveHeight;
  final double barHeight;
  final double waveProtrusion;
  final double bottomInset;
  final Color backgroundColor;
  final Color activeColor;
  final Color liquidWaveColor;
  final double travelDirection;
  final double velocity;

  const _FilledLiquidWavePainter({
    required this.waveCenterX,
    required this.waveWidth,
    required this.waveHeight,
    required this.barHeight,
    required this.waveProtrusion,
    required this.bottomInset,
    required this.backgroundColor,
    required this.activeColor,
    required this.liquidWaveColor,
    required this.travelDirection,
    required this.velocity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baselineY = waveProtrusion;
    final totalBottomY = size.height;
    final halfWidth = waveWidth / 2.0;

    // Asymmetric fluid dynamics:
    // Leading edge extends forward in the direction of travel.
    // Trailing edge stretches and thins out due to viscous liquid friction.
    final leadingExtension = travelDirection * velocity * 14.0;
    final trailingDrag = -travelDirection * velocity * 20.0;

    final leftX = (waveCenterX - halfWidth) +
        (travelDirection >= 0 ? trailingDrag : leadingExtension);
    final rightX = (waveCenterX + halfWidth) +
        (travelDirection >= 0 ? leadingExtension : trailingDrag);

    // The crest tilts forward slightly in the direction of flight
    final crestX = waveCenterX + (travelDirection * velocity * 6.0);
    final crestY = baselineY - waveHeight;

    // -------------------------------------------------------------------------
    // 1. Continuous composite outline path for the navigation surface
    // -------------------------------------------------------------------------
    // To ensure a truly smooth, organic, tangent-continuous liquid join into the
    // straight top edge:
    // - Control Point 1 (CP1) starts horizontally at y = baselineY (C1 continuity).
    // - Control Point 2 (CP2) reaches smoothly to the crest top at y = crestY with 0 vertical derivative.
    // - Control Point 3 (CP3) departs the crest horizontally at y = crestY.
    // - Control Point 4 (CP4) lands smoothly back onto y = baselineY horizontally.
    final leftSpan = crestX - leftX;
    final rightSpan = rightX - crestX;

    final compositeOutline = Path()
      ..moveTo(0, baselineY)
      ..lineTo(leftX, baselineY)
      // Left upward meniscus curve: tangent horizontal at leftX, tangent horizontal at crest
      ..cubicTo(
        leftX + leftSpan * 0.44,
        baselineY,
        crestX - leftSpan * 0.36,
        crestY,
        crestX,
        crestY,
      )
      // Right downward meniscus curve: tangent horizontal at crest, tangent horizontal at rightX
      ..cubicTo(
        crestX + rightSpan * 0.36,
        crestY,
        rightX - rightSpan * 0.44,
        baselineY,
        rightX,
        baselineY,
      )
      ..lineTo(size.width, baselineY)
      ..lineTo(size.width, totalBottomY)
      ..lineTo(0, totalBottomY)
      ..close();

    // Drop shadow: very subtle crisp soft tint along the composite outline
    // Note: Use a clean transparent tint so no dark/gray rectangular artifacts appear
    final shadowPaint = Paint()
      ..color = const Color(0x06000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawPath(compositeOutline.shift(const Offset(0, -1.0)), shadowPaint);

    // -------------------------------------------------------------------------
    // 2. Base Solid White Docked Navigation Bar Surface
    // -------------------------------------------------------------------------
    final basePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(compositeOutline, basePaint);

    // -------------------------------------------------------------------------
    // 3. Seamless Filled Baby-Pink Liquid Wave Bulge
    // -------------------------------------------------------------------------
    // The organic liquid wave covers the raised bulge above the baseline AND
    // extends smoothly into the navigation bar surface below the baseline with a
    // soft, rounded lower meniscus.
    final liquidWavePath = Path()
      ..moveTo(leftX, baselineY)
      ..cubicTo(
        leftX + leftSpan * 0.44,
        baselineY,
        crestX - leftSpan * 0.36,
        crestY,
        crestX,
        crestY,
      )
      ..cubicTo(
        crestX + rightSpan * 0.36,
        crestY,
        rightX - rightSpan * 0.44,
        baselineY,
        rightX,
        baselineY,
      )
      // Smooth continuous lower meniscus extending down into the bar surface
      ..cubicTo(
        rightX - 10.0,
        baselineY + 44.0,
        leftX + 10.0,
        baselineY + 44.0,
        leftX,
        baselineY,
      )
      ..close();

    final liquidPaint = Paint()
      ..color = liquidWaveColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(liquidWavePath, liquidPaint);
  }

  @override
  bool shouldRepaint(covariant _FilledLiquidWavePainter oldDelegate) {
    return oldDelegate.waveCenterX != waveCenterX ||
        oldDelegate.waveWidth != waveWidth ||
        oldDelegate.waveHeight != waveHeight ||
        oldDelegate.velocity != velocity ||
        oldDelegate.travelDirection != travelDirection ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.liquidWaveColor != liquidWaveColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

/// Interactive navigation tab item for Design 03.
///
/// Features:
/// - Equal-width touch area for all three tabs (Home, Plus, Profile).
/// - Active icon floats upward into the liquid wave crest ($10\text{ px}$).
/// - Active label smoothly reveals underneath in light, elegant typography ($15.0\text{ px}$, `FontWeight.w400`).
/// - No background decoration, box, or gray highlight of any kind.
class _LiquidTabItem extends StatelessWidget {
  final LiquidNavItem item;
  final bool isSelected;
  final double activeFraction;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final double waveHeight;

  const _LiquidTabItem({
    required this.item,
    required this.isSelected,
    required this.activeFraction,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.waveHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Upward icon float as wave rises underneath it:
    // Floats upward by 10 logical pixels into the center of the liquid wave crest.
    final iconVerticalOffset = -activeFraction * 10.0;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.tooltip ?? item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          child: Container(
            color: Colors.transparent,
            constraints: const BoxConstraints(
              minWidth: 48.0,
              minHeight: 48.0,
            ),
            // Offset the inactive baseline slightly downwards so that
            // inactive icons sit comfortably centered in the main white bar.
            padding: EdgeInsets.only(top: waveHeight * 0.5),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon (rises smoothly with the liquid wave)
                Transform.translate(
                  offset: Offset(0, iconVerticalOffset),
                  child: SizedBox(
                    width: LiquidWaveNavigationBar.iconSize,
                    height: LiquidWaveNavigationBar.iconSize,
                    child: item.inactiveIcon == item.activeIcon
                        ? Icon(
                            item.activeIcon,
                            size: LiquidWaveNavigationBar.iconSize,
                            color: Color.lerp(
                              inactiveColor,
                              activeColor,
                              activeFraction,
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              // Inactive outline icon (fades out as tab activates)
                              Opacity(
                                opacity: (1.0 - activeFraction).clamp(0.0, 1.0),
                                child: Icon(
                                  item.inactiveIcon,
                                  size: LiquidWaveNavigationBar.iconSize,
                                  color: inactiveColor,
                                ),
                              ),

                              // Active filled icon (fades in as tab activates)
                              Opacity(
                                opacity: activeFraction.clamp(0.0, 1.0),
                                child: Icon(
                                  item.activeIcon,
                                  size: LiquidWaveNavigationBar.iconSize,
                                  color: activeColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // Active label (smoothly reveals underneath the elevated icon)
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: activeFraction,
                    child: Opacity(
                      opacity: activeFraction.clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: LiquidWaveNavigationBar.labelFontSize,
                            fontWeight: LiquidWaveNavigationBar.labelFontWeight,
                            color: Color(0xFFEC3E8D),
                            letterSpacing:
                                LiquidWaveNavigationBar.labelLetterSpacing,
                            height: 1.15,
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
