import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pukaar/app/app.dart';

void main() {
  testWidgets('Pukaar shows splash loading', (WidgetTester tester) async {
    await tester.pumpWidget(const PukaarApp());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
