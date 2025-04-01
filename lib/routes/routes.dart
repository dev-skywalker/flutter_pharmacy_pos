import 'package:get/get.dart';
import 'package:pharmacy_pos/middlewares/auth_middleware.dart';
import 'package:pharmacy_pos/middlewares/root_middleware.dart';
import 'package:pharmacy_pos/modules/auth/bindings/auth_binding.dart';
import 'package:pharmacy_pos/modules/auth/views/login_page.dart';
import 'package:pharmacy_pos/modules/best_selling_product/views/best_selling_product_page.dart';
import 'package:pharmacy_pos/modules/customer/bindings/customer_binding.dart';
import 'package:pharmacy_pos/modules/customer/views/create_customer_page.dart';
import 'package:pharmacy_pos/modules/customer/views/customer_page.dart';
import 'package:pharmacy_pos/modules/customer/views/update_customer_page.dart';
import 'package:pharmacy_pos/modules/dashboard/bindings/dashboard_bindings.dart';
import 'package:pharmacy_pos/modules/dashboard/views/dashboard_page.dart';
import 'package:pharmacy_pos/modules/lost_damage/bindings/lost_damage_binding.dart';
import 'package:pharmacy_pos/modules/lost_damage/views/create_lost_damage_page.dart';
import 'package:pharmacy_pos/modules/lost_damage/views/lost_damage_page.dart';
import 'package:pharmacy_pos/modules/product/bindings/product_binding.dart';
import 'package:pharmacy_pos/modules/product/views/create_product.dart';
import 'package:pharmacy_pos/modules/product/views/product_reports.dart';
import 'package:pharmacy_pos/modules/product/views/update_product.dart';
import 'package:pharmacy_pos/modules/purchase/bindings/purchase_binding.dart';
import 'package:pharmacy_pos/modules/purchase/views/create_purchase_page.dart';
import 'package:pharmacy_pos/modules/purchase/views/purchase_page.dart';
import 'package:pharmacy_pos/modules/purchase/views/update_purchase_page.dart';
import 'package:pharmacy_pos/modules/purchase_return/bindings/purchase_return_binding.dart';
import 'package:pharmacy_pos/modules/purchase_return/views/purchase_return_details_page.dart';
import 'package:pharmacy_pos/modules/purchase_return/views/purchase_return_page.dart';
import 'package:pharmacy_pos/modules/root/views/root_page.dart';
import 'package:pharmacy_pos/modules/sale_product_report/bindings/sale_product_bindings.dart';
import 'package:pharmacy_pos/modules/sale_product_report/views/sale_product_page.dart';
import 'package:pharmacy_pos/modules/sale_return/views/sale_return_details_page.dart';
import 'package:pharmacy_pos/modules/sale_return/views/sale_return_page.dart';
import 'package:pharmacy_pos/modules/sales/bindings/sales_binding.dart';
import 'package:pharmacy_pos/modules/sales/views/create_sales_page.dart';
import 'package:pharmacy_pos/modules/sales/views/sales_page.dart';
import 'package:pharmacy_pos/modules/sales/views/update_sale_page.dart';
import 'package:pharmacy_pos/modules/stocks/views/stocks_page.dart';
import 'package:pharmacy_pos/modules/supplier/bindings/supplier_binding.dart';
import 'package:pharmacy_pos/modules/supplier/views/create_supplier_page.dart';
import 'package:pharmacy_pos/modules/supplier/views/supplier_page.dart';
import 'package:pharmacy_pos/modules/supplier/views/update_supplier_page.dart';
import 'package:pharmacy_pos/modules/transfer/bindings/transfer_binding.dart';
import 'package:pharmacy_pos/modules/transfer/views/create_transfer_page.dart';
import 'package:pharmacy_pos/modules/transfer/views/transfer_details_page.dart';
import 'package:pharmacy_pos/modules/transfer/views/transfer_page.dart';
import 'package:pharmacy_pos/modules/transfer/views/update_transfer_page.dart';
import 'package:pharmacy_pos/modules/units/views/create_unit_page.dart';
import 'package:pharmacy_pos/modules/units/views/unit_reports.dart';
import 'package:pharmacy_pos/modules/warehouse/bindings/warehouse_binding.dart';
import 'package:pharmacy_pos/modules/warehouse/views/warehouse_page.dart';

import '../modules/brands/bindings/brand_binding.dart';
import '../modules/brands/views/brand_page.dart';
import '../modules/brands/views/brand_reports.dart';
import '../modules/brands/views/create_brand_page.dart';
import '../modules/brands/views/update_brand_page.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_page.dart';
import '../modules/category/views/category_reports.dart';
import '../modules/category/views/create_category_page.dart';
import '../modules/category/views/update_category_page.dart';
import '../modules/product/views/product_details_page.dart';
import '../modules/product/views/product_page.dart';
import '../modules/purchase/views/create_purchase_return_page.dart';
import '../modules/purchase/views/purchase_details_page.dart';
import '../modules/purchase_product_report/bindings/purchase_product_binding.dart';
import '../modules/purchase_product_report/views/purchase_product_details.dart';
import '../modules/purchase_product_report/views/purchase_product_page.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/home_page.dart';
import '../modules/sale_product_report/views/sale_product_details.dart';
import '../modules/sale_return/bindings/sales_return_binding.dart';
import '../modules/sales/views/create_sale_return_page.dart';
import '../modules/sales/views/sales_details_page.dart';
import '../modules/stock_alert/views/stocks_alert_page.dart';
import '../modules/units/bindings/unit_binding.dart';
import '../modules/units/views/unit_page.dart';
import '../modules/units/views/update_unit_page.dart';
import '../modules/warehouse/views/create_warehouse_page.dart';
import '../modules/warehouse/views/update_warehouse_page.dart';

class Routes {
  static const root = '/';
  static const app = '/app';
  static const dashboard = '/dashboard';
  static const products = '/products';
  static const units = '/units';
  static const brands = '/brands';
  static const category = '/category';
  static const warehouses = '/warehouses';
  static const suppliers = '/suppliers';
  static const customers = '/customers';
  static const purchases = '/purchases';
  static const sales = '/sales';
  static const transfer = '/transfers';
  static const lostDamage = '/lost-damage';
  static const saleReturn = '/sale-return';
  static const purchaseReturn = '/purchase-return';
  static const stocks = '/stocks';
  static const stockAlert = '/stock-alert';
  static const bestSelling = '/best-selling-products';
  static const saleProduct = '/sale-product';
  static const purchaseProduct = '/purchase-product';
  static const create = '/create';
  static const update = '/update';
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
            binding: DashboardBinding(),
            page: () => const DashboardPage(),
            //preventDuplicates: true,
            //participatesInRootNavigator: true,
            //transition: Transition.downToUp
          ),
          GetPage(
              name: products,
              page: () => const ProductPage(),
              binding: ProductBinding(),
              //preventDuplicates: true,
              //transition: Transition.fade
              // participatesInRootNavigator: false,
              //preventDuplicates: false,
              //participatesInRootNavigator: true,
              children: [
                GetPage(
                    name: create,
                    page: () => const CreateProductPage(),
                    binding: ProductBinding()
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
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateProductPage(),
                  binding: ProductBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(products)],
                ),
                GetPage(
                  name: '/details/:id',
                  page: () => const ProductDetailsPage(),
                  binding: ProductBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
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
                  binding: UnitBinding(),
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
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateUnitPage(),
                  binding: UnitBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: brands,
              page: () => const BrandPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateBrandPage(),
                  binding: BrandBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: report,
                  page: () => const BrandReportPage(),
                  // preventDuplicates: true,
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateBrandPage(),
                  binding: BrandBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(brands)],
                ),
              ]),
          GetPage(
              name: category,
              page: () => const CategoryPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateCategoryPage(),
                  binding: CategoryBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: report,
                  page: () => const CategoryReportPage(),
                  // preventDuplicates: true,
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateCategoryPage(),
                  binding: CategoryBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(category)],
                ),
              ]),
          GetPage(
              name: warehouses,
              page: () => const WarehousePage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateWarehousePage(),
                  binding: WarehouseBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateWarehousePage(),
                  binding: WarehouseBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: suppliers,
              page: () => const SupplierPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateSupplierPage(),
                  binding: SupplierBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateSupplierPage(),
                  binding: SupplierBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: customers,
              page: () => const CustomerPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateCustomerPage(),
                  binding: CustomerBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateCustomerPage(),
                  binding: CustomerBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: purchases,
              page: () => const PurchasePage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreatePurchasePage(),
                  binding: PurchaseBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '/return/:id',
                  page: () => const CreatePurchaseReturnPage(),
                  binding: PurchaseBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdatePurchasePage(),
                  binding: PurchaseBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
                GetPage(
                  name: '/details/:id',
                  page: () => const PurchaseDetailsPage(),
                  binding: PurchaseBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: sales,
              page: () => const SalesPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateSalesPage(),
                  binding: SalesBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '/return/:id',
                  page: () => const CreateSaleReturnPage(),
                  binding: SalesBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateSalesPage(),
                  binding: SalesBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
                GetPage(
                  name: '/details/:id',
                  page: () => const SalesDetailsPage(),
                  binding: SalesBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: stocks,
              page: () => const StocksPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: const [
                // GetPage(
                //   name: create,
                //   page: () => const CreateSalesPage(),
                //   binding: SalesBinding(),
                //   //preventDuplicates: false,
                //   //arguments: const {"data": "create"}
                //   //transition: Transition.zoom
                //   //participatesInRootNavigator: false,
                // ),
              ]),
          GetPage(
              name: stockAlert,
              page: () => const StockAlertPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: const [
                // GetPage(
                //   name: create,
                //   page: () => const CreateSalesPage(),
                //   binding: SalesBinding(),
                //   //preventDuplicates: false,
                //   //arguments: const {"data": "create"}
                //   //transition: Transition.zoom
                //   //participatesInRootNavigator: false,
                // ),
              ]),
          GetPage(
              name: saleProduct,
              page: () => const SaleProductPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                // GetPage(
                //   name: create,
                //   page: () => const CreateSalesPage(),
                //   binding: SalesBinding(),
                //   //preventDuplicates: false,
                //   //arguments: const {"data": "create"}
                //   //transition: Transition.zoom
                //   //participatesInRootNavigator: false,
                // ),
                GetPage(
                  name: '/details/:id',
                  page: () => const SaleProductDetailsPage(),
                  binding: SaleProductBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: purchaseProduct,
              page: () => const PurchaseProductPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                // GetPage(
                //   name: create,
                //   page: () => const CreateSalesPage(),
                //   binding: SalesBinding(),
                //   //preventDuplicates: false,
                //   //arguments: const {"data": "create"}
                //   //transition: Transition.zoom
                //   //participatesInRootNavigator: false,
                // ),
                GetPage(
                  name: '/details/:id',
                  page: () => const PurchaseProductDetailsPage(),
                  binding: PurchaseProductBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: bestSelling,
              page: () => const BestSellingProductPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: const [
                // GetPage(
                //   name: create,
                //   page: () => const CreateSalesPage(),
                //   binding: SalesBinding(),
                //   //preventDuplicates: false,
                //   //arguments: const {"data": "create"}
                //   //transition: Transition.zoom
                //   //participatesInRootNavigator: false,
                // ),
                // GetPage(
                //   name: '/details/:id',
                //   page: () => const SaleProductDetailsPage(),
                //   binding: SaleProductBinding(),
                //   preventDuplicates: true,
                //   //transition: Transition.zoom
                //   participatesInRootNavigator: false,
                //   //middlewares: [UpdateMiddleware(units)],
                // ),
              ]),
          GetPage(
              name: transfer,
              page: () => const TransferPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateTransferPage(),
                  binding: TransferBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
                GetPage(
                  name: '$update/:id',
                  page: () => const UpdateTransferPage(),
                  binding: TransferBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
                GetPage(
                  name: '/details/:id',
                  page: () => const TransferDetailsPage(),
                  binding: TransferBinding(),
                  preventDuplicates: true,
                  //transition: Transition.zoom
                  participatesInRootNavigator: false,
                  //middlewares: [UpdateMiddleware(units)],
                ),
              ]),
          GetPage(
              name: lostDamage,
              page: () => const LostDamagePage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: create,
                  page: () => const CreateLostDamagePage(),
                  binding: LostDamageBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
              ]),
          GetPage(
              name: saleReturn,
              page: () => const SaleReturnPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: '/details/:id',
                  page: () => const SalesReturnDetailsPage(),
                  binding: SalesReturnBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
              ]),
          GetPage(
              name: purchaseReturn,
              page: () => const PurchaseReturnPage(),
              // preventDuplicates: true,
              //transition: Transition.zoom
              //participatesInRootNavigator: false,
              children: [
                GetPage(
                  name: '/details/:id',
                  page: () => const PurchaseReturnDetailsPage(),
                  binding: PurchaseReturnBinding(),
                  //preventDuplicates: false,
                  //arguments: const {"data": "create"}
                  //transition: Transition.zoom
                  //participatesInRootNavigator: false,
                ),
              ]),
        ]),
    // GetPage(
    //   name: register,
    //   page: () => const LoginPage(),
    //   binding: AuthBinding(),
    //   preventDuplicates: false,
    //   participatesInRootNavigator: true,
    //   // middlewares: [AuthMiddleware()],
    // ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      preventDuplicates: false,
      participatesInRootNavigator: true,
      middlewares: [RootMiddleware()],
    ),
  ];
}
