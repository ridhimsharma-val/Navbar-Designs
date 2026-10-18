import 'package:flutter/material.dart';
import '../../preview/navigation_preview.dart'
    show MobileViewportPreviewWrapper, PookieRibbon;
import 'inner_liquid_nav_item.dart';
import 'inner_liquid_navigation.dart';

/// Standalone entry point for Design 04 preview.
void main() {
  runApp(const Design04PreviewApp());
}

/// Standalone preview application for Design 04: Inner Wave Pocket Navigation.
class Design04PreviewApp extends StatelessWidget {
  const Design04PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design 04: Circle with Wave Animation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0ECF6),
      ),
      home: const MobileViewportPreviewWrapper(
        child: Design04PreviewScreen(),
      ),
    );
  }
}

/// Standalone mobile preview screen for Design 04: Inner Wave Pocket Navigation.
class Design04PreviewScreen extends StatefulWidget {
  const Design04PreviewScreen({super.key});

  @override
  State<Design04PreviewScreen> createState() => _Design04PreviewScreenState();
}

class _Design04PreviewScreenState extends State<Design04PreviewScreen> {
  int _selectedIndex = 0;

  final List<InnerLiquidNavItem> _items = InnerLiquidNavItem.defaultItems;

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
                      'Design 04',
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
                      'Circle with Wave Animation',
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

          // 2. Inner Wave Pocket Navigation Bar anchored to the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: InnerLiquidNavigationBar(
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
