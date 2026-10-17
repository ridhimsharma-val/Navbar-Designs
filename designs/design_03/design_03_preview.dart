import 'package:flutter/material.dart';
import '../../preview/navigation_preview.dart'
    show MobileViewportPreviewWrapper, PookieRibbon;
import 'liquid_nav_item.dart';
import 'liquid_wave_navigation.dart';

/// Standalone entry point for Design 03 preview.
void main() {
  runApp(const Design03PreviewApp());
}

/// Standalone preview application for Design 03: Liquid Wave Navigation.
class Design03PreviewApp extends StatelessWidget {
  const Design03PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design 03: Liquid Wave Nav',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0ECF6),
      ),
      home: const MobileViewportPreviewWrapper(
        child: Design03PreviewScreen(),
      ),
    );
  }
}

/// Standalone mobile preview screen for Design 03: Liquid Wave Navigation.
///
/// Features:
/// - Screen background fills the entire mobile viewport in `#F0ECF6`.
/// - Centered delicate baby-pink pookie ribbon 🎀, `Design 03` title, and
///   `Liquid Wave Navigation` subtitle.
/// - Anchored [LiquidWaveNavigationBar] along the bottom with fluid wave animation.
class Design03PreviewScreen extends StatefulWidget {
  const Design03PreviewScreen({super.key});

  @override
  State<Design03PreviewScreen> createState() => _Design03PreviewScreenState();
}

class _Design03PreviewScreenState extends State<Design03PreviewScreen> {
  int _selectedIndex = 0;

  final List<LiquidNavItem> _items = LiquidNavItem.defaultItems;

  void _onItemSelected(int index) {
    if (index >= 0 && index < _items.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0ECF6),
      body: Stack(
        children: [
          // -----------------------------------------------------------------
          // 1. Centered Title, Subtitle, and Decorative Ribbon Accent
          // -----------------------------------------------------------------
          const Positioned.fill(
            bottom: 96.0, // barHeight (72) + waveHeight (24)
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PookieRibbon(
                      width: 30.0,
                      height: 24.0,
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Design 03',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF69636A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Text(
                      'Liquid Wave Navigation',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
          // 2. Liquid Wave Navigation Bar anchored to the bottom
          // -----------------------------------------------------------------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LiquidWaveNavigationBar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
              items: _items,
            ),
          ),
        ],
      ),
    );
  }
}
