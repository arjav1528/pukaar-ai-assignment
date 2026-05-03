import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 40.r,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Pukaar',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.25,
                ),
              ),
              SizedBox(height: 28.h),
              SizedBox(
                width: 120.w,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(4.r),
                  minHeight: 3,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
