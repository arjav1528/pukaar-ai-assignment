import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pukaar/app/bindings/initial_binding.dart';
import 'package:pukaar/app/routes/app_pages.dart';
import 'package:pukaar/app/routes/app_routes.dart';
import 'package:pukaar/app/theme/app_theme.dart';

class PukaarApp extends StatelessWidget {
  const PukaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pukaar',
      theme: AppTheme.light(),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
