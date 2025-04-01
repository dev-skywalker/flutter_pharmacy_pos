import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/brands/model/brand_model.dart';
import 'package:pharmacy_pos/modules/category/model/category_model.dart';
import 'package:pharmacy_pos/modules/category/services/category_services.dart';
import 'package:pharmacy_pos/modules/manage_stock/repository/manage_stock_repository.dart';
import 'package:pharmacy_pos/modules/supplier/model/supplier_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:pharmacy_pos/modules/warehouse/services/warehouse_services.dart';

import '../../brands/services/brand_services.dart';
import '../../purchase/repository/purchase_repository.dart';
import '../../supplier/services/supplier_services.dart';
import '../../units/model/unit_model.dart';
import '../../units/services/unit_services.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository productRepository;
  final PurchaseRepository purchaseRepository;
  final ManageStockRepository manageStockRepository;
  ProductController(this.productRepository, this.purchaseRepository,
      this.manageStockRepository);
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController chemicalNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tabletOnCardController = TextEditingController();
  final TextEditingController cardOnBoxController = TextEditingController();
  final TextEditingController productCostController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController stockAlertController = TextEditingController();
  final TextEditingController quantityLimitController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expireDateController = TextEditingController();

  final TextEditingController updateCostController = TextEditingController();
  final TextEditingController updatePriceController = TextEditingController();

  RxList<String> chemicalNameList = <String>[].obs;
  ExpansionTileController expansionTileController = ExpansionTileController();
  Rx<Units?> selectedUnit = Rx<Units?>(null);
  Rx<Brands?> selectedBrand = Rx<Brands?>(null);
  Rx<WarehouseModel?> selectedWarehouse = Rx<WarehouseModel?>(null);
  Rx<SupplierModel?> selectedSupplier = Rx<SupplierModel?>(null);
  Rx<ProductModel?> productDetails = Rx<ProductModel?>(null);

  RxBool hasImage = false.obs;
  RxBool isProductUpdate = false.obs;
  RxBool isLocalProduct = false.obs;
  RxBool isUpdateCost = false.obs;
  RxBool isUpdatePrice = false.obs;
  RxList<Category> selectedCatLists = <Category>[].obs;
  DateTime? expireDate;

  Uint8List? imageData;

  final GlobalKey<FormState> createProductFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> createStockProductFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateProductFormKey = GlobalKey<FormState>();

  RxString updateImageUrl = "".obs;
  String oldImage = "";

  Future<void> getProduct(int id, bool isUpdate) async {
    final response = await productRepository.getProduct(id: id);
    final productModel = ProductModel.fromJson(response?.data);
    productDetails(productModel);
    if (isUpdate) {
      List<String> nameList = productModel.name.split(',');
      String firstItem = nameList.removeAt(0);
      brandNameController.text = firstItem;
      chemicalNameList.value = nameList;
      descriptionController.text = productModel.description ?? "";
      tabletOnCardController.text = productModel.tabletOnCard.toString();
      cardOnBoxController.text = productModel.cardOnBox.toString();
      selectedUnit.value = productModel.unit;
      isLocalProduct.value = productModel.isLocalProduct ?? false;
      updateImageUrl.value = productModel.imageUrl ?? "";
      print(productModel.productCategories);
      List<Category> selectedCat = [];
      for (var val in productModel.productCategories) {
        print("Hello");
        selectedCat.add(val.category!);
        print(selectedCatLists.value.length);
      }
      selectedCatLists.value = selectedCat;
      selectedBrand.value = productModel.brand;
      quantityLimitController.text = productModel.quantityLimit.toString();
      DateTime? dt =
          DateTime.fromMillisecondsSinceEpoch(productModel.expireDate!);
      var date = DateFormat('dd/MM/yyyy').format(dt);
      expireDateController.text = date;
      expireDate = dt;
      productCostController.text = productModel.productCost.toString();
      productPriceController.text = productModel.productPrice.toString();
      stockAlertController.text = productModel.stockAlert.toString();
    }
  }

  Future<List<WarehouseModel>> getAllWarehouses() async {
    final WarehouseService warehouseService = WarehouseService();
    final response = await warehouseService.getAllWarehouses();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => WarehouseModel.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  Future<List<SupplierModel>> getAllSuppliers() async {
    final SupplierService supplierService = SupplierService();
    final response = await supplierService.getAllSuppliers();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => SupplierModel.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  Future<List<Units>> getAllUnits() async {
    final UnitService unitService = UnitService();
    final response = await unitService.getAllUnits();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => Units.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  Future<List<Brands>> getAllBrands() async {
    final BrandService brandService = BrandService();
    final response = await brandService.getAllBrands();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => Brands.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  Future<List<Category>> getAllCategory() async {
    final CategoryService categoryService = CategoryService();
    final response = await categoryService.getAllCategorys();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => Category.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  void pickProductImage() async {
    if (kIsWeb) {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      if (bytesFromPicker != null) {
        imageData = bytesFromPicker;
        hasImage(true);
      }
    } else {
      final image = await pickImage("gallery");
      imageData = image;
      hasImage(true);
    }
  }

  Future<String> uploadImage(String fileName, List<int> file) async {
    var formData = FormData.fromMap({
      "key": fileName,
      "file": MultipartFile.fromBytes(file,
          filename: fileName, contentType: DioMediaType("image", "jpeg"))
    });
    final response =
        await productRepository.createProductImage(formdata: formData);
    if (response != null && response.statusCode == 201) {
      return response.data['imageUrl'];
    }
    return "";
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      expireDate = picked;
      var date = DateFormat('dd/MM/yyyy').format(picked);
      expireDateController.text = date;
    }
  }

  void createProduct() async {
    List<String> nameList = [brandNameController.text, ...chemicalNameList];
    String name = nameList.join(",");

    final catId = [];
    for (var cat in selectedCatLists) {
      catId.add(cat.id);
    }

    final fileName =
        "${brandNameController.text.replaceAll(" ", "-")}-${DateTime.now().millisecondsSinceEpoch}";

    String imageUrl = "";
    if (imageData != null) {
      imageUrl = await uploadImage(fileName, imageData!);
    }

    final Map<String, dynamic> data = {
      "name": name,
      "description": descriptionController.text,
      "unitId": selectedUnit.value!.id,
      "brandId": selectedBrand.value!.id,
      "barcode": "",
      "productCost": int.parse(productCostController.text),
      "productPrice": int.parse(productPriceController.text),
      "stockAlert": stockAlertController.text.isNotEmpty
          ? int.parse(stockAlertController.text)
          : 0,
      "quantityLimit": quantityLimitController.text.isNotEmpty
          ? int.parse(quantityLimitController.text)
          : 0,
      "expireDate": expireDate!.millisecondsSinceEpoch,
      "tabletOnCard": tabletOnCardController.text.isNotEmpty
          ? int.parse(tabletOnCardController.text)
          : 0,
      "cardOnBox": cardOnBoxController.text.isNotEmpty
          ? int.parse(cardOnBoxController.text)
          : 0,
      "isLocalProduct": isLocalProduct.value,
      "catId": catId,
      "imageUrl": imageUrl
    };
    final response = await productRepository.createProduct(data: data);
    //print(response);
    if (response != null && response.statusCode == 201) {
      final productId = response.data['id'];

      if (expansionTileController.isExpanded &&
          quantityController.text.isNotEmpty) {
        final purchaseId = await createPurchase();
        await createPurchaseItem(productId: productId, purchaseId: purchaseId);

        final newStock = await createManageStock(
            productId: productId, warehouseId: selectedWarehouse.value!.id);
        if (newStock == 1) {
          clearAddProduct();
          //print(response.data);
          Get.snackbar("Success", "Create Product With Stock.",
              snackPosition: SnackPosition.bottom);
        }
      } else {
        clearAddProduct();
        Get.snackbar("Success", response.data.toString(),
            snackPosition: SnackPosition.bottom);
      }
    }
  }

  Future<int> createManageStock(
      {required int productId, required int warehouseId}) async {
    Map<String, dynamic> data = {
      "quantity": int.parse(quantityController.text),
      "alert": stockAlertController.text.isNotEmpty
          ? int.parse(stockAlertController.text)
          : 0,
      "productId": productId,
      "warehouseId": warehouseId
    };
    final response = await manageStockRepository.createManageStock(data);
    if (response != null && response.statusCode == 201) {
      //nameController.clear();
      // descriptionController.clear();
      // Get.snackbar("Success", "Purchase Created.",
      //     snackPosition: SnackPosition.bottom);
      return 1;
    }
    return 0;
  }

  Future<int> createPurchase() async {
    int amount = int.parse(productCostController.text) *
        int.parse(quantityController.text);
    Map<String, dynamic> data = {
      "date": DateTime.now().millisecondsSinceEpoch,
      "status": 0,
      "amount": amount,
      "refCode": "initial",
      "note": "",
      "shipping": 0,
      "paymentTypeId": 1,
      "paymentStatus": 0,
      "warehouseId": selectedWarehouse.value!.id,
      "supplierId": selectedSupplier.value!.id
    };
    final response = await purchaseRepository.createPurchase(data);
    if (response != null && response.statusCode == 201) {
      //nameController.clear();
      // descriptionController.clear();
      // Get.snackbar("Success", "Purchase Created.",
      //     snackPosition: SnackPosition.bottom);
      return response.data['id'];
    }
    return 0;
  }

  Future<int> createPurchaseItem(
      {required int productId, required int purchaseId}) async {
    int amount = int.parse(productCostController.text) *
        int.parse(quantityController.text);
    Map<String, dynamic> data = {
      "quantity": int.parse(quantityController.text),
      "subTotal": amount,
      "productCost": int.parse(productCostController.text),
      "productId": productId,
      "purchaseId": purchaseId
    };
    final response = await purchaseRepository.createPurchaseItem(data);
    if (response != null && response.statusCode == 201) {
      //nameController.clear();
      // descriptionController.clear();
      // Get.snackbar("Success", "Purchase Created.",
      //     snackPosition: SnackPosition.bottom);
      return response.data['id'];
    }
    return 0;
  }

  void updateProductCost(int id) async {
    Map<String, dynamic> data = {
      "id": id,
      "productCost": int.parse(updateCostController.text)
    };
    final response = await productRepository.updateProduct(data: data);
    if (response != null && response.statusCode == 200) {
      productDetails.value!.productCost = int.parse(updateCostController.text);
      isUpdateCost.value = false;
      updateCostController.clear();
    }
  }

  void updateProductPrice(int id) async {
    Map<String, dynamic> data = {
      "id": id,
      "productPrice": int.parse(updatePriceController.text)
    };
    final response = await productRepository.updateProduct(data: data);
    if (response != null && response.statusCode == 200) {
      productDetails.value!.productPrice =
          int.parse(updatePriceController.text);
      isUpdatePrice.value = false;
      updatePriceController.clear();
    }
  }

  void updateProduct({required int id}) async {
    List<String> nameList = [brandNameController.text, ...chemicalNameList];
    String name = nameList.join(",");

    final catId = [];
    for (var cat in selectedCatLists) {
      catId.add(cat.id);
    }

    final fileName =
        "${brandNameController.text.replaceAll(" ", "-")}-${DateTime.now().millisecondsSinceEpoch}";

    String imageUrl = "";

    if (imageData != null) {
      // If there's new image data, delete the old image if needed and upload the new one
      if (oldImage.isNotEmpty && updateImageUrl.value.isEmpty) {
        await _deleteOldImage(oldImage);
      }
      imageUrl = await uploadImage(fileName, imageData!);
    } else {
      // If no new image data, handle the old image or keep the updateImageUrl
      if (oldImage.isNotEmpty && updateImageUrl.value.isEmpty) {
        await _deleteOldImage(oldImage);
        imageUrl = "";
      } else {
        imageUrl = updateImageUrl.value;
      }
    }

    final Map<String, dynamic> data = {
      "id": id,
      "name": name,
      "description": descriptionController.text,
      "unitId": selectedUnit.value!.id,
      "brandId": selectedBrand.value!.id,
      "barcode": "",
      "productCost": int.parse(productCostController.text),
      "productPrice": int.parse(productPriceController.text),
      "stockAlert": stockAlertController.text.isNotEmpty
          ? int.parse(stockAlertController.text)
          : 0,
      "quantityLimit": quantityLimitController.text.isNotEmpty
          ? int.parse(quantityLimitController.text)
          : 0,
      "expireDate": expireDate!.millisecondsSinceEpoch,
      "tabletOnCard": tabletOnCardController.text.isNotEmpty
          ? int.parse(tabletOnCardController.text)
          : 0,
      "cardOnBox": cardOnBoxController.text.isNotEmpty
          ? int.parse(cardOnBoxController.text)
          : 0,
      "isLocalProduct": isLocalProduct.value,
      "catId": catId,
      "imageUrl": imageUrl
    };
    final response = await productRepository.updateProduct(data: data);
    if (response != null && response.statusCode == 200) {
      clearAddProduct();
      Get.back();
      Get.snackbar("Success", "Product Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }

  Future<void> _deleteOldImage(String oldImage) async {
    print("Delete Image");
    var id = oldImage.split("/").last;
    print(id);
    var res = await productRepository.deleteProductImage(id: id);
    print(res?.data);
  }

  void clearAddProduct() {
    brandNameController.clear();
    chemicalNameController.clear();
    chemicalNameList.clear();
    descriptionController.clear();
    selectedUnit.value = null;
    selectedBrand.value = null;
    selectedCatLists.value = [];
    tabletOnCardController.clear();
    cardOnBoxController.clear();
    productCostController.clear();
    productPriceController.clear();
    stockAlertController.clear();
    quantityLimitController.clear();
    expireDateController.clear();
    quantityController.clear();
    selectedWarehouse.value = null;
    selectedSupplier.value = null;
    expireDate = null;
    imageData = null;
    updateImageUrl.value = "";
    oldImage = "";
    isLocalProduct.value = false;
    hasImage.value = false;
  }

  static Future<Uint8List> pickImage(String type) async {
    try {
      var photo = await ImagePicker().pickImage(
        source: type == "camera" ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
      );

      File imageFile = File(photo!.path);
      Uint8List imageRaw = await imageFile.readAsBytes();
      return imageRaw;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void dispose() {
    brandNameController.dispose();
    chemicalNameController.dispose();
    descriptionController.dispose();
    tabletOnCardController.dispose();
    cardOnBoxController.dispose();
    super.dispose();
  }
}
