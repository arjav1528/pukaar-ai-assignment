import 'package:get/get.dart';
import 'package:pukaar/app/middlewares/auth_middleware.dart';
import 'package:pukaar/modules/auth/login_view.dart';
import 'package:pukaar/modules/home/home_shell.dart';
import 'package:pukaar/modules/splash/splash_binding.dart';
import 'package:pukaar/modules/splash/splash_view.dart';

import 'app_routes.dart';

/// Application routes; more screens register here as they are built.
abstract final class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<void>(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.login,
      page: () => const LoginView(),
    ),
    GetPage<void>(
      name: AppRoutes.home,
      page: () => const HomeShell(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
    ),
  ];
}
