import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pukaar/app/theme/app_colors.dart';
import 'package:pukaar/data/models/activity_entry.dart';
import 'package:pukaar/data/models/metric_type.dart';
import 'package:pukaar/data/services/firestore_service.dart';
import 'package:pukaar/shared/utils/date_utils.dart';
import 'package:pukaar/shared/utils/snackbar_utils.dart';
import 'package:pukaar/shared/widgets/loading_indicator.dart';

class DayDetailView extends StatelessWidget {
  const DayDetailView({super.key});

  String _title(String dateKey) {
    final d = startOfDayFromDateKey(dateKey);
    return DateFormat.yMMMEd().format(d);
  }

  String _metricTitle(MetricType m) {
    return switch (m) {
      MetricType.water => 'Water',
      MetricType.steps => 'Steps',
      MetricType.calories => 'Calories',
    };
  }

  String _formatValue(ActivityEntry e) {
    final v = e.value;
    final unit = switch (e.metric) {
      MetricType.water => ' glasses',
      MetricType.steps => ' steps',
      MetricType.calories => ' kcal',
    };
    final numStr = v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(1);
    return '$numStr$unit';
  }

  String _time(ActivityEntry e) {
    final t = e.createdAt;
    if (t == null) return '';
    return DateFormat.jm().format(t);
  }

  Color _metricColor(MetricType m) {
    return switch (m) {
      MetricType.water => AppColors.water,
      MetricType.steps => AppColors.steps,
      MetricType.calories => AppColors.calories,
    };
  }

  IconData _metricIcon(MetricType m) {
    return switch (m) {
      MetricType.water => Icons.water_drop_rounded,
      MetricType.steps => Icons.directions_walk_rounded,
      MetricType.calories => Icons.local_fire_department_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateKey = Get.arguments as String? ?? '';
    final theme = Theme.of(context);
    final fs = Get.find<FirestoreService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(dateKey.isEmpty ? 'Day' : _title(dateKey)),
      ),
      body: dateKey.isEmpty
          ? const Center(child: Text('Missing date'))
          : StreamBuilder<List<ActivityEntry>>(
              stream: fs.streamEntriesForDateKey(dateKey),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
                  return const CenteredLoading();
                }
                final list = snap.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Text(
                        'No entries for this day.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, i) {
                    final e = list[i];
                    final accent = _metricColor(e.metric);
                    return Dismissible(
                      key: ValueKey(e.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        try {
                          await fs.deleteEntry(e.id);
                          return true;
                        } catch (err) {
                          showErrorSnack('$err');
                          return false;
                        }
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.w),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: theme.colorScheme.onErrorContainer,
                          size: 24.r,
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                          leading: CircleAvatar(
                            backgroundColor: accent.withValues(alpha: 0.14),
                            foregroundColor: accent,
                            child: Icon(_metricIcon(e.metric), size: 22.r),
                          ),
                          title: Text(
                            _metricTitle(e.metric),
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatValue(e),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                if (e.note != null && e.note!.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    e.note!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                                if (_time(e).isNotEmpty) ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    _time(e),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
