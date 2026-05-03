import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pukaar/modules/home/home_controller.dart';
import 'package:pukaar/modules/home/home_shell.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('HomeShell shows dashboard tab by default', (WidgetTester tester) async {
    Get.testMode = true;
    Get.put(HomeController());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeShell(),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });
}
