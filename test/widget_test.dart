import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_tracker/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // bangun app trigger frame
    await tester.pumpWidget(FitnessTrackerApp());
    // verif counter start dr 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap '+' triger frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // verif counter di increment
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
