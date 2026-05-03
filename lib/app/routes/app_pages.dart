import 'package:get/get.dart';
import 'package:pukaar/modules/splash/splash_view.dart';

import 'app_routes.dart';

/// Application routes; more screens register here as they are built.
abstract final class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<void>(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
  ];
}
