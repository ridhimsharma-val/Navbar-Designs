import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../designs/design_01/minimal_circle_bottom_nav.dart';
import '../designs/design_01/nav_item.dart';
import '../designs/design_02/pill_expand_bottom_nav.dart';
import '../designs/design_02/pill_nav_item.dart';
import '../designs/design_03/liquid_nav_item.dart';
import '../designs/design_03/liquid_wave_navigation.dart';
import '../designs/design_04/inner_liquid_nav_item.dart';
import '../designs/design_04/inner_liquid_navigation.dart';
import '../designs/design_05/top_cutout_nav_item.dart';
import '../designs/design_05/top_cutout_navigation.dart';
import '../designs/design_06/liquid_float_navigation.dart';
import '../designs/design_07/dot_indicator_navigation.dart';
import '../shared/navigation_item.dart';

// =============================================================================
// Registry & Architecture for Bottom Navigation Designs
// =============================================================================

typedef NavDesignBuilder = Widget Function({
  required BuildContext context,
  required int currentIndex,
  required ValueChanged<int> onIndexChanged,
  required List<NavigationItem> items,
});

class NavigationDesignMeta {
  final String id;
  final String title;
  final String description;
  final NavDesignBuilder builder;

  const NavigationDesignMeta({
    required this.id,
    required this.title,
    required this.description,
    required this.builder,
  });
}

class NavigationPreviewRegistry {
  NavigationPreviewRegistry._();

  static final List<NavigationDesignMeta> designs = <NavigationDesignMeta>[
    NavigationDesignMeta(
      id: 'design_01',
      title: 'Design 01: Minimal Circle',
      description:
          'Full-width white navigation surface with straight top edge, concave circular cutout, and floating active circle.',
      builder: ({
        required BuildContext context,
        required int currentIndex,
        required ValueChanged<int> onIndexChanged,
        required List<NavigationItem> items,
      }) {
        return MinimalCircleBottomNav(
          selectedIndex: currentIndex,
          onItemSelected: onIndexChanged,
        );
      },
    ),
    NavigationDesignMeta(
      id: 'design_02',
      title: 'Design 02: Pill-Expand',
      description:
          'Floating rounded rectangular navigation bar where the selected item expands into a soft pink pill capsule with icon and label.',
      builder: ({
        required BuildContext context,
        required int currentIndex,
        required ValueChanged<int> onIndexChanged,
        required List<NavigationItem> items,
      }) {
        return PillExpandBottomNav(
          selectedIndex: currentIndex,
          onItemSelected: onIndexChanged,
        );
      },
    ),
    NavigationDesignMeta(
      id: 'design_03',
      title: 'Design 03: Liquid Wave',
      description:
          'Continuous morphing liquid wave rising organically around the selected icon with viscous gooey motion and elastic settling.',
      builder: ({
        required BuildContext context,
        required int currentIndex,
        required ValueChanged<int> onIndexChanged,
        required List<NavigationItem> items,
      }) {
        return LiquidWaveNavigationBar(
          selectedIndex: currentIndex,
          onItemSelected: onIndexChanged,
        );
      },
    ),
    NavigationDesignMeta(
      id: 'design_04',
      title: 'Design 04: Inner Wave',
      description:
          'White floating navigation bar with a smooth baby-pink inner wave pocket behind the selected icon.',
      builder: ({
        required BuildContext context,
        required int currentIndex,
        required ValueChanged<int> onIndexChanged,
        required List<NavigationItem> items,
      }) {
        return InnerLiquidNavigationBar(
          selectedIndex: currentIndex,
          onItemSelected: onIndexChanged,
        );
      },
    ),
    NavigationDesignMeta(
      id: 'design_05',
      title: 'Design 05: Top-Cutout',
      description:
          'White capsule navigation bar with a smooth circular notch indented into the top edge at the active tab.',
      builder: ({
        required BuildContext context,
        required int currentIndex,
        required ValueChanged<int> onIndexChanged,
        required List<NavigationItem> items,
      }) {
        return TopCutoutNavigationBar(
          currentIndex: currentIndex,
          onTap: onIndexChanged,
        );
      },
    ),
    NavigationDesignMeta(
      id: 'design_06',
      title: 'Design 06: Liquid Float',
      description:
          'White pill-shaped navigation bar with smooth upward liquid wave and rising baby-pink circular icon and label.',
      builder: ({
        required BuildContext context,
        required int currentIndex,
        required ValueChanged<int> onIndexChanged,
        required List<NavigationItem> items,
      }) {
        return LiquidFloatNavigationBar(
          currentIndex: currentIndex,
          onTap: onIndexChanged,
        );
      },
    ),
    NavigationDesignMeta(
      id: 'design_07',
      title: 'Design 07: Dot Indicator',
      description:
          'Minimal white capsule navigation bar with five outline icons and a smooth gliding baby-pink active dot indicator.',
      builder: ({
        required BuildContext context,
        required int currentIndex,
        required ValueChanged<int> onIndexChanged,
        required List<NavigationItem> items,
      }) {
        return DotIndicatorNavigationBar(
          currentIndex: currentIndex,
          onTap: onIndexChanged,
        );
      },
    ),
  ];
}

// =============================================================================
// Standalone Entry Point & Preview Application
// =============================================================================

void main() {
  runApp(const NavigationPreviewApp());
}

/// Mobile-oriented preview application.
class NavigationPreviewApp extends StatelessWidget {
  final String initialDesignId;

  const NavigationPreviewApp({
    super.key,
    this.initialDesignId = 'design_01',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Animations Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0ECF6),
      ),
      home: MobileViewportPreviewWrapper(
        child: NavigationPreviewScreen(initialDesignId: initialDesignId),
      ),
    );
  }
}

/// Preview-only wrapper that enforces a realistic portrait mobile viewport
/// (~390 x 844 logical pixels) centered horizontally in desktop browsers,
/// while allowing real Android and iOS devices to fill the screen naturally.
class MobileViewportPreviewWrapper extends StatelessWidget {
  final Widget child;

  const MobileViewportPreviewWrapper({
    super.key,
    required this.child,
  });

  /// Reference dimensions for a modern portrait phone (e.g. iPhone 14/15, 390x844).
  static const double mobileWidth = 390.0;
  static const double mobileHeight = 844.0;
  static const double mobileCornerRadius = 28.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // On real mobile devices or mobile-sized viewports (portrait phones are <= 500 px wide):
        if (screenWidth <= 500) {
          return child;
        }

        // On desktop browsers / wide viewports: constrain to portrait mobile viewport (390 x 844)
        // and center horizontally against a neutral desktop canvas with subtle rounded screen corners (28 px).
        final targetWidth = math.min(mobileWidth, screenWidth);
        final targetHeight = math.min(mobileHeight, screenHeight);

        return Scaffold(
          backgroundColor: const Color(0xFF18171C),
          body: Center(
            child: SizedBox(
              width: targetWidth,
              height: targetHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mobileCornerRadius),
                clipBehavior: Clip.antiAlias,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: Size(targetWidth, targetHeight),
                    padding: EdgeInsets.zero,
                    viewInsets: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Full-screen mobile preview screen supporting both Design 01 and Design 02.
///
/// Features:
/// - Screen background fills the entire available mobile viewport in `#F0ECF6`.
/// - Sleek segmented design selector pill at the top of the mobile screen.
/// - Centered decorative pookie ribbon 🎀, title, and subtitle matching the active design.
/// - Seamless bottom navigation rendering for the selected design.
class NavigationPreviewScreen extends StatefulWidget {
  final String initialDesignId;

  const NavigationPreviewScreen({
    super.key,
    this.initialDesignId = 'design_01',
  });

  @override
  State<NavigationPreviewScreen> createState() =>
      _NavigationPreviewScreenState();
}

class _NavigationPreviewScreenState extends State<NavigationPreviewScreen> {
  late String _activeDesignId;
  int _design01Index = 0;
  int _design02Index = 0;
  int _design03Index = 0;
  int _design04Index = 0;
  int _design05Index = 0;
  int _design06Index = 0;
  int _design07Index = 0;

  final List<Design01NavItem> _design01Items = Design01NavItem.defaultItems;
  final List<PillNavItem> _design02Items = PillNavItem.defaultItems;
  final List<LiquidNavItem> _design03Items = LiquidNavItem.defaultItems;
  final List<InnerLiquidNavItem> _design04Items =
      InnerLiquidNavItem.defaultItems;
  final List<TopCutoutNavItem> _design05Items = TopCutoutNavItem.defaultItems;
  final List<LiquidFloatNavItem> _design06Items =
      LiquidFloatNavItem.defaultItems;
  final List<DotIndicatorNavItem> _design07Items =
      DotIndicatorNavItem.defaultItems;

  @override
  void initState() {
    super.initState();
    _activeDesignId = widget.initialDesignId;
  }

  void _onDesign01Selected(int index) {
    if (index >= 0 && index < _design01Items.length) {
      setState(() {
        _design01Index = index;
      });
    }
  }

  void _onDesign02Selected(int index) {
    if (index >= 0 && index < _design02Items.length) {
      setState(() {
        _design02Index = index;
      });
    }
  }

  void _onDesign03Selected(int index) {
    if (index >= 0 && index < _design03Items.length) {
      setState(() {
        _design03Index = index;
      });
    }
  }

  void _onDesign04Selected(int index) {
    if (index >= 0 && index < _design04Items.length) {
      setState(() {
        _design04Index = index;
      });
    }
  }

  void _onDesign05Selected(int index) {
    if (index >= 0 && index < _design05Items.length) {
      setState(() {
        _design05Index = index;
      });
    }
  }

  void _onDesign06Selected(int index) {
    if (index >= 0 && index < _design06Items.length) {
      setState(() {
        _design06Index = index;
      });
    }
  }

  void _onDesign07Selected(int index) {
    if (index >= 0 && index < _design07Items.length) {
      setState(() {
        _design07Index = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesign01 = _activeDesignId == 'design_01';
    final isDesign02 = _activeDesignId == 'design_02';
    final isDesign03 = _activeDesignId == 'design_03';
    final isDesign04 = _activeDesignId == 'design_04';
    final isDesign05 = _activeDesignId == 'design_05';
    final isDesign06 = _activeDesignId == 'design_06';
    final isDesign07 = _activeDesignId == 'design_07';

    final String titleText;
    final String subtitleText;
    final double contentBottomOffset;

    if (isDesign07) {
      titleText = 'Design 07';
      subtitleText = 'Minimal Dot Navigation';
      contentBottomOffset = 88.0;
    } else if (isDesign06) {
      titleText = 'Design 06';
      subtitleText = 'Liquid Float';
      contentBottomOffset = 110.0;
    } else if (isDesign05) {
      titleText = 'Design 05';
      subtitleText = 'Top-Cutout Navigation';
      contentBottomOffset = 116.0;
    } else if (isDesign04) {
      titleText = 'Design 04';
      subtitleText = 'Circle with Wave Animation';
      contentBottomOffset = 96.0;
    } else if (isDesign03) {
      titleText = 'Design 03';
      subtitleText = 'Liquid Wave Navigation';
      contentBottomOffset = 96.0;
    } else if (isDesign02) {
      titleText = 'Design 02';
      subtitleText = 'Pill-Expand Navigation';
      contentBottomOffset = 72.0;
    } else {
      titleText = 'Design 01';
      subtitleText = 'Minimal Circle Navigation';
      contentBottomOffset = 92.0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0ECF6),
      body: Stack(
        children: [
          // -----------------------------------------------------------------
          // 0. Top Design Selector Toggle (2 Lines with Even Spacing)
          // -----------------------------------------------------------------
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4DFEC),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDesignToggleItem(
                              id: 'design_01',
                              label: '01 Circle',
                              isSelected: isDesign01,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: _buildDesignToggleItem(
                              id: 'design_02',
                              label: '02 Pill',
                              isSelected: isDesign02,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: _buildDesignToggleItem(
                              id: 'design_03',
                              label: '03 Liquid',
                              isSelected: isDesign03,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: _buildDesignToggleItem(
                              id: 'design_04',
                              label: '04 Inner',
                              isSelected: isDesign04,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDesignToggleItem(
                              id: 'design_05',
                              label: '05 Cutout',
                              isSelected: isDesign05,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: _buildDesignToggleItem(
                              id: 'design_06',
                              label: '06 Float',
                              isSelected: isDesign06,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: _buildDesignToggleItem(
                              id: 'design_07',
                              label: '07 Dot',
                              isSelected: isDesign07,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // -----------------------------------------------------------------
          // 1. Centered Title & Ribbon: Vertically & Horizontally centered
          // -----------------------------------------------------------------
          Positioned.fill(
            bottom: contentBottomOffset,
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PookieRibbon(
                      width: 30.0,
                      height: 24.0,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      titleText,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF69636A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      subtitleText,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF89828D),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // -----------------------------------------------------------------
          // 2. Bottom Navigation per Active Design
          // -----------------------------------------------------------------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: isDesign07
                ? DotIndicatorNavigationBar(
                    currentIndex: _design07Index,
                    onTap: _onDesign07Selected,
                    items: _design07Items,
                  )
                : isDesign06
                ? LiquidFloatNavigationBar(
                    currentIndex: _design06Index,
                    onTap: _onDesign06Selected,
                    items: _design06Items,
                  )
                : isDesign05
                ? TopCutoutNavigationBar(
                    currentIndex: _design05Index,
                    onTap: _onDesign05Selected,
                    items: _design05Items,
                  )
                : isDesign04
                    ? InnerLiquidNavigationBar(
                    selectedIndex: _design04Index,
                    onItemSelected: _onDesign04Selected,
                    items: _design04Items,
                  )
                : isDesign03
                    ? LiquidWaveNavigationBar(
                        selectedIndex: _design03Index,
                        onItemSelected: _onDesign03Selected,
                        items: _design03Items,
                      )
                : isDesign02
                    ? PillExpandBottomNav(
                        selectedIndex: _design02Index,
                        onItemSelected: _onDesign02Selected,
                        items: _design02Items,
                      )
                    : MinimalCircleBottomNav(
                        selectedIndex: _design01Index,
                        onItemSelected: _onDesign01Selected,
                        items: _design01Items,
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignToggleItem({
    required String id,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (_activeDesignId != id) {
          setState(() {
            _activeDesignId = id;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7A6882).withValues(alpha: 0.12),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color:
                isSelected ? const Color(0xFFE83280) : const Color(0xFF858087),
          ),
        ),
      ),
    );
  }
}

/// Elegant, delicate decorative baby-pink bow accent for Design 01.
///
/// Features smooth vector curves with two symmetrical loops, two flowing
/// swallowtail ribbon tails, and a rounded center knot.
class PookieRibbon extends StatelessWidget {
  final double width;
  final double height;
  final Color ribbonColor;
  final Color accentColor;

  const PookieRibbon({
    super.key,
    this.width = 30.0,
    this.height = 24.0,
    this.ribbonColor = const Color(0xFFF5A7C8),
    this.accentColor = const Color(0xFFE58EB0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _PookieRibbonPainter(
          ribbonColor: ribbonColor,
          accentColor: accentColor,
        ),
      ),
    );
  }
}

class _PookieRibbonPainter extends CustomPainter {
  final Color ribbonColor;
  final Color accentColor;

  const _PookieRibbonPainter({
    required this.ribbonColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 32.0;
    final scaleY = size.height / 24.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    final fillPaint = Paint()
      ..color = ribbonColor
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final knotPaint = Paint()
      ..color = Color.lerp(ribbonColor, accentColor, 0.35)!
      ..style = PaintingStyle.fill;

    // -------------------------------------------------------------------------
    // 1. Ribbon Tails (Back layer)
    // -------------------------------------------------------------------------
    // Left Tail
    final leftTail = Path()
      ..moveTo(14.0, 10.5)
      ..cubicTo(12.5, 14.5, 9.5, 18.5, 7.5, 22.5)
      ..lineTo(10.5, 20.2)
      ..lineTo(13.2, 21.6)
      ..cubicTo(14.2, 17.5, 14.8, 14.0, 15.2, 11.0)
      ..close();
    canvas.drawPath(leftTail, fillPaint);
    canvas.drawPath(leftTail, outlinePaint);

    // Right Tail (Mirror)
    final rightTail = Path()
      ..moveTo(18.0, 10.5)
      ..cubicTo(19.5, 14.5, 22.5, 18.5, 24.5, 22.5)
      ..lineTo(21.5, 20.2)
      ..lineTo(18.8, 21.6)
      ..cubicTo(17.8, 17.5, 17.2, 14.0, 16.8, 11.0)
      ..close();
    canvas.drawPath(rightTail, fillPaint);
    canvas.drawPath(rightTail, outlinePaint);

    // -------------------------------------------------------------------------
    // 2. Ribbon Loops (Middle layer)
    // -------------------------------------------------------------------------
    // Left Loop
    final leftLoop = Path()
      ..moveTo(14.0, 8.5)
      ..cubicTo(9.5, 2.5, 3.8, 3.2, 2.2, 6.8)
      ..cubicTo(1.2, 9.2, 3.0, 12.2, 5.8, 12.5)
      ..cubicTo(9.2, 12.8, 12.8, 10.5, 14.0, 9.2)
      ..close();
    canvas.drawPath(leftLoop, fillPaint);
    canvas.drawPath(leftLoop, outlinePaint);

    // Left Loop Inner Crease
    final leftCrease = Path()
      ..moveTo(13.5, 9.0)
      ..cubicTo(10.0, 7.5, 6.0, 7.5, 4.5, 8.5);
    canvas.drawPath(
      leftCrease,
      Paint()
        ..color = accentColor.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    // Right Loop (Mirror)
    final rightLoop = Path()
      ..moveTo(18.0, 8.5)
      ..cubicTo(22.5, 2.5, 28.2, 3.2, 29.8, 6.8)
      ..cubicTo(30.8, 9.2, 29.0, 12.2, 26.2, 12.5)
      ..cubicTo(22.8, 12.8, 19.2, 10.5, 18.0, 9.2)
      ..close();
    canvas.drawPath(rightLoop, fillPaint);
    canvas.drawPath(rightLoop, outlinePaint);

    // Right Loop Inner Crease
    final rightCrease = Path()
      ..moveTo(18.5, 9.0)
      ..cubicTo(22.0, 7.5, 26.0, 7.5, 27.5, 8.5);
    canvas.drawPath(
      rightCrease,
      Paint()
        ..color = accentColor.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    // -------------------------------------------------------------------------
    // 3. Center Knot (Front layer)
    // -------------------------------------------------------------------------
    final knotRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(16.0, 9.0), width: 5.8, height: 6.4),
      const Radius.circular(2.8),
    );
    canvas.drawRRect(knotRRect, knotPaint);
    canvas.drawRRect(knotRRect, outlinePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PookieRibbonPainter oldDelegate) {
    return oldDelegate.ribbonColor != ribbonColor ||
        oldDelegate.accentColor != accentColor;
  }
}
