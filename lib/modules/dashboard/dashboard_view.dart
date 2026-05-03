import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pukaar/app/theme/app_colors.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';

import 'dashboard_controller.dart';
import 'widgets/metric_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();
    final today = DateFormat.yMMMEd().format(DateTime.now());

    return SafeArea(
      child: Obx(
        () {
          final user = auth.user.value;
          final name = user?.displayName;
          final greeting = (name != null && name.isNotEmpty) ? 'Hello, $name' : 'Hello';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(
                greeting,
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(
                'Your day',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                today,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              MetricCard(
                title: 'Water',
                valueText: _fmt(controller.waterGlasses.value),
                subtitle: 'glasses',
                accent: AppColors.water,
                onAdd: () {},
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: 'Steps',
                valueText: _fmt(controller.steps.value),
                subtitle: 'steps',
                accent: AppColors.steps,
                onAdd: () {},
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: 'Calories',
                valueText: _fmt(controller.calories.value),
                subtitle: 'kcal',
                accent: AppColors.calories,
                onAdd: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(1);
  }
}
