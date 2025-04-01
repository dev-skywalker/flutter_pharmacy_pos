import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/root/controller/root_controller.dart';
import '../../../routes/routes.dart';

class RootPage extends GetView<RootController> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width >= 980;
    return Scaffold(
      key: _scaffoldKey,
      drawer: isSmallScreen
          ? null
          : Drawer(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blueGrey.withOpacity(0.1),
                      height: 50,
                    ),
                    Sidebar(
                        controller: controller, isSmallScreen: isSmallScreen),
                  ],
                ),
              ),
            ),
      appBar: AppBar(
        elevation: 5,
        title: const Text(
          'PHARMACY POS',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: isSmallScreen
            ? null
            : IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu)),
        actions: [
          InkWell(
            onTap: () {
              controller.logOut();
            },
            child: const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          isSmallScreen
              ? Expanded(
                  flex: 1,
                  child: Sidebar(
                      controller: controller, isSmallScreen: isSmallScreen),
                )
              : Container(),
          Expanded(
            flex: 4,
            child: GetRouterOutlet(
              initialRoute: '${Routes.app}/${Routes.dashboard}',
              anchorRoute: Routes.app,
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final RootController controller;
  final bool isSmallScreen;

  const Sidebar(
      {super.key, required this.controller, required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return IndexedRouteBuilder(
      routes: const [
        '${Routes.app}${Routes.dashboard}',
        '${Routes.app}${Routes.dashboard}',
        '${Routes.app}${Routes.products}',
        '${Routes.app}${Routes.units}',
        '${Routes.app}${Routes.category}',
        '${Routes.app}${Routes.warehouses}'
      ],
      builder: (context, routes, index) {
        _updateSubIndex(controller);
        return Obx(() => Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              //elevation: 1,
              child: Container(
                alignment: Alignment.topCenter,
                //color: Colors.blueGrey.withOpacity(0.1),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    key: Key('builder ${controller.expandedIndex.value}'),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.sidebarList.length,
                    itemBuilder: (context, index) {
                      return SidebarExpansionTile(
                        controller: controller,
                        index: index,
                        routes: routes,
                        isSmallScreen: isSmallScreen,
                      );
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }

  void _updateSubIndex(RootController controller) {
    final urlList = Uri.base.path.split('/');
    if (urlList.last == "create") {
      switch (urlList[urlList.length - 2]) {
        case "products":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(1);
          break;
        case "units":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(2);
          break;
        case "brands":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(3);
          break;
        case "category":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(4);
          break;
        case "warehouses":
          controller.currentIndex(6);
          controller.activeMainIndex(6);
          controller.expandedIndex.value = -1;
          controller.currentSubIndex(0);
          break;
        case "suppliers":
          controller.currentIndex(5);
          controller.activeMainIndex(5);
          controller.expandedIndex.value = 5;
          controller.currentSubIndex(1);
          break;
        case "customers":
          controller.currentIndex(5);
          controller.activeMainIndex(5);
          controller.expandedIndex.value = 5;
          controller.currentSubIndex(2);
          break;
        case "purchases":
          controller.currentIndex(2);
          controller.activeMainIndex(2);
          controller.expandedIndex.value = 2;
          controller.currentSubIndex(1);
          break;
        case "sales":
          controller.currentIndex(3);
          controller.activeMainIndex(3);
          controller.expandedIndex.value = 3;
          controller.currentSubIndex(1);
          break;
        case "transfers":
          controller.currentIndex(4);
          controller.activeMainIndex(4);
          controller.expandedIndex.value = 4;
          controller.currentSubIndex(1);
          break;
        case "lost-damage":
          controller.currentIndex(4);
          controller.activeMainIndex(4);
          controller.expandedIndex.value = 4;
          controller.currentSubIndex(2);
        default:
          controller.currentSubIndex(0);
          break;
      }
    } else if (urlList[urlList.length - 2] == "update") {
      switch (urlList[urlList.length - 3]) {
        case "products":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(1);
          break;
        case "units":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(2);
          break;
        case "brands":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(3);
          break;
        case "category":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(4);
          break;
        case "warehouses":
          controller.currentIndex(6);
          controller.activeMainIndex(6);
          controller.expandedIndex.value = -1;
          controller.currentSubIndex(0);
          break;
        case "suppliers":
          controller.currentIndex(5);
          controller.activeMainIndex(5);
          controller.expandedIndex.value = 5;
          controller.currentSubIndex(1);
          break;
        case "customers":
          controller.currentIndex(5);
          controller.activeMainIndex(5);
          controller.expandedIndex.value = 5;
          controller.currentSubIndex(2);
          break;
        case "purchases":
          controller.currentIndex(2);
          controller.activeMainIndex(2);
          controller.expandedIndex.value = 2;
          controller.currentSubIndex(1);
          break;
        case "sales":
          controller.currentIndex(3);
          controller.activeMainIndex(3);
          controller.expandedIndex.value = 3;
          controller.currentSubIndex(1);
          break;

        default:
          controller.currentSubIndex(0);
          break;
      }
    } else if (urlList[urlList.length - 2] == "details") {
      switch (urlList[urlList.length - 3]) {
        case "purchases":
          controller.currentIndex(2);
          controller.activeMainIndex(2);
          controller.expandedIndex.value = 2;
          controller.currentSubIndex(1);
          break;
        case "products":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(1);
          break;
        case "sales":
          controller.currentIndex(3);
          controller.activeMainIndex(3);
          controller.expandedIndex.value = 3;
          controller.currentSubIndex(1);
          break;
        case "transfers":
          controller.currentIndex(4);
          controller.activeMainIndex(4);
          controller.expandedIndex.value = 4;
          controller.currentSubIndex(1);
          break;
        case "purchase-return":
          controller.currentIndex(2);
          controller.activeMainIndex(2);
          controller.expandedIndex.value = 2;
          controller.currentSubIndex(2);
          break;
        case "sale-return":
          controller.currentIndex(3);
          controller.activeMainIndex(3);
          controller.expandedIndex.value = 3;
          controller.currentSubIndex(2);
          break;
        case "sale-product":
          controller.currentIndex(7);
          controller.activeMainIndex(7);
          controller.expandedIndex.value = 7;
          controller.currentSubIndex(3);
          break;
        case "purchase-product":
          controller.currentIndex(7);
          controller.activeMainIndex(7);
          controller.expandedIndex.value = 7;
          controller.currentSubIndex(4);
          break;
        default:
          controller.currentSubIndex(0);
          break;
      }
    } else if (urlList[urlList.length - 2] == "return") {
      switch (urlList[urlList.length - 3]) {
        case "purchases":
          controller.currentIndex(2);
          controller.activeMainIndex(2);
          controller.expandedIndex.value = 2;
          controller.currentSubIndex(1);
          break;
        case "sales":
          controller.currentIndex(3);
          controller.activeMainIndex(3);
          controller.expandedIndex.value = 3;
          controller.currentSubIndex(1);
          break;

        default:
          controller.currentSubIndex(0);
          break;
      }
    } else {
      switch (urlList.last) {
        case "products":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(1);
          break;
        case "units":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;

          controller.currentSubIndex(2);
          break;
        case "brands":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(3);
          break;
        case "category":
          controller.currentIndex(1);
          controller.activeMainIndex(1);
          controller.expandedIndex.value = 1;
          controller.currentSubIndex(4);
          break;
        case "purchases":
          controller.currentIndex(2);
          controller.activeMainIndex(2);
          controller.expandedIndex.value = 2;
          controller.currentSubIndex(1);
          break;
        case "sales":
          controller.currentIndex(3);
          controller.activeMainIndex(3);
          controller.expandedIndex.value = 3;
          controller.currentSubIndex(1);
          break;
        case "transfers":
          controller.currentIndex(4);
          controller.activeMainIndex(4);
          controller.expandedIndex.value = 4;
          controller.currentSubIndex(1);
          break;
        case "stocks":
          controller.currentIndex(7);
          controller.activeMainIndex(7);
          controller.expandedIndex.value = 7;
          controller.currentSubIndex(1);
          break;
        case "stock-alert":
          controller.currentIndex(7);
          controller.activeMainIndex(7);
          controller.expandedIndex.value = 7;
          controller.currentSubIndex(2);
          break;
        case "sale-product":
          controller.currentIndex(7);
          controller.activeMainIndex(7);
          controller.expandedIndex.value = 7;
          controller.currentSubIndex(3);
          break;
        case "purchase-product":
          controller.currentIndex(7);
          controller.activeMainIndex(7);
          controller.expandedIndex.value = 7;
          controller.currentSubIndex(4);
          break;
        case "best-selling-products":
          controller.currentIndex(7);
          controller.activeMainIndex(7);
          controller.expandedIndex.value = 7;
          controller.currentSubIndex(5);
          break;
        case "warehouses":
          controller.currentIndex(6);
          controller.activeMainIndex(6);
          controller.expandedIndex.value = -1;
          controller.currentSubIndex(0);
          break;
        case "suppliers":
          controller.currentIndex(5);
          controller.activeMainIndex(5);
          controller.expandedIndex.value = 5;
          controller.currentSubIndex(1);
          break;
        case "customers":
          controller.currentIndex(5);
          controller.activeMainIndex(5);
          controller.expandedIndex.value = 5;
          controller.currentSubIndex(2);
          break;
        case "lost-damage":
          controller.currentIndex(4);
          controller.activeMainIndex(4);
          controller.expandedIndex.value = 4;
          controller.currentSubIndex(2);
          break;
        case "sale-return":
          controller.currentIndex(3);
          controller.activeMainIndex(3);
          controller.expandedIndex.value = 3;
          controller.currentSubIndex(2);
          break;
        case "purchase-return":
          controller.currentIndex(2);
          controller.activeMainIndex(2);
          controller.expandedIndex.value = 2;
          controller.currentSubIndex(2);
          break;
        default:
          controller.currentSubIndex(0);
          break;
      }
    }
  }
}

class SidebarExpansionTile extends StatelessWidget {
  final RootController controller;
  final int index;
  final bool isSmallScreen;
  final List<String> routes;

  const SidebarExpansionTile({
    super.key,
    required this.controller,
    required this.index,
    required this.routes,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final delegate = context.delegate;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Obx(() {
        return ExpansionTile(
          key: Key(index.toString()),
          collapsedTextColor:
              _isSelected(controller.currentIndex.value, index, context),
          textColor: _isSelected(controller.currentIndex.value, index, context),
          collapsedBackgroundColor: _getBackgroundColor(
              controller.currentIndex.value, index, context),
          backgroundColor: _getBackgroundColor(
              controller.currentIndex.value, index, context),
          initiallyExpanded: index == controller.expandedIndex.value,
          leading: controller.sidebarList[index]['icon'] != null
              ? Icon(controller.sidebarList[index]['icon'])
              : null,
          title: Text(controller.sidebarList[index]['title']),
          trailing: controller.sidebarList[index]['trailing'],
          enabled: controller.sidebarList[index]['enable'],
          onExpansionChanged: (newState) {
            controller.expandedIndex.value = newState ? index : -1;

            if (index == 0) {
              controller.currentIndex(0);
              controller.activeMainIndex(0);
              controller.currentSubIndex(0);
              delegate.toNamed("${Routes.app}${Routes.dashboard}");
              if (!isSmallScreen) {
                Navigator.of(context).pop();
              }
            }
            if (index == 6) {
              controller.currentIndex(6);
              controller.activeMainIndex(6);
              controller.currentSubIndex(0);
              delegate.toNamed("${Routes.app}${Routes.warehouses}");
              if (!isSmallScreen) {
                Navigator.of(context).pop();
              }
            }
            //
          },
          children: _buildSubMenuItems(index, context, isSmallScreen),
        );
      }),
    );
  }

  List<Widget> _buildSubMenuItems(
      int index, BuildContext context, bool isSmallScreen) {
    if (index == 0) return [];
    if (index == 6) return [];
    return [
      if (index == 1)
        _buildSubMenuItem(
            title: "Products",
            icon: const Icon(Icons.list),
            subIndex: 1,
            routeSuffix: Routes.products,
            context: context,
            index: 1,
            isSmallScreen: isSmallScreen),
      if (index == 1)
        _buildSubMenuItem(
            title: "Units",
            icon: const Icon(Icons.view_in_ar),
            subIndex: 2,
            routeSuffix: Routes.units,
            context: context,
            index: 1,
            isSmallScreen: isSmallScreen),
      if (index == 1)
        _buildSubMenuItem(
            title: "Brands",
            icon: const Icon(Icons.hdr_auto),
            subIndex: 3,
            routeSuffix: Routes.brands,
            context: context,
            index: 1,
            isSmallScreen: isSmallScreen),
      if (index == 1)
        _buildSubMenuItem(
            title: "Category",
            icon: const Icon(Icons.category),
            subIndex: 4,
            routeSuffix: Routes.category,
            context: context,
            index: 1,
            isSmallScreen: isSmallScreen),
      if (index == 5)
        _buildSubMenuItem(
            title: "Supplier",
            icon: const Icon(Icons.person_4),
            subIndex: 1,
            routeSuffix: Routes.suppliers,
            context: context,
            index: 5,
            isSmallScreen: isSmallScreen),
      if (index == 5)
        _buildSubMenuItem(
            title: "Customer",
            icon: const Icon(Icons.person),
            subIndex: 2,
            routeSuffix: Routes.customers,
            context: context,
            index: 5,
            isSmallScreen: isSmallScreen),
      if (index == 2)
        _buildSubMenuItem(
            title: "Purchases",
            icon: const Icon(Icons.move_to_inbox),
            subIndex: 1,
            routeSuffix: Routes.purchases,
            context: context,
            index: 2,
            isSmallScreen: isSmallScreen),
      if (index == 2)
        _buildSubMenuItem(
            title: "Purchase Return",
            icon: const Icon(Icons.settings_backup_restore),
            subIndex: 2,
            routeSuffix: Routes.purchaseReturn,
            context: context,
            index: 2,
            isSmallScreen: isSmallScreen),
      if (index == 3)
        _buildSubMenuItem(
            title: "Sales",
            icon: const Icon(Icons.storefront_outlined),
            subIndex: 1,
            routeSuffix: Routes.sales,
            context: context,
            index: 3,
            isSmallScreen: isSmallScreen),
      if (index == 3)
        _buildSubMenuItem(
            title: "Sale Return",
            icon: const Icon(Icons.settings_backup_restore),
            subIndex: 2,
            routeSuffix: Routes.saleReturn,
            context: context,
            index: 3,
            isSmallScreen: isSmallScreen),
      if (index == 4)
        _buildSubMenuItem(
            title: "Transfers",
            icon: const Icon(Icons.sync_alt),
            subIndex: 1,
            routeSuffix: Routes.transfer,
            context: context,
            index: 4,
            isSmallScreen: isSmallScreen),
      if (index == 4)
        _buildSubMenuItem(
            title: "Lost Damage",
            icon: const Icon(Icons.delete_forever),
            subIndex: 2,
            routeSuffix: Routes.lostDamage,
            context: context,
            index: 4,
            isSmallScreen: isSmallScreen),
      if (index == 7)
        _buildSubMenuItem(
            title: "Stocks",
            icon: const Icon(Icons.inventory_2),
            subIndex: 1,
            routeSuffix: Routes.stocks,
            context: context,
            index: 7,
            isSmallScreen: isSmallScreen),
      if (index == 7)
        _buildSubMenuItem(
            title: "Stock Alert",
            icon: const Icon(Icons.notifications),
            subIndex: 2,
            routeSuffix: Routes.stockAlert,
            context: context,
            index: 7,
            isSmallScreen: isSmallScreen),
      if (index == 7)
        _buildSubMenuItem(
            title: "Sale Product Report",
            icon: const Icon(Icons.shopping_cart),
            subIndex: 3,
            routeSuffix: Routes.saleProduct,
            context: context,
            index: 7,
            isSmallScreen: isSmallScreen),
      if (index == 7)
        _buildSubMenuItem(
            title: "Purchase Product Report",
            icon: const Icon(Icons.add_shopping_cart),
            subIndex: 4,
            routeSuffix: Routes.purchaseProduct,
            context: context,
            index: 7,
            isSmallScreen: isSmallScreen),
      if (index == 7)
        _buildSubMenuItem(
            title: "Best Selling Product",
            icon: const Icon(Icons.clear_all),
            subIndex: 5,
            routeSuffix: Routes.bestSelling,
            context: context,
            index: 7,
            isSmallScreen: isSmallScreen),
      // if (index == 2)
      //   _buildSubMenuItem(
      //       title: "Purchases Return",
      //       icon: const Icon(Icons.person),
      //       subIndex: 2,
      //       routeSuffix: Routes.purchases,
      //       context: context,
      //       index: 2,
      //       isSmallScreen: isSmallScreen),
      // if (index == 4)
      //   _buildSubMenuItem(
      //       title: "Category",
      //       icon: const Icon(Icons.view_in_ar),
      //       subIndex: 1,
      //       routeSuffix: '',
      //       context: context,
      //       index: 4,
      //       isSmallScreen: isSmallScreen),
      // if (index == 4)
      //   _buildSubMenuItem(
      //       title: "Create Category",
      //       icon: const Icon(Icons.view_in_ar),
      //       subIndex: 2,
      //       routeSuffix: Routes.create,
      //       context: context,
      //       index: 4,
      //       isSmallScreen: isSmallScreen),
      // if (index == 4)
      //   _buildSubMenuItem(
      //       title: "Category Reports",
      //       icon: const Icon(Icons.view_in_ar),
      //       subIndex: 3,
      //       routeSuffix: Routes.report,
      //       context: context,
      //       index: 4,
      //       isSmallScreen: isSmallScreen),
      // if (index == 5)
      //   _buildSubMenuItem(
      //       title: "Brands",
      //       icon: const Icon(Icons.view_in_ar),
      //       subIndex: 1,
      //       routeSuffix: '',
      //       context: context,
      //       index: 5,
      //       isSmallScreen: isSmallScreen),
      // if (index == 5)
      //   _buildSubMenuItem(
      //       icon: const Icon(Icons.view_in_ar),
      //       title: "Create Brand",
      //       subIndex: 2,
      //       routeSuffix: Routes.create,
      //       context: context,
      //       index: 5,
      //       isSmallScreen: isSmallScreen),
      // if (index == 5)
      //   _buildSubMenuItem(
      //       icon: const Icon(Icons.view_in_ar),
      //       title: "Brand Reports",
      //       subIndex: 3,
      //       routeSuffix: Routes.report,
      //       context: context,
      //       index: 5,
      //       isSmallScreen: isSmallScreen),
    ];
  }

  Widget _buildSubMenuItem(
      {required String title,
      required int subIndex,
      required int index,
      required Widget icon,
      required String routeSuffix,
      required bool isSmallScreen,
      required BuildContext context}) {
    return Obx(() {
      return Ink(
        color: controller.currentSubIndex.value == subIndex &&
                controller.activeMainIndex.value == index
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 36.0, right: 0.0),
          leading: icon,
          selected: controller.currentSubIndex.value == subIndex &&
              controller.activeMainIndex.value == index,
          onTap: () {
            controller.currentIndex(index);
            controller.currentSubIndex(subIndex);
            controller.activeMainIndex(controller.currentIndex.value);
            context.delegate.toNamed('${Routes.app}$routeSuffix');
            if (!isSmallScreen) {
              Navigator.of(context).pop();
            }
          },
          title: Text(title),
        ),
      );
    });
  }

  Color? _getBackgroundColor(
      int currentIndex, int index, BuildContext context) {
    return currentIndex == index ? Colors.blueGrey.withOpacity(0.1) : null;
  }

  Color? _isSelected(int currentIndex, int index, BuildContext context) {
    return currentIndex == index ? Theme.of(context).primaryColor : null;
  }
}
