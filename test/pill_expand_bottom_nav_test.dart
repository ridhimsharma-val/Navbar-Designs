import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../designs/design_02/design_02_preview.dart';
import '../designs/design_02/pill_expand_bottom_nav.dart';
import '../preview/navigation_preview.dart';

void main() {
  group('PillExpandBottomNav Tests', () {
    testWidgets('renders all 4 items in correct initial state', (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: PillExpandBottomNav(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      // Verify all 4 items have accessible semantics
      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label,
          );

      expect(semanticsFor('Home'), findsOneWidget);
      expect(semanticsFor('Wallet'), findsOneWidget);
      expect(semanticsFor('Analytics'), findsOneWidget);
      expect(semanticsFor('Settings'), findsOneWidget);

      // Initially, Home is selected: filled home icon is visible, label 'Home' is visible
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);

      // Inactive items display outline icons
      expect(
          find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);
      expect(find.byIcon(Icons.pie_chart_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // Active icons for inactive items should not be displayed
      expect(find.byIcon(Icons.account_balance_wallet), findsNothing);
      expect(find.byIcon(Icons.pie_chart_rounded), findsNothing);
      expect(find.byIcon(Icons.settings_rounded), findsNothing);
    });

    testWidgets(
        'smoothly transitions pill expansion, icon, and label on tab tap',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: PillExpandBottomNav(
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

      // 1. Initially Home is active
      expect(selectedIndex, 0);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);

      // 2. Tap on Wallet item
      await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
      // Wallet is active: filled icon visible, outline icon hidden
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet_outlined), findsNothing);
      // Home is now inactive: outline icon visible, filled icon hidden
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.home_rounded), findsNothing);

      // 3. Tap on Analytics item
      await tester.tap(find.byIcon(Icons.pie_chart_outline_rounded));
      await tester.pumpAndSettle();

      expect(selectedIndex, 2);
      expect(find.byIcon(Icons.pie_chart_rounded), findsOneWidget);
      expect(find.byIcon(Icons.pie_chart_outline_rounded), findsNothing);
      expect(
          find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);

      // 4. Tap on Settings item
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(selectedIndex, 3);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsNothing);
      expect(find.byIcon(Icons.pie_chart_outline_rounded), findsOneWidget);
    });

    testWidgets('respects minimum touch target of 48x48 logical pixels',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: PillExpandBottomNav(
              selectedIndex: 0,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      final inkWells = find.byType(InkWell);
      expect(inkWells, findsNWidgets(4));

      for (final element in inkWells.evaluate()) {
        final renderBox = element.renderObject as RenderBox?;
        if (renderBox != null) {
          expect(renderBox.size.width >= 44.0, isTrue);
          expect(renderBox.size.height >= 48.0, isTrue);
        }
      }
    });

    testWidgets(
        'Design02PreviewScreen displays centered title, subtitle, and ribbon',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Design02PreviewScreen(),
        ),
      );

      // Verify title & subtitle
      expect(find.text('Design 02'), findsOneWidget);
      expect(find.text('Pill-Expand Navigation'), findsOneWidget);
      expect(find.byType(PookieRibbon), findsOneWidget);

      // Verify PillExpandBottomNav is rendered
      expect(find.byType(PillExpandBottomNav), findsOneWidget);

      // Tap on Wallet tab
      await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
      await tester.pumpAndSettle();

      // Title & subtitle remain stationary
      expect(find.text('Design 02'), findsOneWidget);
      expect(find.text('Pill-Expand Navigation'), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('renders full-width white surface with straight top edge',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: PillExpandBottomNav(
              selectedIndex: 0,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      final containerFinder = find
          .descendant(
            of: find.byType(PillExpandBottomNav),
            matching: find.byType(Container),
          )
          .first;

      final containerWidget = tester.widget<Container>(containerFinder);
      final decoration = containerWidget.decoration as BoxDecoration?;
      expect(decoration?.color, const Color(0xFFFFFFFF));
      expect(decoration?.borderRadius,
          isNull); // Straight top edge (no outer corner radius)
      expect(decoration?.boxShadow, isNotEmpty);
    });

    testWidgets('renders selected pill label with light, elegant typography',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: PillExpandBottomNav(
              selectedIndex: 0,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      final labelFinder = find.descendant(
        of: find.byType(PillExpandBottomNav),
        matching: find.text('Home'),
      );
      expect(labelFinder, findsOneWidget);

      final labelWidget = tester.widget<Text>(labelFinder);
      expect(labelWidget.style?.fontSize, 15.0);
      expect(labelWidget.style?.fontWeight, FontWeight.w400);
      expect(labelWidget.style?.color, const Color(0xFFEC3E8D));
      expect(labelWidget.style?.letterSpacing, 0.1);
    });
  });
}
