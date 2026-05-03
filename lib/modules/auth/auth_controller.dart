import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/data/services/auth_service.dart';
import 'package:pukaar/shared/utils/app_log.dart';
import 'package:pukaar/shared/utils/snackbar_utils.dart';

class AuthController extends GetxController {
  AuthController({required this.authService});

  final AuthService authService;

  final Rxn<User> user = Rxn<User>();
  final RxBool isLoading = false.obs;

  StreamSubscription<User?>? _authSub;

  @override
  void onInit() {
    super.onInit();
    user.value = authService.currentUser;
    pukaarLog(
      'AuthController.onInit: currentUser.uid=${user.value?.uid ?? "null"}',
      tag: 'Pukaar.Auth',
    );
    _authSub = authService.authStateChanges().listen((u) {
      pukaarLog(
        'AuthController: authStateChanges uid=${u?.uid ?? "null"} email=${u?.email ?? ""}',
        tag: 'Pukaar.Auth',
      );
      user.value = u;
    });
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) {
      pukaarLog('loginWithGoogle: skipped (already loading)', tag: 'Pukaar.Auth');
      return;
    }
    pukaarLog('loginWithGoogle: start isLoading=true', tag: 'Pukaar.Auth');
    isLoading.value = true;
    try {
      await authService.signInWithGoogle();
      pukaarLog('loginWithGoogle: signInWithGoogle ok → offAllNamed home', tag: 'Pukaar.Auth');
      Get.offAllNamed(AppRoutes.home);
    } on SignInCancelledException {
      pukaarLog('loginWithGoogle: SignInCancelledException', tag: 'Pukaar.Auth');
      // User closed the picker — no snackbar.
    } catch (e, st) {
      pukaarLog('loginWithGoogle: error', tag: 'Pukaar.Auth', error: e, stackTrace: st);
      showErrorSnack('$e');
    } finally {
      isLoading.value = false;
      pukaarLog('loginWithGoogle: finally isLoading=false', tag: 'Pukaar.Auth');
    }
  }

  Future<void> logout() async {
    if (isLoading.value) {
      pukaarLog('logout: skipped (already loading)', tag: 'Pukaar.Auth');
      return;
    }
    pukaarLog('logout: start', tag: 'Pukaar.Auth');
    isLoading.value = true;
    try {
      await authService.signOut();
      pukaarLog('logout: signOut ok → offAllNamed login', tag: 'Pukaar.Auth');
      Get.offAllNamed(AppRoutes.login);
    } catch (e, st) {
      pukaarLog('logout: error', tag: 'Pukaar.Auth', error: e, stackTrace: st);
      showErrorSnack('$e');
    } finally {
      isLoading.value = false;
      pukaarLog('logout: finally isLoading=false', tag: 'Pukaar.Auth');
    }
  }
}
