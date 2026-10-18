import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../designs/design_07/design_07_preview.dart';
import '../designs/design_07/dot_indicator_navigation.dart';
import '../preview/navigation_preview.dart';

void main() {
  group('DotIndicatorNavigationBar Tests', () {
    testWidgets('renders all 5 items with correct initial active state and icons',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: DotIndicatorNavigationBar(
              currentIndex: 0,
              items: DotIndicatorNavItem.defaultItems,
            ),
          ),
        ),
      );

      // Verify all 5 semantic items are rendered
      expect(find.byType(DotIndicatorNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // Verify active pink indicator dot is present
      final dotFinder = find.byKey(const ValueKey('dot_indicator_active_dot'));
      expect(dotFinder, findsOneWidget);

      final dotContainer = tester.widget<Container>(
        find.descendant(of: dotFinder, matching: find.byType(Container)),
      );
      final decoration = dotContainer.decoration as BoxDecoration?;
      expect(decoration?.color, const Color(0xFFEC3E8D));
      expect(decoration?.shape, BoxShape.circle);
    });

    testWidgets('active icon is pink and inactive icons are muted gray',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: DotIndicatorNavigationBar(
              currentIndex: 1, // Search is active
              items: DotIndicatorNavItem.defaultItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Search (active) should have pink color
      final searchIcons = tester.widgetList<Icon>(find.byIcon(Icons.search_rounded)).toList();
      final activeSearchIcon = searchIcons.firstWhere(
        (icon) => icon.color == const Color(0xFFEC3E8D),
      );
      expect(activeSearchIcon.color, const Color(0xFFEC3E8D));

      // Home (inactive) should have gray color
      final homeIcons = tester.widgetList<Icon>(find.byIcon(Icons.home_outlined)).toList();
      final inactiveHomeIcon = homeIcons.firstWhere(
        (icon) => icon.color == const Color(0xFF858087),
      );
      expect(inactiveHomeIcon.color, const Color(0xFF858087));
    });

    testWidgets(
        'smoothly transitions dot position across all 5 tabs and in reverse',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: DotIndicatorNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (idx) {
                    setState(() {
                      selectedIndex = idx;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final dotFinder = find.byKey(const ValueKey('dot_indicator_active_dot'));
      final initialPosition = tester.getCenter(dotFinder);

      // Switch to Profile (index 4)
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final midPosition = tester.getCenter(dotFinder);
      expect(midPosition.dx, greaterThan(initialPosition.dx));
      // Dot rises upward into a wave arc (smaller dy in Flutter screen coordinates)
      expect(midPosition.dy, lessThan(initialPosition.dy));

      await tester.pumpAndSettle();
      final profilePosition = tester.getCenter(dotFinder);
      expect(profilePosition.dx, greaterThan(midPosition.dx));
      // Settled back down to resting baseline
      expect(profilePosition.dy, closeTo(initialPosition.dy, 1.0));
      expect(selectedIndex, 4);

      // Switch back to Search (index 1)
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final returnMidPosition = tester.getCenter(dotFinder);
      expect(returnMidPosition.dx, lessThan(profilePosition.dx));
      // Bounces upward like a wave again on return
      expect(returnMidPosition.dy, lessThan(profilePosition.dy));

      await tester.pumpAndSettle();
      final searchPosition = tester.getCenter(dotFinder);
      expect(searchPosition.dx, lessThan(returnMidPosition.dx));
      expect(searchPosition.dy, closeTo(initialPosition.dy, 1.0));
      expect(selectedIndex, 1);
    });

    testWidgets('navbar has straight edge-to-edge layout without side margins',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: DotIndicatorNavigationBar(
              currentIndex: 0,
            ),
          ),
        ),
      );

      final barContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(DotIndicatorNavigationBar),
          matching: find.byType(Container),
        ).first,
      );

      // Verify margin is 0 horizontal
      expect(barContainer.margin, EdgeInsets.zero);

      // Verify straight top border and no pill border radius
      final decoration = barContainer.decoration as BoxDecoration?;
      expect(decoration?.borderRadius, isNull);
      expect(decoration?.border, isA<Border>());
    });

    testWidgets('tapping currently active tab triggers an in-place wave bounce',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: DotIndicatorNavigationBar(
              currentIndex: 2, // Likes tab
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final dotFinder = find.byKey(const ValueKey('dot_indicator_active_dot'));
      final restingPosition = tester.getCenter(dotFinder);

      // Tap the currently active Likes tab
      await tester.tap(find.byIcon(Icons.favorite_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      final bouncePosition = tester.getCenter(dotFinder);
      // X remains centered on the tab, while Y hops upward
      expect(bouncePosition.dx, closeTo(restingPosition.dx, 1.0));
      expect(bouncePosition.dy, lessThan(restingPosition.dy));

      await tester.pumpAndSettle();
      final settledPosition = tester.getCenter(dotFinder);
      expect(settledPosition.dy, closeTo(restingPosition.dy, 1.0));
    });

    testWidgets('respects minimum touch target of 44x44 logical pixels',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: DotIndicatorNavigationBar(
              currentIndex: 0,
            ),
          ),
        ),
      );

      final inkWells = find.byType(InkWell);
      expect(inkWells, findsNWidgets(5));

      for (int i = 0; i < 5; i++) {
        final size = tester.getSize(inkWells.at(i));
        expect(size.width, greaterThanOrEqualTo(44.0));
        expect(size.height, greaterThanOrEqualTo(44.0));
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
                bottomNavigationBar: DotIndicatorNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (idx) => setState(() => selectedIndex = idx),
                ),
              );
            },
          ),
        ),
      );

      // Rapidly tap different tabs
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(find.byIcon(Icons.search_rounded));

      await tester.pumpAndSettle();
      expect(selectedIndex, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Design07PreviewScreen displays title, subtitle, ribbon, and bar',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Design07PreviewScreen(),
        ),
      );

      expect(find.text('Design 07'), findsOneWidget);
      expect(find.text('Minimal Dot Navigation'), findsOneWidget);
      expect(find.byType(PookieRibbon), findsOneWidget);
      expect(find.byType(DotIndicatorNavigationBar), findsOneWidget);
    });

    testWidgets('NavigationPreviewScreen integrates 07 Dot and switches correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavigationPreviewScreen(initialDesignId: 'design_07'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Design 07'), findsOneWidget);
      expect(find.text('Minimal Dot Navigation'), findsOneWidget);
      expect(find.text('07 Dot'), findsOneWidget);
      expect(find.byType(DotIndicatorNavigationBar), findsOneWidget);

      // Switch to Design 06
      await tester.tap(find.text('06 Float'));
      await tester.pumpAndSettle();

      expect(find.text('Design 06'), findsOneWidget);

      // Switch back to 07 Dot
      await tester.tap(find.text('07 Dot'));
      await tester.pumpAndSettle();

      expect(find.text('Design 07'), findsOneWidget);
      expect(find.byType(DotIndicatorNavigationBar), findsOneWidget);
    });
  });
}
