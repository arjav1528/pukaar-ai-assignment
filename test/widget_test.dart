import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pukaar/modules/home/home_shell.dart';

void main() {
  testWidgets('HomeShell placeholder renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeShell(),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
  });
}
