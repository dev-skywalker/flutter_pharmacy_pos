import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/routes/routes.dart';
import 'package:pharmacy_pos/services/storage_services.dart';

class RootController extends GetxController {
  var currentIndex = 0.obs;
  var activeMainIndex = 0.obs;
  var currentSubIndex = 0.obs;
  var expandedIndex = (-1).obs;
  final StorageService _storageService = StorageService();

  void logOut() {
    _storageService.clear(key: "token");
    Get.offAllNamed(Routes.login);
  }

  final List<dynamic> sidebarList = [
    {
      "icon": Icons.dashboard,
      "title": "Dashboard",
      "trailing": const SizedBox.shrink(),
      "enable": true
    },
    {
      "icon": null,
      "title": "INVENTORY",
      "trailing": const SizedBox.shrink(),
      "enable": false
    },
    {"icon": Icons.list, "title": "Products", "trailing": null, "enable": true},
    {
      "icon": Icons.category,
      "title": "Units",
      "trailing": null,
      "enable": true
    },
  ];

  //final pages = <String>['/dashboard', '/products', '/shop', '/points'];

  // void changePage(int index) {
  //   currentIndex.value = index;
  //   Get.toNamed(pages[index], id: 1);
  // }

  // Route? onGenerateRoute(RouteSettings settings) {
  //   if (settings.name == '/home') {
  //     return GetPageRoute(
  //       transitionDuration: const Duration(milliseconds: 0),
  //       settings: settings,
  //       page: () => const HomePage(),
  //       binding: HomeBinding(),
  //     );
  //   }

  //   if (settings.name == '/streaming') {
  //     return GetPageRoute(
  //       transitionDuration: const Duration(milliseconds: 0),
  //       settings: settings,
  //       page: () => const HomeStreamerPage(),
  //       binding: HomeBinding(),
  //       //binding: HistoryBinding(),
  //     );
  //   }

  //   if (settings.name == '/shop') {
  //     return GetPageRoute(
  //       transitionDuration: const Duration(milliseconds: 0),
  //       settings: settings,
  //       page: () => const MyWidget(title: "shop"),
  //       //binding: SettingsBinding(),
  //     );
  //   }

  //   if (settings.name == '/points') {
  //     return GetPageRoute(
  //       transitionDuration: const Duration(milliseconds: 0),
  //       settings: settings,
  //       page: () => const MyWidget(title: "Points"),
  //       //binding: SettingsBinding(),
  //     );
  //   }

  //   return null;
  // }
}
