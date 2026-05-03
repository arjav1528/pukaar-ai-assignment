import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pukaar/app/theme/app_colors.dart';
import 'package:pukaar/data/models/metric_type.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';

import 'dashboard_controller.dart';
import 'widgets/add_entry_sheet.dart';
import 'widgets/metric_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();
    final today = DateFormat.yMMMEd().format(DateTime.now());

    Future<void> openAdd([MetricType? initial]) async {
      final result = await AddEntrySheet.open(context, initialMetric: initial);
      if (result != null) {
        await controller.submitEntry(result);
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openAdd(),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: SafeArea(
        child: Obx(
          () {
            final user = auth.user.value;
            final name = user?.displayName;
            final greeting = (name != null && name.isNotEmpty) ? 'Hello, $name' : 'Hello';

            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                Text(
                  'Your day',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  today,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                SizedBox(height: 24.h),
                MetricCard(
                  title: 'Water',
                  valueText: _fmt(controller.waterGlasses.value),
                  subtitle: 'glasses',
                  accent: AppColors.water,
                  onAdd: () => openAdd(MetricType.water),
                ),
                SizedBox(height: 12.h),
                MetricCard(
                  title: 'Steps',
                  valueText: _fmt(controller.steps.value),
                  subtitle: 'steps',
                  accent: AppColors.steps,
                  onAdd: () => openAdd(MetricType.steps),
                ),
                SizedBox(height: 12.h),
                MetricCard(
                  title: 'Calories',
                  valueText: _fmt(controller.calories.value),
                  subtitle: 'kcal',
                  accent: AppColors.calories,
                  onAdd: () => openAdd(MetricType.calories),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(1);
  }
}
