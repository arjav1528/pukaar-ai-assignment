import 'dart:async';

import 'package:get/get.dart';

import 'package:pukaar/data/models/activity_entry.dart';
import 'package:pukaar/data/models/metric_type.dart';
import 'package:pukaar/data/services/firestore_service.dart';
import 'package:pukaar/shared/utils/app_log.dart';

class HistoryController extends GetxController {
  HistoryController({FirestoreService? firestore})
      : _firestore = firestore ?? Get.find<FirestoreService>();

  final FirestoreService _firestore;

  final RxList<ActivityEntry> entries = <ActivityEntry>[].obs;

  StreamSubscription<List<ActivityEntry>>? _sub;

  /// `{ dateKey -> { metric -> sum } }`
  Map<String, Map<MetricType, num>> totalsByDay() {
    final map = <String, Map<MetricType, num>>{};
    for (final e in entries) {
      map.putIfAbsent(e.dateKey, () => <MetricType, num>{});
      final inner = map[e.dateKey]!;
      inner[e.metric] = (inner[e.metric] ?? 0) + e.value;
    }
    return map;
  }

  List<String> daysDescending() {
    final keys = totalsByDay().keys.toList()..sort((a, b) => b.compareTo(a));
    return keys;
  }

  @override
  void onInit() {
    super.onInit();
    pukaarLog('HistoryController.onInit: streamAllEntries', tag: 'Pukaar.History');
    _sub = _firestore.streamAllEntries().listen(
      (list) {
        pukaarLog(
          'HistoryController: stream snapshot count=${list.length}',
          tag: 'Pukaar.History',
        );
        entries.assignAll(list);
      },
      onError: (Object e, StackTrace st) {
        pukaarLog(
          'HistoryController: stream ERROR',
          tag: 'Pukaar.History',
          error: e,
          stackTrace: st,
        );
      },
    );
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
