import 'dart:async';
import 'package:get/get.dart';
import 'package:pharmacy_pos/routes/routes.dart';
import 'package:pharmacy_pos/services/check_auth_service.dart';

class RootMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final authService = Get.find<CheckAuthService>();

    if (!authService.subscribe()) {
      //final newRoute = Routes.LOGIN_THEN(route.pageSettings!.name);
      return RouteDecoder.fromRoute(Routes.login);
    } else {
      return RouteDecoder.fromRoute(Routes.app);
    }
  }
}
