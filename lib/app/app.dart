import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pukaar/app/bindings/initial_binding.dart';
import 'package:pukaar/app/routes/app_pages.dart';
import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/app/theme/app_theme.dart';
import 'package:pukaar/shared/utils/app_log.dart';

class PukaarApp extends StatelessWidget {
  const PukaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    pukaarLog('PukaarApp.build initialRoute=${AppRoutes.splash}', tag: 'Pukaar.App');
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return GetMaterialApp(
          title: 'Pukaar',
          theme: AppTheme.light(),
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
