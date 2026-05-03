import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pukaar/data/models/activity_entry.dart';
import 'package:pukaar/data/models/metric_type.dart';
import 'package:pukaar/data/services/firestore_service.dart';
import 'package:pukaar/shared/utils/date_utils.dart';

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
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snap.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No entries for this day.',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final e = list[i];
                    return Dismissible(
                      key: ValueKey(e.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        try {
                          await fs.deleteEntry(e.id);
                          return true;
                        } catch (err) {
                          Get.snackbar('Could not delete', '$err');
                          return false;
                        }
                      },
                      background: Container(
                        color: theme.colorScheme.errorContainer,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer),
                      ),
                      child: ListTile(
                        title: Text('${_metricTitle(e.metric)} · ${_formatValue(e)}'),
                        subtitle: e.note != null && e.note!.isNotEmpty
                            ? Text('${e.note} · ${_time(e)}')
                            : Text(_time(e)),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
