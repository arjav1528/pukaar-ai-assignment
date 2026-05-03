import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pukaar/modules/splash/splash_view.dart';

void main() {
  testWidgets('SplashView shows loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashView(),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
