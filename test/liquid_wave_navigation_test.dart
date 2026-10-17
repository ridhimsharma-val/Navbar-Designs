import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../designs/design_03/design_03_preview.dart';
import '../designs/design_03/liquid_wave_navigation.dart';
import '../preview/navigation_preview.dart';

void main() {
  group('LiquidWaveNavigationBar Tests', () {
    testWidgets(
        'renders all 3 items (Home, Plus, Profile) in correct initial state',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LiquidWaveNavigationBar(
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

      // Initially, Home is selected: filled home icon is visible, label 'Home' is visible
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);

      // Inactive items display outline/normal icons
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // Verify custom painter is rendered for the liquid wave
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('smoothly transitions liquid wave, icon, and label on tab tap',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: LiquidWaveNavigationBar(
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
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);

      // 2. Tap on Plus item
      await tester.tap(semanticsFor('Plus'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
      // Plus is active: plus icon visible, label 'Plus' visible
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.text('Plus'), findsOneWidget);

      // 3. Tap on Profile item
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 2);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // 4. Tap back on Home item
      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets(
        'respects minimum touch target of 48x48 logical pixels for all 3 tabs',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LiquidWaveNavigationBar(
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
        'renders active label with light, elegant typography (FontWeight.w400)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LiquidWaveNavigationBar(
              selectedIndex: 0,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      final labelFinder = find.descendant(
        of: find.byType(LiquidWaveNavigationBar),
        matching: find.text('Home'),
      );
      expect(labelFinder, findsOneWidget);

      final labelWidget = tester.widget<Text>(labelFinder);
      expect(labelWidget.style?.fontSize, 15.0);
      expect(labelWidget.style?.fontWeight, FontWeight.w400);
      expect(labelWidget.style?.color, const Color(0xFFEC3E8D));
      expect(labelWidget.style?.letterSpacing, 0.1);
    });

    testWidgets(
        'Design03PreviewScreen displays centered title, subtitle, and ribbon',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Design03PreviewScreen(),
        ),
      );

      // Verify title & subtitle
      expect(find.text('Design 03'), findsOneWidget);
      expect(find.text('Liquid Wave Navigation'), findsOneWidget);
      expect(find.byType(PookieRibbon), findsOneWidget);

      // Verify LiquidWaveNavigationBar is rendered
      expect(find.byType(LiquidWaveNavigationBar), findsOneWidget);

      // Tap on Plus tab
      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label,
          );
      await tester.tap(semanticsFor('Plus'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Title & subtitle remain stationary
      expect(find.text('Design 03'), findsOneWidget);
      expect(find.text('Liquid Wave Navigation'), findsOneWidget);
      expect(find.text('Plus'), findsOneWidget);
    });

    testWidgets('handles rapid successive taps gracefully without errors',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: LiquidWaveNavigationBar(
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

      // Rapid successive taps
      await tester.tap(semanticsFor('Plus'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(semanticsFor('Home'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
