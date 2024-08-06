import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/root/controller/root_controller.dart';
import '../../../routes/routes.dart';

class RootPage extends GetView<RootController> {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('PHARMACY POS'),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              controller.logOut();
            },
            child: const CircleAvatar(
              radius: 50,
              child: FlutterLogo(),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Sidebar(controller: controller),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: GetRouterOutlet(
                initialRoute: '${Routes.app}/${Routes.dashboard}',
                anchorRoute: Routes.app,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final RootController controller;

  const Sidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IndexedRouteBuilder(
      routes: const [
        '${Routes.app}${Routes.dashboard}',
        '${Routes.app}${Routes.dashboard}',
        '${Routes.app}${Routes.products}',
        '${Routes.app}${Routes.units}'
      ],
      builder: (context, routes, index) {
        controller.currentIndex(index);
        controller.expandedIndex.value = index;
        _updateSubIndex(controller);
        return Obx(() => Container(
              alignment: Alignment.topCenter,
              color: Colors.blueGrey.withOpacity(0.1),
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
                    );
                  },
                ),
              ),
            ));
      },
    );
  }

  void _updateSubIndex(RootController controller) {
    final urlList = Uri.base.path.split('/');
    switch (urlList.last) {
      case "create":
        controller.currentSubIndex(1);
        break;
      case "reports":
        controller.currentSubIndex(2);
        break;
      default:
        controller.currentSubIndex(0);
        break;
    }
  }
}

class SidebarExpansionTile extends StatelessWidget {
  final RootController controller;
  final int index;
  final List<String> routes;

  const SidebarExpansionTile({
    super.key,
    required this.controller,
    required this.index,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    final delegate = context.delegate;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: Key(index.toString()),
        collapsedTextColor:
            _isSelected(controller.currentIndex.value, index, context),
        textColor: _isSelected(controller.currentIndex.value, index, context),
        collapsedBackgroundColor:
            _getBackgroundColor(controller.currentIndex.value, index),
        backgroundColor:
            _getBackgroundColor(controller.currentIndex.value, index),
        initiallyExpanded: index == controller.expandedIndex.value,
        leading: controller.sidebarList[index]['icon'] != null
            ? Icon(controller.sidebarList[index]['icon'])
            : null,
        title: Text(controller.sidebarList[index]['title']),
        trailing: controller.sidebarList[index]['trailing'],
        enabled: controller.sidebarList[index]['enable'],
        onExpansionChanged: (newState) {
          // bool val = Get.find<CheckAuthService>().authed.value;
          // print(val);
          // print(index);
          // print(newState);

          controller.expandedIndex.value = newState ? index : -1;
          controller.currentSubIndex(0);
          controller.currentIndex(index);
          delegate.toNamed(routes[controller.currentIndex.value]);
        },
        children: _buildSubMenuItems(index, context),
      ),
    );
  }

  List<Widget> _buildSubMenuItems(int index, BuildContext context) {
    if (index == 0) return [];
    return [
      if (index == 2)
        _buildSubMenuItem(
            title: "Create Product",
            subIndex: 1,
            routeSuffix: Routes.create,
            context: context),
      if (index == 2)
        _buildSubMenuItem(
            title: "Product Reports",
            subIndex: 2,
            routeSuffix: Routes.report,
            context: context),
      if (index == 3)
        _buildSubMenuItem(
            title: "Create Unit",
            subIndex: 1,
            routeSuffix: Routes.create,
            context: context),
      if (index == 3)
        _buildSubMenuItem(
            title: "Unit Reports",
            subIndex: 2,
            routeSuffix: Routes.report,
            context: context),
    ];
  }

  Widget _buildSubMenuItem(
      {required String title,
      required int subIndex,
      required String routeSuffix,
      required BuildContext context}) {
    return Obx(() {
      return Ink(
        color: controller.currentSubIndex.value == subIndex
            ? Colors.blueGrey.withOpacity(0.3)
            : null,
        child: ListTile(
          leading: const SizedBox.shrink(),
          selected: controller.currentSubIndex.value == subIndex,
          onTap: () {
            controller.currentSubIndex(subIndex);
            context.delegate.toNamed(
                '${routes[controller.currentIndex.value]}$routeSuffix');
          },
          title: Text(title),
        ),
      );
    });
  }

  Color? _getBackgroundColor(int currentIndex, int index) {
    return currentIndex == index ? Colors.blueGrey.withOpacity(0.2) : null;
  }

  Color? _isSelected(int currentIndex, int index, BuildContext context) {
    return currentIndex == index ? Theme.of(context).primaryColor : null;
  }
}
