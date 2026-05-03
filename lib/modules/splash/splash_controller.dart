import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    SchedulerBinding.instance.addPostFrameCallback((_) => _route());
  }

  void _route() {
    final auth = Get.find<AuthController>();
    final user = auth.user.value;
    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
