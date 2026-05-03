import 'package:cloud_firestore/cloud_firestore.dart';

import 'metric_type.dart';

class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.metric,
    required this.value,
    required this.dateKey,
    this.createdAt,
    this.note,
  });

  final String id;
  final MetricType metric;
  final num value;
  final String dateKey;
  final DateTime? createdAt;
  final String? note;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'metric': metric.firestoreValue,
      'value': value,
      'dateKey': dateKey,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static ActivityEntry fromMap(String id, Map<String, dynamic> data) {
    final metric = MetricType.fromFirestore(data['metric'] as String?);
    if (metric == null) {
      throw FormatException('Unknown metric in entry $id');
    }
    final created = data['createdAt'];
    DateTime? createdAt;
    if (created is Timestamp) {
      createdAt = created.toDate();
    }
    return ActivityEntry(
      id: id,
      metric: metric,
      value: (data['value'] as num?) ?? 0,
      dateKey: (data['dateKey'] as String?) ?? '',
      createdAt: createdAt,
      note: data['note'] as String?,
    );
  }
}
