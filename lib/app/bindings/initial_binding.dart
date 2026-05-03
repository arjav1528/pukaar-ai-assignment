import 'package:get/get.dart';

import 'package:pukaar/data/services/auth_service.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<AuthController>(
      AuthController(authService: Get.find<AuthService>()),
      permanent: true,
    );
  }
}
