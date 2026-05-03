import 'package:get/get.dart';

import 'package:pukaar/shared/utils/app_log.dart';

import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Must be eager [Get.put], not [lazyPut]: [SplashView] is a [GetView] that
    // never calls [controller] in [build], so [lazyPut] was never resolved and
    // [onReady] / navigation never ran (infinite splash).
    pukaarLog('SplashBinding: put SplashController', tag: 'Pukaar.Splash');
    Get.put<SplashController>(SplashController());
  }
}
