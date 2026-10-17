import 'package:flutter/material.dart';
import '../../preview/navigation_preview.dart'
    show MobileViewportPreviewWrapper, PookieRibbon;
import 'pill_expand_bottom_nav.dart';
import 'pill_nav_item.dart';

/// Standalone entry point for Design 02 preview.
void main() {
  runApp(const Design02PreviewApp());
}

/// Standalone preview application for Design 02: Pill-Expand Navigation.
class Design02PreviewApp extends StatelessWidget {
  const Design02PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design 02: Pill-Expand Nav',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0ECF6),
      ),
      home: const MobileViewportPreviewWrapper(
        child: Design02PreviewScreen(),
      ),
    );
  }
}

/// Standalone mobile preview screen for Design 02: Pill-Expand Navigation.
///
/// Features:
/// - Screen background fills the entire mobile viewport in `#F0ECF6`.
/// - Centered decorative pookie ribbon 🎀, `Design 02` title, and `Pill-Expand Navigation` subtitle.
/// - Floating rounded rectangular navigation bar [PillExpandBottomNav] anchored at the bottom.
class Design02PreviewScreen extends StatefulWidget {
  const Design02PreviewScreen({super.key});

  @override
  State<Design02PreviewScreen> createState() => _Design02PreviewScreenState();
}

class _Design02PreviewScreenState extends State<Design02PreviewScreen> {
  int _selectedIndex = 0;

  final List<PillNavItem> _items = PillNavItem.defaultItems;

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
          // 1. Centered Title, Subtitle, and Ribbon Accent
          // -----------------------------------------------------------------
          const Positioned.fill(
            bottom: 72.0,
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
                      'Design 02',
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
                      'Pill-Expand Navigation',
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
          // 2. Floating Bottom Navigation Bar
          // -----------------------------------------------------------------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PillExpandBottomNav(
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
