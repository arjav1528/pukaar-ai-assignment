import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pukaar/modules/dashboard/dashboard_view.dart';
import 'package:pukaar/modules/history/history_view.dart';
import 'package:pukaar/modules/profile/profile_view.dart';

import 'home_controller.dart';

class HomeShell extends GetView<HomeController> {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            DashboardView(),
            HistoryView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.setTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.today_outlined),
              selectedIcon: Icon(Icons.today),
              label: 'Today',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
