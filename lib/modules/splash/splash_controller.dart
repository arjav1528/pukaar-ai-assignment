import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/data/services/auth_service.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';
import 'package:pukaar/shared/utils/app_log.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    pukaarLog('SplashController.onReady: schedule _route', tag: 'Pukaar.Splash');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      pukaarLog('SplashController: postFrameCallback → _route', tag: 'Pukaar.Splash');
      _route();
    });
  }

  /// Routes after Firebase Auth emits initial state (persisted session). Logs every step.
  Future<void> _route() async {
    pukaarLog('Splash._route: start (wait for first authStateChanges)', tag: 'Pukaar.Splash');
    final authService = Get.find<AuthService>();
    try {
      await authService.authStateChanges().first.timeout(const Duration(seconds: 15));
      pukaarLog('Splash._route: got first authStateChanges (no timeout)', tag: 'Pukaar.Splash');
    } on TimeoutException catch (e, st) {
      pukaarLog(
        'Splash._route: authStateChanges TIMEOUT (15s) — continuing unauthenticated',
        tag: 'Pukaar.Splash',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      pukaarLog(
        'Splash._route: error waiting for authStateChanges',
        tag: 'Pukaar.Splash',
        error: e,
        stackTrace: st,
      );
    }
    final auth = Get.find<AuthController>();
    final user = auth.user.value;
    pukaarLog(
      'Splash._route: user=${user?.uid ?? "null"} → navigating',
      tag: 'Pukaar.Splash',
    );
    if (user != null) {
      pukaarLog('Splash._route: Get.offAllNamed(${AppRoutes.home})', tag: 'Pukaar.Splash');
      Get.offAllNamed(AppRoutes.home);
    } else {
      pukaarLog('Splash._route: Get.offAllNamed(${AppRoutes.login})', tag: 'Pukaar.Splash');
      Get.offAllNamed(AppRoutes.login);
    }
    pukaarLog('Splash._route: offAllNamed invoked', tag: 'Pukaar.Splash');
  }
}
