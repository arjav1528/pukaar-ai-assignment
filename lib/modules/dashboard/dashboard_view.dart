import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pukaar/app/theme/app_colors.dart';

import 'widgets/metric_card.dart';

/// Static totals — live Firestore totals are wired in the next commit.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateFormat.yMMMEd().format(DateTime.now());

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Hello',
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
            valueText: '0',
            subtitle: 'glasses',
            accent: AppColors.water,
            onAdd: () {},
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: 'Steps',
            valueText: '0',
            subtitle: 'steps',
            accent: AppColors.steps,
            onAdd: () {},
          ),
          const SizedBox(height: 12),
          MetricCard(
            title: 'Calories',
            valueText: '0',
            subtitle: 'kcal',
            accent: AppColors.calories,
            onAdd: () {},
          ),
        ],
      ),
    );
  }
}
