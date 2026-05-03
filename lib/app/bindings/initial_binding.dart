import 'package:get/get.dart';

import 'package:pukaar/data/services/auth_service.dart';
import 'package:pukaar/data/services/firestore_service.dart';
import 'package:pukaar/modules/auth/auth_controller.dart';
import 'package:pukaar/shared/utils/app_log.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    pukaarLog('InitialBinding: put AuthService', tag: 'Pukaar.Binding');
    Get.put<AuthService>(AuthService(), permanent: true);
    pukaarLog('InitialBinding: put FirestoreService', tag: 'Pukaar.Binding');
    Get.put<FirestoreService>(FirestoreService(), permanent: true);
    pukaarLog('InitialBinding: put AuthController', tag: 'Pukaar.Binding');
    Get.put<AuthController>(
      AuthController(authService: Get.find<AuthService>()),
      permanent: true,
    );
    pukaarLog('InitialBinding: done', tag: 'Pukaar.Binding');
  }
}
