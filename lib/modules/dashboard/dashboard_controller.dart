import 'dart:async';

import 'package:get/get.dart';

import 'package:pukaar/data/models/activity_entry.dart';
import 'package:pukaar/data/models/metric_type.dart';
import 'package:pukaar/data/services/firestore_service.dart';
import 'package:pukaar/modules/dashboard/widgets/add_entry_sheet.dart';
import 'package:pukaar/shared/utils/app_log.dart';
import 'package:pukaar/shared/utils/date_utils.dart';
import 'package:pukaar/shared/utils/snackbar_utils.dart';

class DashboardController extends GetxController {
  DashboardController({FirestoreService? firestore})
      : _firestore = firestore ?? Get.find<FirestoreService>();

  final FirestoreService _firestore;

  final RxDouble waterGlasses = 0.0.obs;
  final RxDouble steps = 0.0.obs;
  final RxDouble calories = 0.0.obs;

  String get _todayKey => dateKeyFromDate(DateTime.now());

  StreamSubscription<List<ActivityEntry>>? _sub;

  @override
  void onInit() {
    super.onInit();
    pukaarLog(
      'DashboardController.onInit: subscribe entries dateKey=$_todayKey',
      tag: 'Pukaar.Dashboard',
    );
    _sub = _firestore.streamEntriesForDateKey(_todayKey).listen(
      (entries) {
        pukaarLog(
          'DashboardController: stream snapshot count=${entries.length}',
          tag: 'Pukaar.Dashboard',
        );
        num w = 0;
        num s = 0;
        num c = 0;
        for (final e in entries) {
          switch (e.metric) {
            case MetricType.water:
              w += e.value;
              break;
            case MetricType.steps:
              s += e.value;
              break;
            case MetricType.calories:
              c += e.value;
              break;
          }
        }
        waterGlasses.value = w.toDouble();
        steps.value = s.toDouble();
        calories.value = c.toDouble();
      },
      onError: (Object e, StackTrace st) {
        pukaarLog(
          'DashboardController: entries stream ERROR',
          tag: 'Pukaar.Dashboard',
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

  Future<void> submitEntry(AddEntryResult result) async {
    try {
      pukaarLog(
        'DashboardController.submitEntry: ${result.metric} value=${result.value}',
        tag: 'Pukaar.Dashboard',
      );
      await _firestore.addEntry(
        metric: result.metric,
        value: result.value,
        dateKey: _todayKey,
        note: result.note,
      );
      pukaarLog('DashboardController.submitEntry: addEntry ok', tag: 'Pukaar.Dashboard');
      showAppSnack('Saved', 'Your entry was added.');
    } catch (e, st) {
      pukaarLog('DashboardController.submitEntry: error', tag: 'Pukaar.Dashboard', error: e, stackTrace: st);
      showErrorSnack('$e');
    }
  }
}
