// This is a basic Flutter widget test for the Game Hub app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:game_hub/main.dart';

void main() {
  testWidgets('Game Hub app', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Navigate to home screen (splash screen redirects automatically)
    await tester.pumpAndSettle();

    // Verify that the app displays the home screen title
    expect(find.text('My Games'), findsOneWidget);

    // Verify that featured games section is present
    expect(find.text('Featured'), findsOneWidget);

    // Verify that newest games section is present  
    expect(find.text('Newest Games'), findsOneWidget);
  });
}
