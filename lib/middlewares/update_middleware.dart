import 'dart:async';
import 'package:get/get.dart';
import 'package:pharmacy_pos/routes/routes.dart';

class UpdateMiddleware extends GetMiddleware {
  final String name;
  UpdateMiddleware(this.name);
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    if (route.arguments() == null) {
      return RouteDecoder.fromRoute('${Routes.app}$name');
    }
    return await super.redirectDelegate(route);
  }
}
