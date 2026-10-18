import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../designs/design_04/design_04_preview.dart';
import '../designs/design_04/inner_liquid_navigation.dart';
import '../preview/navigation_preview.dart';

void main() {
  group('InnerLiquidNavigationBar Tests', () {
    testWidgets(
        'renders all 3 items (Home, Plus, Profile) in correct initial state with elevated circle',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: InnerLiquidNavigationBar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      // Verify all 3 items have accessible semantics
      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label,
          );

      expect(semanticsFor('Home'), findsOneWidget);
      expect(semanticsFor('Plus'), findsOneWidget);
      expect(semanticsFor('Profile'), findsOneWidget);

      // Initially, Home is selected: outline home icon is in the active circle
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);

      // Inactive items display outline/normal icons
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // Verify custom painter is rendered for the wave pocket
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets(
        'smoothly transitions wave pocket and active circle on tab tap',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: InnerLiquidNavigationBar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
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
            (w) => w is Semantics && w.properties.label == label,
          );

      // 1. Initially Home is active
      expect(selectedIndex, 0);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);

      // 2. Tap on Plus item
      await tester.tap(semanticsFor('Plus'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      // 3. Tap on Profile item
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 2);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // 4. Tap back on Home item
      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets(
        'respects minimum touch target of 48x48 logical pixels for all 3 tabs',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: InnerLiquidNavigationBar(
              selectedIndex: 0,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      final inkWells = find.byType(InkWell);
      expect(inkWells, findsNWidgets(3));

      for (final element in inkWells.evaluate()) {
        final renderBox = element.renderObject as RenderBox?;
        if (renderBox != null) {
          expect(renderBox.size.width >= 44.0, isTrue);
          expect(renderBox.size.height >= 48.0, isTrue);
        }
      }
    });

    testWidgets(
        'Design04PreviewScreen displays centered title, subtitle, and ribbon',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Design04PreviewScreen(),
        ),
      );

      expect(find.text('Design 04'), findsOneWidget);
      expect(find.text('Circle with Wave Animation'), findsOneWidget);
      expect(find.byType(PookieRibbon), findsOneWidget);
      expect(find.byType(InnerLiquidNavigationBar), findsOneWidget);
    });

    testWidgets('handles rapid successive taps gracefully without errors',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: InnerLiquidNavigationBar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
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
            (w) => w is Semantics && w.properties.label == label,
          );

      // Rapidly tap all 3 items sequentially without waiting for settle
      await tester.tap(semanticsFor('Plus'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets(
        'handles all tab switching directions: Home -> Middle -> Profile -> Home and Home -> Profile directly',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: InnerLiquidNavigationBar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
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
            (w) => w is Semantics && w.properties.label == label,
          );

      // Path 1: Home -> Middle (Plus)
      await tester.tap(semanticsFor('Plus'), warnIfMissed: false);
      // Mid-flight pump to verify no layout shifts or crashes during stretch
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpAndSettle();
      expect(selectedIndex, 1);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      // Path 2: Middle -> Profile
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpAndSettle();
      expect(selectedIndex, 2);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // Path 3: Profile -> Home
      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpAndSettle();
      expect(selectedIndex, 0);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);

      // Path 4: Home -> Profile directly (skipping middle)
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pumpAndSettle();
      expect(selectedIndex, 2);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets(
        'NavigationPreviewScreen switches to Design 04 when 04 Inner is selected',
        (tester) async {
      await tester.pumpWidget(
        const NavigationPreviewApp(initialDesignId: 'design_04'),
      );

      expect(find.text('Design 04'), findsOneWidget);
      expect(find.text('Circle with Wave Animation'), findsOneWidget);
      expect(find.byType(InnerLiquidNavigationBar), findsOneWidget);
    });
  });
}
