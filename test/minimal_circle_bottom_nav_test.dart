import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../designs/design_01/minimal_circle_bottom_nav.dart';
import '../designs/design_01/nav_item.dart';
import '../preview/navigation_preview.dart';

void main() {
  group('MinimalCircleBottomNav Tests', () {
    testWidgets(
        'renders all 4 tabs with icons and accessible semantics, no visible text labels',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MinimalCircleBottomNav(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      // Verify that no visible Text widgets are rendered in the navigation bar
      expect(
          find.descendant(
              of: find.byType(MinimalCircleBottomNav),
              matching: find.byType(Text)),
          findsNothing);

      // Verify accessible semantics for screen readers
      expect(find.bySemanticsLabel('Home'), findsOneWidget);
      expect(find.bySemanticsLabel('Search'), findsOneWidget);
      expect(find.bySemanticsLabel('History'), findsOneWidget);
      expect(find.bySemanticsLabel('Profile'), findsOneWidget);

      // Verify initial selected icon is filled home
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      // Verify inactive icons are present
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets('triggers onItemSelected and transitions when tab is tapped',
        (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: MinimalCircleBottomNav(
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

      // Initial state: Home selected
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);

      // Tap on the Search tab via its icon
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
      // Verify active search icon is BoldSearchIcon
      expect(find.byType(BoldSearchIcon), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);

      // Tap on History tab via its icon
      await tester.tap(find.byIcon(Icons.access_time_rounded));
      await tester.pumpAndSettle();

      expect(selectedIndex, 2);
      expect(find.byIcon(Icons.watch_later_rounded), findsOneWidget);
      // Search icon is now inactive outline (Icons.search_rounded)
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);

      // Tap on Profile tab via its icon
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pumpAndSettle();

      expect(selectedIndex, 3);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('respects minimum touch target of 44x44', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MinimalCircleBottomNav(
              selectedIndex: 0,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      // Find all tab ink responses
      final inkResponses = find.byType(InkResponse);
      expect(inkResponses, findsNWidgets(4));

      for (final element in inkResponses.evaluate()) {
        final renderBox = element.renderObject as RenderBox?;
        if (renderBox != null) {
          expect(renderBox.size.width >= 44.0, isTrue);
          expect(renderBox.size.height >= 44.0, isTrue);
        }
      }
    });

    testWidgets(
        'NavigationPreviewScreen displays stationary Design 01 centered title',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavigationPreviewScreen(),
        ),
      );

      // Verify the centered "Design 01" title is present
      final titleFinder = find.text('Design 01');
      expect(titleFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(titleFinder);
      expect(textWidget.style?.fontSize, 24.0);
      expect(textWidget.style?.fontWeight, FontWeight.w600);
      expect(textWidget.style?.color, const Color(0xFF69636A));

      // Verify PookieRibbon and subtitle are present
      expect(find.byType(PookieRibbon), findsOneWidget);
      expect(find.text('Minimal Circle Navigation'), findsOneWidget);

      // Tap on the Search tab (index 1)
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      // Verify title is still stationary and present
      expect(find.text('Design 01'), findsOneWidget);
      expect(find.text('Minimal Circle Navigation'), findsOneWidget);
      expect(find.byType(PookieRibbon), findsOneWidget);

      // Tap on the Profile tab (index 3)
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pumpAndSettle();

      // Verify title remains unchanged
      expect(find.text('Design 01'), findsOneWidget);
      expect(find.text('Minimal Circle Navigation'), findsOneWidget);
      expect(find.byType(PookieRibbon), findsOneWidget);
    });

    testWidgets(
        'NavigationPreviewApp constrains viewport to 390 width on desktop',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const NavigationPreviewApp(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Design 01'), findsOneWidget);
      expect(find.byType(MinimalCircleBottomNav), findsOneWidget);

      // Verify the bottom nav bar is constrained to 390 logical pixels, not 1200
      final navRenderBox =
          tester.renderObject(find.byType(MinimalCircleBottomNav)) as RenderBox;
      expect(navRenderBox.size.width, 390.0);
    });
  });
}
