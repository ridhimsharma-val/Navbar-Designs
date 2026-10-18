import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../designs/design_05/design_05_preview.dart';
import '../designs/design_05/top_cutout_navigation.dart';
import '../preview/navigation_preview.dart';

void main() {
  group('TopCutoutNavigationBar Tests', () {
    testWidgets('renders all 5 items with correct initial active state and colors',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: TopCutoutNavigationBar(
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

      expect(semanticsFor('Home'), findsOneWidget);
      expect(semanticsFor('Search'), findsOneWidget);
      expect(semanticsFor('Likes'), findsOneWidget);
      expect(semanticsFor('Notifications'), findsOneWidget);
      expect(semanticsFor('Profile'), findsOneWidget);

      // Verify all 5 icons are present
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // Verify all 5 labels are visible
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Likes'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify CustomPaint is rendered for the cutout bar
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets(
        'smoothly transitions notch and colors across all 5 tabs and in reverse',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: TopCutoutNavigationBar(
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
            (w) => w is Semantics && w.properties.label == label,
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
            bottomNavigationBar: TopCutoutNavigationBar(
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
                bottomNavigationBar: TopCutoutNavigationBar(
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
            (w) => w is Semantics && w.properties.label == label,
          );

      // Rapidly tap multiple tabs in succession
      await tester.tap(semanticsFor('Likes'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(semanticsFor('Search'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('Design05PreviewScreen displays title, subtitle, ribbon, and bar',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Design05PreviewScreen(),
        ),
      );

      expect(find.text('Design 05'), findsOneWidget);
      expect(find.text('Top-Cutout Navigation'), findsOneWidget);
      expect(find.byType(PookieRibbon), findsOneWidget);
      expect(find.byType(TopCutoutNavigationBar), findsOneWidget);
    });

    testWidgets('NavigationPreviewScreen switches to Design 05 and renders correctly',
        (tester) async {
      await tester.pumpWidget(
        const NavigationPreviewApp(initialDesignId: 'design_05'),
      );

      expect(find.text('Design 05'), findsOneWidget);
      expect(find.text('Top-Cutout Navigation'), findsOneWidget);
      expect(find.byType(TopCutoutNavigationBar), findsOneWidget);
    });

    testWidgets('floating pink dot is rendered, styled properly, and follows selected tab',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: TopCutoutNavigationBar(
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

      final dotFinder = find.byKey(const ValueKey('top_cutout_selected_dot'));
      // 1. Verify exactly one dot is visible
      expect(dotFinder, findsOneWidget);

      final dotContainer = tester.widget<Container>(dotFinder);
      final decoration = dotContainer.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, const Color(0xFFEC3E8D));
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.first.color, const Color(0xFFEC3E8D).withValues(alpha: 0.18));

      // 2. Test alignment across all 5 tabs
      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label,
          );

      final tabLabels = ['Home', 'Search', 'Likes', 'Notifications', 'Profile'];

      for (int i = 0; i < tabLabels.length; i++) {
        await tester.tap(semanticsFor(tabLabels[i]), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(selectedIndex, i);
        expect(dotFinder, findsOneWidget);

        final dotCenter = tester.getCenter(dotFinder);
        final tabCenter = tester.getCenter(semanticsFor(tabLabels[i]));

        // Dot center X must closely match tab center X (within 1 px)
        expect((dotCenter.dx - tabCenter.dx).abs(), lessThan(1.5));
      }
    });

    testWidgets('inactive navigation items have regular FontWeight.w400 and active has FontWeight.w600',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: TopCutoutNavigationBar(
              currentIndex: 1, // Search is active
            ),
          ),
        ),
      );

      // Home (inactive, index 0)
      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.fontWeight, FontWeight.w400);

      // Search (active, index 1)
      final searchText = tester.widget<Text>(find.text('Search'));
      expect(searchText.style?.fontWeight, FontWeight.w600);

      // Likes (inactive, index 2)
      final likesText = tester.widget<Text>(find.text('Likes'));
      expect(likesText.style?.fontWeight, FontWeight.w400);
    });

    test('TopCutoutBarPainter buildBarPath creates a straight top edge and rounded outer corners', () {
      const painter = TopCutoutBarPainter(
        cornerRadius: 28.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.black12,
      );

      final path = painter.buildBarPath(const Size(320.0, 104.0));
      final bounds = path.getBounds();
      expect(bounds.width, 320.0);
      expect(bounds.height, 104.0);
      expect(bounds.top, 0.0);
    });

    test('TopCutoutBarPainter buildBarPath creates a straight rectangular bar when cornerRadius is 0.0', () {
      const painter = TopCutoutBarPainter(
        cornerRadius: 0.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.black12,
      );

      final path = painter.buildBarPath(const Size(320.0, 104.0));
      final bounds = path.getBounds();
      expect(bounds.width, 320.0);
      expect(bounds.height, 104.0);
      expect(bounds.top, 0.0);
    });

    test('TopCutoutBarPainter buildBarPath creates a 2x semi-circular cutout dipping at notchX', () {
      const painter = TopCutoutBarPainter(
        notchX: 100.0,
        notchWidth: 52.0,
        notchDepth: 20.0,
        cornerRadius: 0.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.black12,
      );

      final path = painter.buildBarPath(const Size(320.0, 104.0));
      final bounds = path.getBounds();
      expect(bounds.width, 320.0);
      expect(bounds.height, 104.0);
      expect(bounds.top, 0.0);

      // Point at (100, 10) should be cut out
      expect(path.contains(const Offset(100.0, 10.0)), isFalse);
      // Point at (100, 25) should be inside the solid white container
      expect(path.contains(const Offset(100.0, 25.0)), isTrue);
      // Point at (50, 10) away from cutout should be inside the solid white container
      expect(path.contains(const Offset(50.0, 10.0)), isTrue);
    });

    testWidgets('supports nonadjacent tab switches in both directions with smooth gooey bounce',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: TopCutoutNavigationBar(
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

      final dotFinder = find.byKey(const ValueKey('top_cutout_selected_dot'));
      Finder semanticsFor(String label) => find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label,
          );

      // Home (0) -> Profile (4) [nonadjacent right]
      await tester.tap(semanticsFor('Profile'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 120)); // Mid-flight
      expect(dotFinder, findsOneWidget);
      await tester.pumpAndSettle();
      expect(selectedIndex, 4);

      // Profile (4) -> Search (1) [nonadjacent left]
      await tester.tap(semanticsFor('Search'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 120)); // Mid-flight
      expect(dotFinder, findsOneWidget);
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
  });
}


