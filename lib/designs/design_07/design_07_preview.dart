import 'package:flutter/material.dart';
import '../../preview/navigation_preview.dart'
    show MobileViewportPreviewWrapper, PookieRibbon;
import 'dot_indicator_navigation.dart';

/// Standalone entry point for Design 07 preview.
void main() {
  runApp(const Design07PreviewApp());
}

/// Standalone preview application for Design 07: Dot Indicator Navigation.
class Design07PreviewApp extends StatelessWidget {
  const Design07PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design 07: Dot Indicator Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0ECF6),
      ),
      home: const MobileViewportPreviewWrapper(
        child: Design07PreviewScreen(),
      ),
    );
  }
}

/// Standalone mobile preview screen for Design 07: Dot Indicator Navigation.
class Design07PreviewScreen extends StatefulWidget {
  const Design07PreviewScreen({super.key});

  @override
  State<Design07PreviewScreen> createState() => _Design07PreviewScreenState();
}

class _Design07PreviewScreenState extends State<Design07PreviewScreen> {
  int _currentIndex = 0;

  final List<DotIndicatorNavItem> _items = DotIndicatorNavItem.defaultItems;

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
            bottom: 96.0,
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
                      'Design 07',
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
                      'Minimal Dot Navigation',
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

          // 2. Dot Indicator Navigation Bar positioned at the bottom
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: DotIndicatorNavigationBar(
              currentIndex: _currentIndex,
              items: _items,
              onTap: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
}
