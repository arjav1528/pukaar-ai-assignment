import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pukaar/modules/home/home_controller.dart';
import 'package:pukaar/modules/home/home_shell.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('HomeShell can show Profile without building Dashboard', (WidgetTester tester) async {
    Get.testMode = true;
    final home = HomeController();
    Get.put(home);
    home.currentIndex.value = 2;

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeShell(),
      ),
    );

    expect(find.text('Profile'), findsWidgets); // body + nav label
    expect(find.text('Today'), findsOneWidget);
  });
}
