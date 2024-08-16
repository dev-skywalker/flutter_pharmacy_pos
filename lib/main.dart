import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'routes/routes.dart';
import 'services/check_auth_service.dart';

//flutter run -d chrome --web-browser-flag "--disable-web-security"

Future<void> main() async {
  await GetStorage.init();
  //setPathUrlStrategy();
  Get.lazyPut(() => CheckAuthService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy POS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      initialRoute: Routes.root,
      getPages: Routes.routes,
    );
  }
}
