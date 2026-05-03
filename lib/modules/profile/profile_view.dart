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
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          children: [
            SizedBox(height: 8.h),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 28.h),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44.r,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      backgroundImage: photo != null ? NetworkImage(photo) : null,
                      child: photo == null
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                            )
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                    if (email.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        email,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: auth.isLoading.value ? null : auth.logout,
                icon: const Icon(Icons.logout_rounded),
                label: auth.isLoading.value ? const Text('Signing out…') : const Text('Sign out'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
