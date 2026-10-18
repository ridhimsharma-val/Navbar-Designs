import 'package:flutter/material.dart';
import '../../preview/navigation_preview.dart'
    show MobileViewportPreviewWrapper, PookieRibbon;
import 'liquid_float_navigation.dart';

/// Standalone entry point for Design 06 preview.
void main() {
  runApp(const Design06PreviewApp());
}

/// Standalone preview application for Design 06: Liquid Float Navigation.
class Design06PreviewApp extends StatelessWidget {
  const Design06PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design 06: Liquid Float Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0ECF6),
      ),
      home: const MobileViewportPreviewWrapper(
        child: Design06PreviewScreen(),
      ),
    );
  }
}

/// Standalone mobile preview screen for Design 06: Liquid Float Navigation.
class Design06PreviewScreen extends StatefulWidget {
  const Design06PreviewScreen({super.key});

  @override
  State<Design06PreviewScreen> createState() => _Design06PreviewScreenState();
}

class _Design06PreviewScreenState extends State<Design06PreviewScreen> {
  int _currentIndex = 0;

  final List<LiquidFloatNavItem> _items = LiquidFloatNavItem.defaultItems;

  void _onTabSelected(int index) {
    if (index >= 0 && index < _items.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0ECF6),
      body: Stack(
        children: [
          // 1. Centered Title, Subtitle, and Decorative Ribbon Accent
          const Positioned.fill(
            bottom: 120.0,
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
                      'Design 06',
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
                      'Liquid Float',
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

          // 2. Liquid Float Navigation Bar anchored at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LiquidFloatNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabSelected,
              items: _items,
            ),
          ),
        ],
      ),
    );
  }
}
