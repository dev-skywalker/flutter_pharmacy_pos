import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:pharmacy_pos/modules/units/services/unit_services.dart';

import '../../units/model/unit_model.dart';
import '../repository/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository productRepository;
  ProductController(this.productRepository);
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController chemicalNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tabletOnCardController = TextEditingController();
  final TextEditingController cardOnBoxController = TextEditingController();

  RxList<String> chemicalNameList = <String>[].obs;
  Rx<Units?> selectedUnit = Rx<Units?>(null);
  RxBool hasImage = false.obs;
  RxBool isLocalProduct = false.obs;

  Uint8List? imageData;

  final GlobalKey<FormState> createProductFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateProductFormKey = GlobalKey<FormState>();

  RxString updateImageUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<Units>> getAllUnits() async {
    final UnitService unitService = UnitService();
    final response = await unitService.getAllUnits();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((v) => Units(
              id: v['id'],
              name: v['name'],
              createdAt: v['createdAt'],
              updatedAt: v['updatedAt']))
          .toList();
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

  void createProduct() async {
    List<String> nameList = [brandNameController.text, ...chemicalNameList];
    String name = nameList.join(",");
    //final brandName =

    final fileName =
        "${brandNameController.text.replaceAll(" ", "-")}-${DateTime.now().millisecondsSinceEpoch}";
    final FormData formData = FormData.fromMap({
      "name": name,
      "description": descriptionController.text,
      "unitId": selectedUnit.value!.id,
      "isLocalProduct": isLocalProduct.value
    });
    if (selectedUnit.value!.name == "card") {
      formData.fields
          .add(MapEntry("tabletOnCard", tabletOnCardController.text));
      formData.fields.add(MapEntry("cardOnBox", cardOnBoxController.text));
    }
    if (imageData != null) {
      formData.files.add(MapEntry(
          "file", MultipartFile.fromBytes(imageData!, filename: fileName)));
    }
    final response = await productRepository.createProduct(formdata: formData);
    if (response != null && response.statusCode == 201) {
      clearAddProduct();
      Get.snackbar("Success", "Product Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateProduct({required int id, String? url}) async {
    List<String> nameList = [brandNameController.text, ...chemicalNameList];
    String name = nameList.join(",");
    //final brandName =

    final fileName =
        "${brandNameController.text.replaceAll(" ", "-")}-${DateTime.now().millisecondsSinceEpoch}";
    final FormData formData = FormData.fromMap({
      "id": id,
      "name": name,
      "description": descriptionController.text,
      "unitId": selectedUnit.value!.id,
      "isLocalProduct": isLocalProduct.value
    });
    if (selectedUnit.value!.name == "card") {
      formData.fields
          .add(MapEntry("tabletOnCard", tabletOnCardController.text));
      formData.fields.add(MapEntry("cardOnBox", cardOnBoxController.text));
    }

    if (imageData != null) {
      formData.files.add(MapEntry(
          "file", MultipartFile.fromBytes(imageData!, filename: fileName)));
    } else {
      // if (updateImageUrl.value != "") {
      formData.fields.add(MapEntry("imageUrl", updateImageUrl.value));
      //}
    }
    final response = await productRepository.updateProduct(formdata: formData);
    if (response != null && response.statusCode == 201) {
      clearAddProduct();
      Get.snackbar("Success", "Product Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void clearAddProduct() {
    brandNameController.clear();
    chemicalNameController.clear();
    chemicalNameList.clear();
    descriptionController.clear();
    selectedUnit.value = null;
    tabletOnCardController.clear();
    cardOnBoxController.clear();
    imageData = null;
    updateImageUrl.value = "";
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
