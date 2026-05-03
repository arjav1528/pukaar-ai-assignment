import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: photo != null ? NetworkImage(photo) : null,
                child: photo == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: theme.textTheme.headlineMedium,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                email,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 40),
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
