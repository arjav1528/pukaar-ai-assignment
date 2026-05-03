import 'package:flutter/material.dart';

/// Placeholder shell; auth-based navigation is added with [SplashController].
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
