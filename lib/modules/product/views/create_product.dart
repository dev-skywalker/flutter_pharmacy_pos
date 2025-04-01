import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:pharmacy_pos/modules/product/controllers/product_controller.dart';
import 'package:pharmacy_pos/modules/product/views/widgets/custom_textfield.dart';
import 'package:pharmacy_pos/modules/supplier/model/supplier_model.dart';
import 'package:pharmacy_pos/modules/units/model/unit_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../routes/routes.dart';
import '../../brands/model/brand_model.dart';
import '../../category/model/category_model.dart';

class CreateProductPage extends GetView<ProductController> {
  const CreateProductPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create New Product"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.products}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.createProductFormKey.currentState!.validate();
              if (isValidate) {
                //

                if (controller.expansionTileController.isExpanded) {
                  bool stockValidate = controller
                      .createStockProductFormKey.currentState!
                      .validate();
                  if (stockValidate) {
                    controller.createProduct();
                    print("OK");
                  }
                } else {
                  print(" Not Expen");
                  controller.createProduct();
                }

                // if(isVal){

                // }
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      //body: _createProductWidget(context),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 16, bottom: 200),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Form(
                key: controller.createProductFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveGridRow(
                      children: [
                        ResponsiveGridCol(
                          sm: 12, // 1 column on mobile
                          md: 6, // 2 columns on tablet
                          lg: 4, // 3 columns on desktop
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                CustomTextField(
                                  isNumber: false,
                                  controller: controller.brandNameController,
                                  label: "Product Name/Brand Name:",
                                  hint: "Product Name",
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Product Name is required!';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Chemical Name/Other Name:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Obx(() {
                                      return Wrap(
                                        children: List<Widget>.generate(
                                          controller.chemicalNameList.length,
                                          (int idx) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8, bottom: 6),
                                              child: Chip(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                deleteIcon: const Icon(
                                                  Icons.clear,
                                                  size: 18,
                                                  color: Colors.red,
                                                ),
                                                onDeleted: () {
                                                  controller.chemicalNameList
                                                      .removeAt(idx);
                                                },
                                                clipBehavior: Clip.antiAlias,
                                                label: Text(controller
                                                    .chemicalNameList[idx]),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      );
                                    }),
                                    TextFormField(
                                      controller:
                                          controller.chemicalNameController,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: const OutlineInputBorder(),
                                          hintText: "Chemical Name",
                                          suffix: TextButton.icon(
                                            label: const Text("Add"),
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              if (controller
                                                  .chemicalNameController
                                                  .text
                                                  .isNotEmpty) {
                                                controller.chemicalNameList.add(
                                                    controller
                                                        .chemicalNameController
                                                        .text);
                                                controller
                                                    .chemicalNameController
                                                    .clear();
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Category:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Obx(() {
                                      return DropdownSearch<
                                          Category>.multiSelection(
                                        popupProps:
                                            const PopupPropsMultiSelection.menu(
                                          showSearchBox: true,

                                          constraints:
                                              BoxConstraints(maxHeight: 250),
                                          searchDelay: Duration.zero,
                                          searchFieldProps: TextFieldProps(
                                              decoration: InputDecoration(
                                                  hintText: "Search Category")
                                              //autofocus: true
                                              ),

                                          showSelectedItems: true,
                                          //disabledItemFn: (String s) => s.startsWith('I'),
                                        ),
                                        compareFn: (item, selectedItem) =>
                                            item.id == selectedItem.id,
                                        //items: controller.categoryList,

                                        asyncItems: (String filter) =>
                                            controller.getAllCategory(),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "Choose Category",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        onChanged: (selectedItems) {
                                          controller.selectedCatLists.value =
                                              selectedItems;
                                        },
                                        selectedItems:
                                            controller.selectedCatLists.value,
                                        itemAsString: (Category category) =>
                                            category.name,
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Quantity Limit:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller:
                                          controller.quantityLimitController,
                                      decoration: const InputDecoration(
                                          hintText: "Quantity Limit",
                                          border: OutlineInputBorder()),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          sm: 12, // 1 column on mobile
                          md: 6, // 2 columns on tablet
                          lg: 4, // 3 columns on desktop
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Company/Brand:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Obx(() {
                                      return DropdownSearch<Brands>(
                                        validator: (value) {
                                          if (controller.selectedBrand.value ==
                                                  null ||
                                              value == null) {
                                            return 'Brand is required!';
                                          }
                                          return null;
                                        },
                                        popupProps: const PopupProps.menu(
                                          constraints:
                                              BoxConstraints(maxHeight: 200),
                                          searchDelay: Duration.zero,
                                        ),
                                        asyncItems: (String filter) =>
                                            controller.getAllBrands(),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "Brand",
                                            labelText: "Brand",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        selectedItem:
                                            controller.selectedBrand.value,
                                        onChanged: (value) {
                                          controller.selectedBrand.value =
                                              value!;
                                        },
                                        itemAsString: (Brands brand) =>
                                            brand.name,
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Text("Unit:"),
                                        Text(
                                          " *",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Obx(() {
                                      return DropdownSearch<Units>(
                                        validator: (value) {
                                          if (controller.selectedUnit.value ==
                                                  null ||
                                              value == null) {
                                            return 'Unit is required!';
                                          }
                                          return null;
                                        },
                                        popupProps: const PopupProps.menu(
                                          constraints:
                                              BoxConstraints(maxHeight: 200),
                                          searchDelay: Duration.zero,
                                        ),
                                        asyncItems: (String filter) =>
                                            controller.getAllUnits(),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "Unit",
                                            labelText: "Unit",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        selectedItem:
                                            controller.selectedUnit.value,
                                        onChanged: (value) {
                                          controller.selectedUnit.value =
                                              value!;
                                        },
                                        itemAsString: (Units unit) => unit.name,
                                      );
                                    }),
                                  ],
                                ),
                                Obx(() {
                                  return controller.selectedUnit.value?.name
                                              .toLowerCase() ==
                                          "card"
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: CustomTextField(
                                                    isNumber: true,
                                                    controller: controller
                                                        .tabletOnCardController,
                                                    label: "Tablets on card",
                                                    hint: "Tablets on card",
                                                    isRequired: false),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Flexible(
                                                  child: CustomTextField(
                                                      isNumber: true,
                                                      controller: controller
                                                          .cardOnBoxController,
                                                      label: "Cards on box",
                                                      hint: "Cards on box",
                                                      isRequired: false)),
                                            ],
                                          ),
                                        )
                                      : Container();
                                }),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Expire Date:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Expire Date is required!';
                                        }
                                        return null;
                                      },
                                      readOnly: true,
                                      controller:
                                          controller.expireDateController,
                                      decoration: const InputDecoration(
                                          hintText: "Expire Date",
                                          border: OutlineInputBorder()),
                                      onTap: () =>
                                          controller.selectDate(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Local Product:"),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black54),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Obx(() {
                                        return Theme(
                                          data: ThemeData(useMaterial3: false),
                                          child: SwitchListTile(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              // inactiveThumbColor: Colors.red,
                                              // activeTrackColor: Colors.lightGreen,
                                              // inactiveTrackColor: Colors.grey,
                                              title:
                                                  const Text("Local Product"),
                                              value: controller
                                                  .isLocalProduct.value,
                                              onChanged: (v) => controller
                                                  .isLocalProduct.value = v),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          sm: 12, // 1 column on mobile
                          md: 6, // 2 columns on tablet
                          lg: 4, // 3 columns on desktop
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Note:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    TextFormField(
                                      maxLines: 3,
                                      controller:
                                          controller.descriptionController,
                                      decoration: const InputDecoration(
                                          hintText: "Write Notes",
                                          border: OutlineInputBorder()),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Product Image:",
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Obx(() {
                                      return controller.hasImage.value
                                          ? Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                SizedBox(
                                                    //width: 200,
                                                    height: 150,
                                                    child: Center(
                                                      child: Image.memory(
                                                          controller.imageData
                                                              as Uint8List),
                                                    )),
                                                IconButton(
                                                    onPressed: () {
                                                      controller.imageData =
                                                          null;
                                                      controller.hasImage
                                                          .value = false;
                                                    },
                                                    icon: const Icon(
                                                      Icons.clear,
                                                      color: Colors.red,
                                                    ))
                                              ],
                                            )
                                          :
                                          // ElevatedButton(
                                          //     onPressed: () {
                                          //       controller.pickProductImage();
                                          //     },
                                          //     child: const Text("Pick Image"));
                                          InkWell(
                                              onTap: () {
                                                controller.pickProductImage();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.blueGrey
                                                        .withOpacity(0.3)),
                                                height: 80,
                                                //width: 200,
                                                child: const Center(
                                                  child: Icon(Icons.upload),
                                                ),
                                              ),
                                            );
                                    }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                    ResponsiveGridRow(
                      children: [
                        ResponsiveGridCol(
                          sm: 12, // 1 column on mobile
                          md: 6, // 2 columns on tablet
                          lg: 4, // 3 columns on desktop
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Product Cost:"),
                                const SizedBox(
                                  height: 6,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Product Cost is required!';
                                    }
                                    return null;
                                  },
                                  controller: controller.productCostController,
                                  decoration: const InputDecoration(
                                      hintText: "Product Cost",
                                      border: OutlineInputBorder()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          sm: 12, // 1 column on mobile
                          md: 6, // 2 columns on tablet
                          lg: 4, // 3 columns on desktop
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Product Price:"),
                                const SizedBox(
                                  height: 6,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Product Price is required!';
                                    }
                                    return null;
                                  },
                                  controller: controller.productPriceController,
                                  decoration: const InputDecoration(
                                      hintText: "Product Price",
                                      border: OutlineInputBorder()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          sm: 12, // 1 column on mobile
                          md: 6, // 2 columns on tablet
                          lg: 4, // 3 columns on desktop
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Stock Alert:"),
                                const SizedBox(
                                  height: 6,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: controller.stockAlertController,
                                  decoration: const InputDecoration(
                                      hintText: "Stock Alert",
                                      border: OutlineInputBorder()),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    controller: controller.expansionTileController,
                    // onExpansionChanged: (value) {
                    //   print(value);
                    //   controller.expansionTileController.
                    // },
                    title: const Text(
                      "Add Stock:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Form(
                        key: controller.createStockProductFormKey,
                        child: ResponsiveGridRow(
                          children: [
                            ResponsiveGridCol(
                                sm: 12, // 1 column on mobile
                                md: 6, // 2 columns on tablet
                                lg: 4, // 3 columns on desktop
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Product Quantity:"),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Product Quantity is required!';
                                          }
                                          return null;
                                        },
                                        controller:
                                            controller.quantityController,
                                        decoration: const InputDecoration(
                                            hintText: "Product Quantity",
                                            border: OutlineInputBorder()),
                                      ),
                                    ],
                                  ),
                                )),
                            ResponsiveGridCol(
                              sm: 12, // 1 column on mobile
                              md: 6, // 2 columns on tablet
                              lg: 4, // 3 columns on desktop
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Warehouse:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Obx(() {
                                      return DropdownSearch<WarehouseModel>(
                                        validator: (value) {
                                          if (controller.selectedWarehouse
                                                      .value ==
                                                  null ||
                                              value == null) {
                                            return 'Warehouse is required!';
                                          }
                                          return null;
                                        },
                                        popupProps: const PopupProps.menu(
                                          constraints:
                                              BoxConstraints(maxHeight: 200),
                                          searchDelay: Duration.zero,
                                        ),
                                        asyncItems: (String filter) =>
                                            controller.getAllWarehouses(),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "Choose Warehouse",
                                            labelText: "Warehouse",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        selectedItem:
                                            controller.selectedWarehouse.value,
                                        onChanged: (value) {
                                          controller.selectedWarehouse.value =
                                              value!;
                                        },
                                        itemAsString:
                                            (WarehouseModel warehouse) =>
                                                warehouse.name,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              sm: 12, // 1 column on mobile
                              md: 6, // 2 columns on tablet
                              lg: 4, // 3 columns on desktop
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Supplier:"),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Obx(() {
                                      return DropdownSearch<SupplierModel>(
                                        validator: (value) {
                                          if (controller
                                                      .selectedSupplier.value ==
                                                  null ||
                                              value == null) {
                                            return 'Supplier is required!';
                                          }
                                          return null;
                                        },
                                        popupProps: const PopupProps.menu(
                                          constraints:
                                              BoxConstraints(maxHeight: 200),
                                          searchDelay: Duration.zero,
                                        ),
                                        asyncItems: (String filter) =>
                                            controller.getAllSuppliers(),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "Choose Supplier",
                                            labelText: "Supplier",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        selectedItem:
                                            controller.selectedSupplier.value,
                                        onChanged: (value) {
                                          controller.selectedSupplier.value =
                                              value!;
                                        },
                                        itemAsString:
                                            (SupplierModel supplier) =>
                                                supplier.name,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
