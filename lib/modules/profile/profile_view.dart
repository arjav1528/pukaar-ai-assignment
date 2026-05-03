import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pukaar/modules/auth/auth_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final theme = Theme.of(context);

    return SafeArea(
      child: Obx(() {
        final user = auth.user.value;
        final name = user?.displayName ?? 'Signed in';
        final email = user?.email ?? '';
        final photo = user?.photoURL;

        return ListView(
          padding: EdgeInsets.all(24.r),
          children: [
            SizedBox(height: 16.h),
            Center(
              child: CircleAvatar(
                radius: 48.r,
                backgroundImage: photo != null ? NetworkImage(photo) : null,
                child: photo == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: theme.textTheme.headlineMedium,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (email.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                email,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            SizedBox(height: 40.h),
            OutlinedButton.icon(
              onPressed: auth.isLoading.value ? null : auth.logout,
              icon: const Icon(Icons.logout),
              label: auth.isLoading.value ? const Text('Signing out…') : const Text('Sign out'),
            ),
          ],
        );
      }),
    );
  }
}
