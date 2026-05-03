import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pukaar/data/models/metric_type.dart';

class AddEntryResult {
  const AddEntryResult({
    required this.metric,
    required this.value,
    this.note,
  });

  final MetricType metric;
  final num value;
  final String? note;
}

/// Modal form for logging activity; persistence is wired in the next commit.
class AddEntrySheet extends StatefulWidget {
  const AddEntrySheet({super.key, this.initialMetric});

  final MetricType? initialMetric;

  static Future<AddEntryResult?> open(
    BuildContext context, {
    MetricType? initialMetric,
  }) {
    return showModalBottomSheet<AddEntryResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => AddEntrySheet(initialMetric: initialMetric),
    );
  }

  @override
  State<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<AddEntrySheet> {
  late MetricType _metric;
  final _valueCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _metric = widget.initialMetric ?? MetricType.water;
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String _hintFor(MetricType m) {
    switch (m) {
      case MetricType.water:
        return 'Glasses';
      case MetricType.steps:
        return 'Steps';
      case MetricType.calories:
        return 'kcal';
    }
  }

  void _submit() {
    final raw = _valueCtrl.text.trim();
    final parsed = num.tryParse(raw);
    if (parsed == null || parsed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a positive number')),
      );
      return;
    }
    const maxVal = 1000000;
    if (parsed > maxVal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter at most $maxVal')),
      );
      return;
    }
    final note = _noteCtrl.text.trim();
    Navigator.of(context).pop(
      AddEntryResult(
        metric: _metric,
        value: parsed,
        note: note.isEmpty ? null : note,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add entry', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            SegmentedButton<MetricType>(
              segments: [
                ButtonSegment(
                  value: MetricType.water,
                  label: const Text('Water'),
                  icon: Icon(Icons.water_drop_outlined, size: 18.r),
                ),
                ButtonSegment(
                  value: MetricType.steps,
                  label: const Text('Steps'),
                  icon: Icon(Icons.directions_walk, size: 18.r),
                ),
                ButtonSegment(
                  value: MetricType.calories,
                  label: const Text('Cal'),
                  icon: Icon(Icons.local_fire_department_outlined, size: 18.r),
                ),
              ],
              selected: {_metric},
              onSelectionChanged: (s) => setState(() => _metric = s.first),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _valueCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount (${_hintFor(_metric)})',
              ),
              autofocus: true,
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
