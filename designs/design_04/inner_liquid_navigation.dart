import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'inner_liquid_nav_item.dart';

/// Design 04: Inner Wave Pocket Navigation Bar.
///
/// A white, horizontally stretched, floating bottom navigation bar with a smooth,
/// baby-pink inner wave pocket behind the selected icon.
///
/// Exact Geometry Architecture:
/// - The white navigation bar remains a single continuous horizontal bar.
/// - The bar's top edge is straight everywhere except around the active tab.
/// - At the selected tab, its top edge smoothly curves upward on both sides to
///   create a shallow, rounded pocket around the active icon.
/// - The pink active background (#FCE7EF) sits INSIDE this pocket, integrated
///   seamlessly into the navigation bar's upper boundary.
/// - The active icon (#EC3E8D, 24-26 px) is centered within the pink pocket and
///   visually rises slightly above the inactive icons.
/// - Exactly three evenly distributed tabs: Home, Plus, and Profile.
/// - Inactive tabs display only gray icons (#858087, 24 px) with no labels.
/// - Active tab displays its light, elegant label (FontWeight.w400, 15 px, #EC3E8D).
class InnerLiquidNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final List<InnerLiquidNavItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color pocketColor;
  final Color inactiveColor;
  final Duration animationDuration;
  final double barHeight;
  final double pocketDepth;
  final double pocketHalfWidth;
  final double maxMobileWidth;
  final bool useSafeArea;

  const InnerLiquidNavigationBar({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.items = InnerLiquidNavItem.defaultItems,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.activeColor = const Color(0xFFEC3E8D),
    this.pocketColor = const Color(0xFFFCE7EF),
    this.inactiveColor = const Color(0xFF858087),
    this.animationDuration = const Duration(milliseconds: 400),
    this.barHeight = 78.0,
    this.pocketDepth = 24.0,
    this.pocketHalfWidth = 60.0,
    this.maxMobileWidth = double.infinity,
    this.useSafeArea = true,
  }) : assert(items.length > 0, 'Items list cannot be empty');

  static const double iconSize = 24.0;
  static const double labelFontSize = 15.0;
  static const FontWeight labelFontWeight = FontWeight.w400;

  @override
  State<InnerLiquidNavigationBar> createState() =>
      _InnerLiquidNavigationBarState();
}

class _InnerLiquidNavigationBarState extends State<InnerLiquidNavigationBar>
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

    final totalHeight = widget.barHeight + bottomInset;

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

              final startX = (_previousIndex + 0.5) * tabWidth;
              final targetX = (_currentIndex + 0.5) * tabWidth;
              final travelDist = targetX - startX;
              final isMoving = travelDist.abs() > 0.01;
              final travelDirection =
                  isMoving ? (travelDist > 0 ? 1.0 : -1.0) : 0.0;
              final velocity = isMoving ? math.sin(progress * math.pi) : 0.0;

              final pocketCenterX = startX +
                  travelDist * Curves.easeInOutCubic.transform(progress);

              final stretch = velocity * 14.0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Custom Painted Navigation Bar with Shallow Inward Wave Pocket
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _InnerWavePocketPainter(
                        pocketCenterX: pocketCenterX,
                        barHeight: widget.barHeight,
                        pocketDepth: widget.pocketDepth,
                        pocketHalfWidth: widget.pocketHalfWidth + stretch,
                        bottomInset: bottomInset,
                        travelDirection: travelDirection,
                        velocity: velocity,
                        backgroundColor: widget.backgroundColor,
                        activeColor: widget.activeColor,
                        pocketColor: widget.pocketColor,
                      ),
                    ),
                  ),

                  // 2. Interactive Navigation Tabs (Home, Plus, Profile)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: widget.barHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(tabCount, (index) {
                        final item = widget.items[index];
                        final isSelected = index == _currentIndex;

                        double activeFraction = 0.0;
                        if (_currentIndex == _previousIndex) {
                          activeFraction = isSelected ? 1.0 : 0.0;
                        } else if (index == _currentIndex) {
                          activeFraction = progress;
                        } else if (index == _previousIndex) {
                          activeFraction = 1.0 - progress;
                        }

                        return Expanded(
                          child: _InnerWaveTabItem(
                            item: item,
                            isSelected: isSelected,
                            activeFraction: activeFraction,
                            onTap: () => _handleTabTap(index),
                            activeColor: widget.activeColor,
                            inactiveColor: widget.inactiveColor,
                            pocketDepth: widget.pocketDepth,
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

/// Custom painter that renders:
/// 1. A pure white floating navigation bar with rounded bottom corners,
///    a straight horizontal top edge, and a smooth shallow inward pocket around cx.
/// 2. A baby-pink inner wave pocket (#FCE7EF) that fills this shallow indentation.
class _InnerWavePocketPainter extends CustomPainter {
  final double pocketCenterX;
  final double barHeight;
  final double pocketDepth;
  final double pocketHalfWidth;
  final double bottomInset;
  final double travelDirection;
  final double velocity;
  final Color backgroundColor;
  final Color activeColor;
  final Color pocketColor;

  const _InnerWavePocketPainter({
    required this.pocketCenterX,
    required this.barHeight,
    required this.pocketDepth,
    required this.pocketHalfWidth,
    required this.bottomInset,
    required this.travelDirection,
    required this.velocity,
    required this.backgroundColor,
    required this.activeColor,
    required this.pocketColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const barTop = 0.0;
    final totalBottomY = size.height;

    // Asymmetric fluid skew during movement
    final leadingDrag = travelDirection * velocity * 8.0;
    final trailingDrag = -travelDirection * velocity * 10.0;

    final cx = pocketCenterX + (travelDirection * velocity * 4.0);
    final leftX = (cx - pocketHalfWidth) +
        (travelDirection >= 0 ? trailingDrag : leadingDrag);
    final rightX = (cx + pocketHalfWidth) +
        (travelDirection >= 0 ? leadingDrag : trailingDrag);

    final spanLeft = cx - leftX;
    final spanRight = rightX - cx;
    final nadirY = barTop + pocketDepth;

    // -------------------------------------------------------------------------
    // 1. Full White Navigation Bar with Shallow Inward Wave Pocket
    // -------------------------------------------------------------------------
    // The top edge:
    // Starts at (0, barTop) -> straight line to (leftX, barTop)
    // -> curves smoothly down into shallow rounded nadir at (cx, nadirY)
    // -> curves smoothly back up to (rightX, barTop)
    // -> straight line to (size.width, barTop)
    // -> rounded bottom corners (28 px) -> close.
    final whiteBarPath = Path()
      ..moveTo(0, barTop)
      ..lineTo(leftX, barTop)
      // Left transition: smoothly curves inward/downward from straight edge to nadir
      ..cubicTo(
        leftX + spanLeft * 0.45,
        barTop,
        cx - spanLeft * 0.40,
        nadirY,
        cx,
        nadirY,
      )
      // Right transition: smoothly curves upward from nadir back to straight edge
      ..cubicTo(
        cx + spanRight * 0.40,
        nadirY,
        rightX - spanRight * 0.45,
        barTop,
        rightX,
        barTop,
      )
      ..lineTo(size.width, barTop)
      // Rounded bottom right corner (28px radius)
      ..lineTo(size.width, totalBottomY - 28.0)
      ..arcToPoint(
        Offset(size.width - 28.0, totalBottomY),
        radius: const Radius.circular(28.0),
      )
      // Rounded bottom left corner (28px radius)
      ..lineTo(28.0, totalBottomY)
      ..arcToPoint(
        Offset(0, totalBottomY - 28.0),
        radius: const Radius.circular(28.0),
      )
      ..close();

    // Soft, diffuse upward drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0x0C000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawPath(whiteBarPath.shift(const Offset(0, -2.0)), shadowPaint);

    // Draw white navigation surface
    final whitePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(whiteBarPath, whitePaint);

    // -------------------------------------------------------------------------
    // 2. Baby-Pink Inner Wave Pocket (#FCE7EF)
    // -------------------------------------------------------------------------
    // The pink region follows the exact inward wave pocket along the top,
    // and curves gracefully below into the white bar, completely cradling
    // the active icon and label in a single, unified, soft pink pocket.
    final pinkBasinBottomY = nadirY + 32.0;

    final pinkPocketPath = Path()
      ..moveTo(leftX, barTop)
      // Follow the shallow inward wave
      ..cubicTo(
        leftX + spanLeft * 0.45,
        barTop,
        cx - spanLeft * 0.40,
        nadirY,
        cx,
        nadirY,
      )
      ..cubicTo(
        cx + spanRight * 0.40,
        nadirY,
        rightX - spanRight * 0.45,
        barTop,
        rightX,
        barTop,
      )
      // Lower rounded basin enclosing icon and label seamlessly
      ..cubicTo(
        rightX - 8.0,
        pinkBasinBottomY,
        leftX + 8.0,
        pinkBasinBottomY,
        leftX,
        barTop,
      )
      ..close();

    final pinkPaint = Paint()
      ..color = pocketColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(pinkPocketPath, pinkPaint);
  }

  @override
  bool shouldRepaint(covariant _InnerWavePocketPainter oldDelegate) {
    return oldDelegate.pocketCenterX != pocketCenterX ||
        oldDelegate.barHeight != barHeight ||
        oldDelegate.pocketDepth != pocketDepth ||
        oldDelegate.pocketHalfWidth != pocketHalfWidth ||
        oldDelegate.velocity != velocity ||
        oldDelegate.travelDirection != travelDirection ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.pocketColor != pocketColor;
  }
}

/// Interactive navigation item tab for Design 04.
class _InnerWaveTabItem extends StatelessWidget {
  final InnerLiquidNavItem item;
  final bool isSelected;
  final double activeFraction;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final double pocketDepth;

  const _InnerWaveTabItem({
    required this.item,
    required this.isSelected,
    required this.activeFraction,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.pocketDepth,
  });

  @override
  Widget build(BuildContext context) {
    // When selected, the active icon gently settles into the shallow wave pocket
    final iconOffset = activeFraction * 4.0;

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
            padding: const EdgeInsets.only(top: 10.0),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon (settles smoothly inside the pink pocket when active)
                Transform.translate(
                  offset: Offset(0, iconOffset),
                  child: SizedBox(
                    width: InnerLiquidNavigationBar.iconSize,
                    height: InnerLiquidNavigationBar.iconSize,
                    child: item.inactiveIcon == item.activeIcon
                        ? Icon(
                            item.activeIcon,
                            size: InnerLiquidNavigationBar.iconSize,
                            color: Color.lerp(
                              inactiveColor,
                              activeColor,
                              activeFraction,
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: (1.0 - activeFraction).clamp(0.0, 1.0),
                                child: Icon(
                                  item.inactiveIcon,
                                  size: InnerLiquidNavigationBar.iconSize,
                                  color: inactiveColor,
                                ),
                              ),
                              Opacity(
                                opacity: activeFraction.clamp(0.0, 1.0),
                                child: Icon(
                                  item.activeIcon,
                                  size: InnerLiquidNavigationBar.iconSize,
                                  color: activeColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // Active label (smoothly reveals directly beneath the active icon)
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
                            fontSize: InnerLiquidNavigationBar.labelFontSize,
                            fontWeight:
                                InnerLiquidNavigationBar.labelFontWeight,
                            color: Color(0xFFEC3E8D),
                            letterSpacing: 0.1,
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
