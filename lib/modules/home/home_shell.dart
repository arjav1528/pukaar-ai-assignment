import 'package:flutter/material.dart';

/// Placeholder shell until bottom navigation is implemented.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pukaar')),
      body: const Center(child: Text('Home')),
    );
  }
}
