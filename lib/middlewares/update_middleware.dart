import 'dart:async';
import 'package:get/get.dart';
import 'package:pharmacy_pos/routes/routes.dart';

class UpdateProductMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    if (route.arguments() == null) {
      return RouteDecoder.fromRoute('${Routes.app}${Routes.products}');
    }
    return await super.redirectDelegate(route);
  }
}
