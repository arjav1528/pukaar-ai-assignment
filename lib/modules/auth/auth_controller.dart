import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/data/services/auth_service.dart';

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
    _authSub = authService.authStateChanges().listen((u) => user.value = u);
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await authService.signInWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } on SignInCancelledException {
      // User closed the picker — no snackbar.
    } catch (e, _) {
      Get.snackbar('Sign in failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await authService.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e, _) {
      Get.snackbar('Sign out failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }
}
