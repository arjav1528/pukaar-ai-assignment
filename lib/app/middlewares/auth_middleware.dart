import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';

/// Sends unauthenticated users to [AppRoutes.login]; signed-in users away from login.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    final user = auth.user.value;
    const public = {AppRoutes.splash, AppRoutes.login};

    if (user == null && route != null && !public.contains(route)) {
      return const RouteSettings(name: AppRoutes.login);
    }
    if (user != null && route == AppRoutes.login) {
      return const RouteSettings(name: AppRoutes.home);
    }
    return null;
  }
}
