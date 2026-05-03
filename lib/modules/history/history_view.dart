import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pukaar/data/models/metric_type.dart';
import 'package:pukaar/shared/utils/date_utils.dart';

import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  static String _fmtNum(num n) {
    if (n == n.roundToDouble()) return n.round().toString();
    return n.toStringAsFixed(1);
  }

  String _formatDayLabel(String dateKey) {
    final d = startOfDayFromDateKey(dateKey);
    return DateFormat.yMMMEd().format(d);
  }

  String _subtitle(Map<MetricType, num> totals) {
    final parts = <String>[];
    final w = totals[MetricType.water];
    if (w != null && w > 0) parts.add('Water: ${_fmtNum(w)} glasses');
    final s = totals[MetricType.steps];
    if (s != null && s > 0) parts.add('Steps: ${s.round()}');
    final c = totals[MetricType.calories];
    if (c != null && c > 0) parts.add('Calories: ${_fmtNum(c)} kcal');
    return parts.isEmpty ? 'Tap for entries' : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Obx(() {
        final days = controller.daysDescending();
        if (days.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No history yet.\nLog activity from the Today tab.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          );
        }

        final byDay = controller.totalsByDay();

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: days.length,
          separatorBuilder: (context, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final day = days[i];
            final totals = byDay[day] ?? {};

            return ListTile(
              title: Text(_formatDayLabel(day), style: theme.textTheme.titleMedium),
              subtitle: Text(_subtitle(totals)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.snackbar('Day selected', day),
            );
          },
        );
      }),
    );
  }
}
