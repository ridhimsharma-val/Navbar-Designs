import 'package:flutter/material.dart';
import '../../preview/navigation_preview.dart'
    show MobileViewportPreviewWrapper, PookieRibbon;
import 'top_cutout_nav_item.dart';
import 'top_cutout_navigation.dart';

/// Standalone entry point for Design 05 preview.
void main() {
  runApp(const Design05PreviewApp());
}

/// Standalone preview application for Design 05: Top-Cutout Navigation.
class Design05PreviewApp extends StatelessWidget {
  const Design05PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design 05: Top-Cutout Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0ECF6),
      ),
      home: const MobileViewportPreviewWrapper(
        child: Design05PreviewScreen(),
      ),
    );
  }
}

/// Standalone mobile preview screen for Design 05: Top-Cutout Navigation.
class Design05PreviewScreen extends StatefulWidget {
  const Design05PreviewScreen({super.key});

  @override
  State<Design05PreviewScreen> createState() => _Design05PreviewScreenState();
}

class _Design05PreviewScreenState extends State<Design05PreviewScreen> {
  int _currentIndex = 0;

  final List<TopCutoutNavItem> _items = TopCutoutNavItem.defaultItems;

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
            bottom: 116.0,
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
                      'Design 05',
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
                      'Top-Cutout Navigation',
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

          // 2. Top-Cutout Navigation Bar anchored at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TopCutoutNavigationBar(
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
