import 'package:get/get.dart';

import 'package:pukaar/modules/dashboard/dashboard_controller.dart';
import 'package:pukaar/modules/history/history_controller.dart';
import 'package:pukaar/shared/utils/app_log.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    pukaarLog('HomeBinding: lazyPut Home/Dashboard/History', tag: 'Pukaar.Binding');
    Get.lazyPut<HomeController>(HomeController.new);
    Get.lazyPut<DashboardController>(DashboardController.new);
    Get.lazyPut<HistoryController>(HistoryController.new);
  }
}
