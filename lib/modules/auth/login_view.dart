import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.favorite_rounded, size: 56.r, color: theme.colorScheme.primary),
              SizedBox(height: 24.h),
              Text(
                'Pukaar',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                'Track water, steps, and calories in one place.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              SizedBox(height: 48.h),
              Obx(() {
                final loading = auth.isLoading.value;
                return loading
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton.icon(
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Continue with Google'),
                        onPressed: auth.loginWithGoogle,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
