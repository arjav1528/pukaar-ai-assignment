import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';
import 'package:pukaar/shared/utils/app_log.dart';

/// Sends unauthenticated users to [AppRoutes.login]; signed-in users away from login.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    final user = auth.user.value;
    const public = {AppRoutes.splash, AppRoutes.login};

    if (user == null && route != null && !public.contains(route)) {
      pukaarLog(
        'AuthMiddleware: redirect → login (user=null route=$route)',
        tag: 'Pukaar.Middleware',
      );
      return const RouteSettings(name: AppRoutes.login);
    }
    if (user != null && route == AppRoutes.login) {
      pukaarLog(
        'AuthMiddleware: redirect → home (user=${user.uid} on login)',
        tag: 'Pukaar.Middleware',
      );
      return const RouteSettings(name: AppRoutes.home);
    }
    pukaarLog(
      'AuthMiddleware: no redirect (route=$route uid=${user?.uid ?? "null"})',
      tag: 'Pukaar.Middleware',
    );
    return null;
  }
}
