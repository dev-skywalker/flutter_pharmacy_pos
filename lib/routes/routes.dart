import 'package:get/get.dart';
import 'package:pharmacy_pos/middlewares/auth_middleware.dart';
import 'package:pharmacy_pos/middlewares/root_middleware.dart';
import 'package:pharmacy_pos/modules/auth/bindings/auth_binding.dart';
import 'package:pharmacy_pos/modules/auth/views/login_page.dart';
import 'package:pharmacy_pos/modules/dashboard/views/dashboard_page.dart';
import 'package:pharmacy_pos/modules/product/views/create_product.dart';
import 'package:pharmacy_pos/modules/product/views/product_reports.dart';
import 'package:pharmacy_pos/modules/root/views/root_page.dart';
import 'package:pharmacy_pos/modules/units/views/create_unit_page.dart';
import 'package:pharmacy_pos/modules/units/views/unit_reports.dart';

import '../modules/product/views/product_page.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/home_page.dart';
import '../modules/units/views/unit_page.dart';

class Routes {
  static const root = '/';
  static const app = '/app';
  static const dashboard = '/dashboard';
  static const products = '/products';
  static const units = '/units';
  static const create = '/create';
  static const report = '/reports';
  static const register = '/register';
  static const login = '/login';

  static final routes = [
    GetPage(
      name: root,
      page: () => const HomePage(),
      preventDuplicates: false,
      participatesInRootNavigator: true,
      middlewares: [RootMiddleware()],
    ),
    GetPage(
        name: app,
        page: () => const RootPage(),
        binding: RootBinding(),
        preventDuplicates: false,
        participatesInRootNavigator: true,
        middlewares: [
          AuthMiddleware()
        ],
        children: [
          GetPage(
            name: dashboard,
            page: () => const DashboardPage(),
            //preventDuplicates: true,
            //participatesInRootNavigator: true,
            //transition: Transition.downToUp
          ),
          GetPage(
              name: products,
              page: () => const ProductPage(),
              //preventDuplicates: true,
              //transition: Transition.fade
              // participatesInRootNavigator: false,
              //preventDuplicates: false,
              //participatesInRootNavigator: true,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateProductPage(),
                  // preventDuplicates: true,
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: report,
                  page: () => const ProductReportPage(),
                  // preventDuplicates: true,
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
              ]),
          GetPage(
              name: units,
              page: () => const UnitPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateUnitPage(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: report,
                  page: () => const UnitReportPage(),
                  // preventDuplicates: true,
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
              ]),
        ]),
    GetPage(
      name: register,
      page: () => const LoginPage(true),
      binding: AuthBinding(),
      preventDuplicates: false,
      participatesInRootNavigator: true,
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(false),
      binding: AuthBinding(),
      preventDuplicates: false,
      participatesInRootNavigator: true,
      middlewares: [RootMiddleware()],
    ),
  ];
}
