import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'routes/routes.dart';
import 'services/check_auth_service.dart';

//flutter run -d chrome --web-browser-flag "--disable-web-security"

Future<void> main() async {
  await GetStorage.init();
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: const Color.fromARGB(255, 21, 0, 212)),
        useMaterial3: true,
      ),
      defaultTransition: Transition.fadeIn,
      //transitionDuration: Duration(milliseconds: 1000),
      //home: const LineChartWithResponse(),
      initialRoute: Routes.root,
      getPages: Routes.routes,
    );
  }
}
