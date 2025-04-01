import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/payment_type/services/payment_type_services.dart';
import 'package:pharmacy_pos/modules/supplier/model/supplier_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:pharmacy_pos/modules/warehouse/services/warehouse_services.dart';

import '../../payment_type/model/payment_type_model.dart';
import '../../supplier/services/supplier_services.dart';
import '../model/purchase_details_model.dart';
import '../repository/purchase_repository.dart';

class PurchaseItemModel {
  int productId;
  String productName;
  int quantity;
  int stock;
  int productCost;
  String unit;
  int subTotal;
  PurchaseItemModel(
      {required this.productId,
      required this.productName,
      required this.quantity,
      required this.stock,
      required this.unit,
      required this.productCost,
      required this.subTotal});
}

class PurchaseController extends GetxController {
  final PurchaseRepository purchaseRepository;
  PurchaseController(this.purchaseRepository);

  Rx<WarehouseModel?> selectedWarehouse = Rx<WarehouseModel?>(null);
  RxString selectedStatus = "Received".obs;
  RxString selectedPaymentStatus = "Paid".obs;
  Rx<SupplierModel?> selectedSupplier = Rx<SupplierModel?>(null);
  //Rx<PaymentTypeModel?> selectedPaymentType = Rx<PaymentTypeModel?>(null);
  Rx<PaymentTypeModel?> selectedPaymentType = Rx<PaymentTypeModel?>(
      PaymentTypeModel(id: 1, name: "Cash", createdAt: 111, updatedAt: 222));
  Rx<PurchaseDetailsModel?> purchaseResponse = Rx<PurchaseDetailsModel?>(null);
  // Rx<StatusModel?> selectedStatus = Rx<StatusModel?>(null);

  RxInt shipping = 0.obs;
  RxInt grandTotal = 0.obs;

  RxList<PurchaseItemModel> purchaseItemList = <PurchaseItemModel>[].obs;

  double tableHeight = 50;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController refController = TextEditingController();

  late DateTime purchaseDate = DateTime.now();

  final GlobalKey<FormState> createPurchaseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> warehouseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updatePurchaseFormKey = GlobalKey<FormState>();

  var dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> getPurchaseDetails(int id) async {
    final response = await purchaseRepository.getPurchase(id: id);
    if (response != null && response.statusCode == 200) {
      //print(response.data);
      purchaseResponse.value = PurchaseDetailsModel.fromJson(response.data);
    }
  }

  Future<void> getPurchase(int id, bool isReturn) async {
    //print(id);
    final response = await purchaseRepository.getPurchase(id: id);
    if (response != null && response.statusCode == 200) {
      //print(response.data);
      purchaseResponse.value = PurchaseDetailsModel.fromJson(response.data);

      if (isReturn) {
        // DateTime date =
        //     DateTime.fromMillisecondsSinceEpoch(purchaseResponse.value!.date!);
        dateController.text = dateFormat.format(DateTime.now());
        purchaseDate = DateTime.now();
        selectedWarehouse.value = WarehouseModel(
            id: purchaseResponse.value?.warehouse?.id ?? 0,
            name: purchaseResponse.value?.warehouse?.name ?? "",
            phone: purchaseResponse.value!.warehouse!.phone,
            email: purchaseResponse.value!.warehouse!.email,
            address: purchaseResponse.value!.warehouse!.address,
            city: purchaseResponse.value!.warehouse!.city);
        selectedSupplier.value = SupplierModel(
            id: purchaseResponse.value?.supplier?.id ?? 0,
            name: purchaseResponse.value!.supplier?.name ?? "",
            phone: purchaseResponse.value!.supplier?.phone,
            email: purchaseResponse.value!.supplier?.email,
            address: purchaseResponse.value!.supplier?.address,
            city: purchaseResponse.value!.supplier?.city);
        List<PurchaseItemModel> myList = [];
        for (var val in purchaseResponse.value!.purchaseItems) {
          myList.add(PurchaseItemModel(
              productId: val.productId!,
              productName: val.productName!,
              quantity: 0,
              //profit: val.profit!,
              stock: val.quantity!,
              //productPrice: val.productPrice!,
              unit: val.unitName!,
              productCost: val.productCost!,
              subTotal: 0));
        }
        purchaseItemList.value = myList;

        //shipping.value = purchaseResponse.value!.shipping!;
        //shippingController.text = purchaseResponse.value!.shipping!.toString();
        //descriptionController.text = purchaseResponse.value!.note!;
        calculateGrandTotal();
      } else {
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(purchaseResponse.value!.date!);
        dateController.text = dateFormat.format(date);
        purchaseDate = date;
        selectedWarehouse.value = WarehouseModel(
            id: purchaseResponse.value?.warehouse?.id ?? 0,
            name: purchaseResponse.value?.warehouse?.name ?? "",
            phone: purchaseResponse.value!.warehouse!.phone,
            email: purchaseResponse.value!.warehouse!.email,
            address: purchaseResponse.value!.warehouse!.address,
            city: purchaseResponse.value!.warehouse!.city);
        selectedSupplier.value = SupplierModel(
            id: purchaseResponse.value?.supplier?.id ?? 0,
            name: purchaseResponse.value!.supplier?.name ?? "",
            phone: purchaseResponse.value!.supplier?.phone,
            email: purchaseResponse.value!.supplier?.email,
            address: purchaseResponse.value!.supplier?.address,
            city: purchaseResponse.value!.supplier?.city);
        List<PurchaseItemModel> myList = [];
        for (var val in purchaseResponse.value!.purchaseItems) {
          myList.add(PurchaseItemModel(
              productId: val.productId!,
              productName: val.productName!,
              quantity: val.quantity!,
              //profit: val.profit!,
              stock: val.quantity!,
              //productPrice: val.productPrice!,
              unit: val.unitName!,
              productCost: val.productCost!,
              subTotal: val.itemSubTotal!));
        }
        purchaseItemList.value = myList;

        refController.text = purchaseResponse.value?.refCode ?? "";
        shipping.value = purchaseResponse.value?.shipping ?? 0;
        shippingController.text = purchaseResponse.value!.shipping!.toString();
        descriptionController.text = purchaseResponse.value!.note!;
        selectedStatus.value =
            purchaseResponse.value!.status == 0 ? "Received" : "Pending";
        selectedPaymentStatus.value =
            purchaseResponse.value!.paymentStatus == 0 ? "Paid" : "Unpaid";
        if (purchaseResponse.value?.paymentType != null) {
          selectedPaymentType.value = PaymentTypeModel(
              id: purchaseResponse.value!.paymentType?.id,
              name: purchaseResponse.value!.paymentType?.name);
        }
        calculateGrandTotal();
      }
    }
  }

  void calculateGrandTotal() {
    if (shippingController.text.isEmpty) {
      grandTotal.value =
          purchaseItemList.fold(0, (sum, item) => sum + item.subTotal);
    } else {
      int val = purchaseItemList.fold(0, (sum, item) => sum + item.subTotal);
      grandTotal.value = (val + int.parse(shippingController.text));
    }
  }

  void createPurchaseWithItem() async {
    if (purchaseItemList.isEmpty) return;
    List<Map<String, dynamic>> itemList = [];
    for (var item in purchaseItemList) {
      itemList.add({
        "productId": item.productId,
        "quantity": item.quantity,
        "productCost": item.productCost,
        "subTotal": item.subTotal
      });
    }
    Map<String, dynamic> data = {
      "purchaseDate": purchaseDate.millisecondsSinceEpoch,
      "status": selectedStatus.value == "Received" ? 0 : 1,
      "amount": (grandTotal.value - shipping.value),
      "refCode": refController.text,
      "note": descriptionController.text,
      "shipping": shipping.value,
      "paymentTypeId": selectedPaymentType.value?.id,
      "paymentStatus": selectedPaymentStatus.value == "Paid" ? 0 : 1,
      "warehouseId": selectedWarehouse.value!.id,
      "supplierId": selectedSupplier.value!.id,
      "purchaseItems": itemList
    };
    final response = await purchaseRepository.createPurchaseWithItem(data);
    if (response != null && response.statusCode == 201) {
      dateController.clear();
      purchaseDate = DateTime.now();
      selectedWarehouse.value = null;
      selectedSupplier.value = null;
      searchController.clear();
      purchaseItemList.clear();
      refController.clear();
      selectedStatus.value = "Received";
      selectedPaymentStatus.value = "Unpaid";
      selectedPaymentType.value = null;
      shipping.value = 0;
      shippingController.clear();
      grandTotal.value = 0;
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(purchaseDate);
      dateController.text = date;
      Get.snackbar("Success", "New Purchase Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updatePurchaseWithItem(int purchaseId) async {
    if (purchaseItemList.isEmpty) return;
    List<Map<String, dynamic>> itemList = [];
    for (var item in purchaseItemList) {
      itemList.add({
        "productId": item.productId,
        "quantity": item.quantity,
        "productCost": item.productCost,
        "subTotal": item.subTotal
      });
    }
    Map<String, dynamic> data = {
      "purchaseId": purchaseId,
      "purchaseDate": purchaseDate.millisecondsSinceEpoch,
      "status": selectedStatus.value == "Received" ? 0 : 1,
      "amount": (grandTotal.value - shipping.value),
      "refCode": refController.text,
      "note": descriptionController.text,
      "shipping": shipping.value,
      "paymentTypeId": selectedPaymentType.value?.id,
      "paymentStatus": selectedPaymentStatus.value == "Paid" ? 0 : 1,
      "warehouseId": selectedWarehouse.value!.id,
      "supplierId": selectedSupplier.value!.id,
      "purchaseItems": itemList
    };
    final response = await purchaseRepository.updatePurchaseWithItem(data);
    if (response != null && response.statusCode == 200) {
      dateController.clear();
      purchaseDate = DateTime.now();
      selectedWarehouse.value = null;
      selectedSupplier.value = null;
      searchController.clear();
      purchaseItemList.clear();
      refController.clear();
      selectedStatus.value = "Received";
      selectedPaymentStatus.value = "Unpaid";
      selectedPaymentType.value = null;
      shipping.value = 0;
      shippingController.clear();
      grandTotal.value = 0;
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(purchaseDate);
      dateController.text = date;
      Get.snackbar("Success", "Purchase Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void createPurchaseReturnWithItems(int purchaseId) async {
    if (purchaseItemList.isEmpty) return;
    List<Map<String, dynamic>> itemList = [];
    for (var item in purchaseItemList) {
      itemList.add({
        "productId": item.productId,
        "quantity": item.quantity,
        "productCost": item.productCost,
        "subTotal": item.subTotal
      });
    }
    Map<String, dynamic> data = {
      "returnDate": purchaseDate.millisecondsSinceEpoch,
      "warehouseId": selectedWarehouse.value!.id,
      "status": 0,
      "totalAmount": (grandTotal.value - shipping.value),
      "note": descriptionController.text,
      "purchaseId": purchaseId,
      "returnItems": itemList
    };
    final response =
        await purchaseRepository.createPurchaseReturnWithItem(data);
    if (response != null && response.statusCode == 201) {
      dateController.clear();
      purchaseDate = DateTime.now();
      selectedWarehouse.value = null;
      selectedSupplier.value = null;
      searchController.clear();
      purchaseItemList.clear();
      shipping.value = 0;
      shippingController.clear();
      grandTotal.value = 0;
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(purchaseDate);
      dateController.text = date;
      Get.snackbar("Success", "New Sales Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  // void createPurchase() async {
  //   Map<String, dynamic> data = {
  //     "date": 0,
  //     "status": 0,
  //     "amount": 100,
  //     "refCode": "",
  //     "note": "",
  //     "shipping": 0,
  //     "warehouseId": 1,
  //     "supplierId": 1
  //   };
  //   final response = await purchaseRepository.createPurchase(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "Purchase Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void createPurchaseItem() async {
  //   Map<String, dynamic> data = {
  //     "quantity": 0,
  //     "subTotal": 0,
  //     "productCost": 100,
  //     "productId": 1,
  //     "purchaseId": 1
  //   };
  //   final response = await purchaseRepository.createPurchaseItem(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "Purchase Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void updatePurchase(int id) async {
  //   final response = await purchaseRepository.updatePurchase(
  //       id);
  //   if (response != null && response.statusCode == 200) {
  //     // nameController.clear();
  //     // descriptionController.clear();
  //     // Get.rootController.rootDelegate.canBack
  //     //     ? Get.back()
  //     //     : Get.offAllNamed('${Routes.app}${Routes.purchases}');
  //     // Get.snackbar("Success", "Purchase Updated.",
  //     //     snackPosition: SnackPosition.bottom);
  //   }
  // }

  Future<List<Map<String, dynamic>>> searchPurchaseProduct(
      String pattern) async {
    final response = await purchaseRepository.searchPurchaseProduct(params: {
      "searchTerm": pattern,
      "warehouseId": selectedWarehouse.value?.id
    });
    if (response != null && response.statusCode == 200) {
      final data = response.data as List<dynamic>;

      List<Map<String, dynamic>> res = [];
      for (var element in data) {
        res.add(element);
      }
      return res;
    } else {
      return [];
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null) {
      purchaseDate = picked;
      var date = DateFormat('dd/MM/yyyy').format(picked);
      dateController.text = date;
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

  Future<List<PaymentTypeModel>> getAllPaymentType() async {
    final PaymentTypeService paymentTypeService = PaymentTypeService();
    final response = await paymentTypeService.getAllPaymentTypes();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data as List<dynamic>;
      return data.map((v) => PaymentTypeModel.fromJson(v)).toList();
    } else {
      return [];
    }
  }
}
