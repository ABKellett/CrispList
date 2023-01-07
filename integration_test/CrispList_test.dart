import 'package:capstone_app/screens/home/home.dart';
import 'package:capstone_app/screens/list/item_detail.dart';
import 'package:capstone_app/screens/list/list_page.dart';
import 'package:capstone_app/screens/meals/meal_page.dart';
import 'package:capstone_app/screens/tracker/tracker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized;
  testWidgets('success test example', (tester) async {
    expect(2 + 2, equals(4));
  });

  testWidgets("Navigation Bar: Navigate to each page",
      (WidgetTester tester) async {
    await tester.pumpWidget(Home());

    await tester.tap(find.byIcon(Icons.set_meal_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_note));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.list_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(ListPage), findsOneWidget);
  });

  testWidgets("List Page gamut (create, edit, and delete list items)",
      (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    //Verify list empty, no list tiles.
    expect(find.byType(ListTile), findsNothing);
    //Add button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    //Verify correct page.
    expect(find.byType(ItemDetail), findsOneWidget);

    final String Txt = "hello";

    await tester.enterText(find.byType(TextFormField), Txt);
    //"Save"
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    //Verify new list tile now exists on page.
    expect(find.byType(ListTile), findsOneWidget);
    //Slide widget and select delete option.
    await tester.drag(find.byType(ListTile), Offset(50, 0));
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    //verify list tile disappere post-delete.
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets("Meal Page gamut (create, edit, and delete Meal items)",
      (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    //Navigate to Meal page
    await tester.tap(find.byIcon(Icons.set_meal_outlined));
    await tester.pumpAndSettle();
    //Verify empty Meals list page.
    expect(find.byType(MealPage), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);

    final String Txt = "meal";
    //Add
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    //Verify correct page nav.
    expect(find.byType(ItemDetail), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), Txt);
    //"Save"
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    //Verify new list tile now exists.
    expect(find.byType(ListTile), findsOneWidget);
    //Slide widget and select delete option
    await tester.drag(find.byType(ListTile), Offset(50, 0));
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    //Verify delete.
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets("Tracker Page gamut (create, edit, and delete Meal items)",
      (WidgetTester tester) async {
    await tester.pumpWidget(Home());
    //Navigate to Tracker page
    await tester.tap(find.byIcon(Icons.edit_note));
    await tester.pumpAndSettle();
    //Verify empty page
    expect(find.byType(TrackerPage), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);

    final String Txt = "Tracker";
    //Add button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    //Verify correct page
    expect(find.byType(ItemDetail), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), Txt);
    //"Save"
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    //Verify new list tile now exists.
    expect(find.byType(ListTile), findsOneWidget);
    //Slide widget and select delete option
    await tester.drag(find.byType(ListTile), Offset(50, 0));
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    //Verify list tile disappeared.
    expect(find.byType(ListTile), findsNothing);
  });
}
