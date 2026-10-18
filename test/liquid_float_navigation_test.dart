import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../designs/design_06/design_06_preview.dart';
import '../designs/design_06/liquid_float_navigation.dart';
import '../preview/navigation_preview.dart';

void main() {
  group('LiquidFloatNavigationBar Tests', () {
    testWidgets('renders all 5 items with correct initial active state and colors',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LiquidFloatNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      // Verify all 5 items have accessible semantics
      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label,
          );

      expect(semanticsFor('Home'), findsWidgets);
      expect(semanticsFor('Search'), findsWidgets);
      expect(semanticsFor('Likes'), findsWidgets);
      expect(semanticsFor('Notifications'), findsWidgets);
      expect(semanticsFor('Profile'), findsWidgets);

      // Verify all 5 icons are present
      expect(find.byIcon(Icons.home_outlined), findsWidgets);
      expect(find.byIcon(Icons.search_rounded), findsWidgets);
      expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
      expect(find.byIcon(Icons.notifications_none_rounded), findsWidgets);
      expect(find.byIcon(Icons.person_outline_rounded), findsWidgets);

      // Verify all 5 labels are visible
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Search'), findsWidgets);
      expect(find.text('Likes'), findsWidgets);
      expect(find.text('Notifications'), findsWidgets);
      expect(find.text('Profile'), findsWidgets);

      // Verify CustomPaint is rendered for the notched bar
      expect(find.byType(CustomPaint), findsWidgets);

      // Verify the raised pink circle exists
      final circleFinder =
          find.byKey(const ValueKey('liquid_float_raised_circle'));
      expect(circleFinder, findsOneWidget);
    });

    testWidgets('raised pink circle and active label are styled and positioned properly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LiquidFloatNavigationBar(
              currentIndex: 1, // Search active
            ),
          ),
        ),
      );

      // Verify raised circle container
      final circleFinder =
          find.byKey(const ValueKey('liquid_float_raised_circle'));
      expect(circleFinder, findsOneWidget);

      final container = tester.widget<Container>(circleFinder);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, const Color(0xFFEC3E8D));
      expect(decoration?.shape, BoxShape.circle);
      expect(container.constraints?.maxWidth, 64.0);

      // Search label should be rendered in pink with FontWeight.w600
      final searchLabels = tester.widgetList<Text>(find.text('Search')).toList();
      final activeLabel = searchLabels.firstWhere(
        (text) => text.style?.color == const Color(0xFFEC3E8D),
      );
      expect(activeLabel.style?.fontWeight, FontWeight.w600);
      expect(activeLabel.style?.fontSize, 14.0);

      // Inactive label (Home) should be rendered in gray with FontWeight.normal
      final homeLabels = tester.widgetList<Text>(find.text('Home')).toList();
      final inactiveLabel = homeLabels.firstWhere(
        (text) => text.style?.color == const Color(0xFF858087),
      );
      expect(inactiveLabel.style?.fontWeight, FontWeight.normal);
      expect(inactiveLabel.style?.fontSize, 13.5);
    });

    testWidgets(
        'smoothly transitions circle, notch, and labels across all 5 tabs and in reverse',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: LiquidFloatNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label && w.properties.button == true,
          );

      // 1. Initial index 0
      expect(selectedIndex, 0);

      // 2. Tap Search (index 1)
      await tester.tap(semanticsFor('Search'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpAndSettle();
      expect(selectedIndex, 1);

      // 3. Tap Likes (index 2)
      await tester.tap(semanticsFor('Likes'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(selectedIndex, 2);

      // 4. Tap Notifications (index 3)
      await tester.tap(semanticsFor('Notifications'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(selectedIndex, 3);

      // 5. Tap Profile (index 4)
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(selectedIndex, 4);

      // 6. Tap directly back to Home (index 0) from Profile (index 4)
      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpAndSettle();
      expect(selectedIndex, 0);
    });

    testWidgets('respects minimum touch target of 44x44 logical pixels',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LiquidFloatNavigationBar(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      final inkWells = find.byType(InkWell);
      expect(inkWells, findsNWidgets(5));

      for (final element in inkWells.evaluate()) {
        final renderBox = element.renderObject as RenderBox?;
        if (renderBox != null) {
          expect(renderBox.size.width >= 44.0, isTrue);
          expect(renderBox.size.height >= 44.0, isTrue);
        }
      }
    });

    testWidgets('handles rapid successive taps without errors or jumps',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: LiquidFloatNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label && w.properties.button == true,
          );

      await tester.tap(semanticsFor('Search'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(semanticsFor('Notifications'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(semanticsFor('Likes'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
    });

    test('LiquidFloatBarPainter buildBarPath creates a pill bar with shallow wave around waveX', () {
      const painter = LiquidFloatBarPainter(
        waveX: 100.0,
        barTop: 14.0,
        barHeight: 86.0,
        bottomInset: 0.0,
        waveWidth: 104.0,
        waveRise: 12.0,
        cornerRadius: 32.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.black12,
      );

      final path = painter.buildBarPath(const Size(390.0, 100.0));
      final bounds = path.getBounds();
      expect(bounds.width, 390.0);
      expect(bounds.top, 2.0); // 14.0 - 12.0 waveRise
      expect(bounds.bottom, 100.0);

      // Point at wave crest center (100, 5) should be inside the white wave
      expect(path.contains(const Offset(100.0, 5.0)), isTrue);
      // Point at (20, 5) away from wave should be outside the flat bar top
      expect(path.contains(const Offset(20.0, 5.0)), isFalse);
      // Point at (20, 30) inside the bar should be inside
      expect(path.contains(const Offset(20.0, 30.0)), isTrue);
    });

    testWidgets('supports nonadjacent tab switches in both directions with smooth gooey bounce',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: LiquidFloatNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      final circleFinder =
          find.byKey(const ValueKey('liquid_float_raised_circle'));
      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label && w.properties.button == true,
          );

      // Home (0) -> Profile (4) [nonadjacent right]
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 120)); // Mid-flight
      expect(circleFinder, findsOneWidget);
      await tester.pumpAndSettle();
      expect(selectedIndex, 4);

      // Profile (4) -> Search (1) [nonadjacent left]
      await tester.tap(semanticsFor('Search'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 120)); // Mid-flight
      expect(circleFinder, findsOneWidget);
      await tester.pumpAndSettle();
      expect(selectedIndex, 1);

      // Search (1) -> Notifications (3) [nonadjacent right]
      await tester.tap(semanticsFor('Notifications'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(selectedIndex, 3);

      // Notifications (3) -> Home (0) [nonadjacent left]
      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(selectedIndex, 0);
    });

    testWidgets('Design06PreviewScreen displays title, subtitle, ribbon, and bar',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Design06PreviewScreen(),
        ),
      );

      expect(find.text('Design 06'), findsOneWidget);
      expect(find.text('Liquid Float'), findsOneWidget);
      expect(find.byType(LiquidFloatNavigationBar), findsOneWidget);
    });

    testWidgets('NavigationPreviewScreen integrates 06 Float and switches correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavigationPreviewScreen(initialDesignId: 'design_06'),
        ),
      );

      // Verify Design 06 is active
      expect(find.text('Design 06'), findsOneWidget);
      expect(find.text('Liquid Float'), findsOneWidget);
      expect(find.byType(LiquidFloatNavigationBar), findsOneWidget);

      // Verify the top toggle item '06 Float' is present
      expect(find.text('06 Float'), findsOneWidget);

      // Switch to Design 05 Cutout
      await tester.tap(find.text('05 Cutout'));
      await tester.pumpAndSettle();
      expect(find.text('Design 05'), findsOneWidget);

      // Switch back to 06 Float
      await tester.tap(find.text('06 Float'));
      await tester.pumpAndSettle();
      expect(find.text('Design 06'), findsOneWidget);
      expect(find.byType(LiquidFloatNavigationBar), findsOneWidget);
    });
  });
}
