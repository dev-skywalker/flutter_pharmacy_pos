import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/customer/model/customer_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:pharmacy_pos/modules/warehouse/services/warehouse_services.dart';

import '../../customer/services/customer_services.dart';
import '../../payment_type/model/payment_type_model.dart';
import '../../payment_type/services/payment_type_services.dart';
import '../model/sale_details_model.dart';
import '../repository/sales_repository.dart';

class SalesItemModel {
  int productId;
  String productName;
  int quantity;
  int oldQuantity;
  int profit;
  int stock;
  int productCost;
  int productPrice;
  String unit;
  int subTotal;
  SalesItemModel(
      {required this.productId,
      required this.productName,
      required this.quantity,
      required this.oldQuantity,
      required this.profit,
      required this.stock,
      required this.productPrice,
      required this.unit,
      required this.productCost,
      required this.subTotal});
}

class SalesController extends GetxController {
  final SalesRepository salesRepository;
  SalesController(this.salesRepository);

  RxString selectedStatus = "Received".obs;
  RxString selectedPaymentStatus = "Unpaid".obs;
  Rx<PaymentTypeModel?> selectedPaymentType = Rx<PaymentTypeModel?>(
      PaymentTypeModel(id: 1, name: "Cash", createdAt: 111, updatedAt: 222));

  Rx<WarehouseModel?> selectedWarehouse = Rx<WarehouseModel?>(null);
  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  Rx<SaleDetailsModel?> salesResponse = Rx<SaleDetailsModel?>(null);

  double tableHeight = 50;

  RxInt shipping = 0.obs;
  RxInt taxValue = 0.obs;
  RxInt discountValue = 0.obs;
  RxInt grandTotal = 0.obs;
  RxInt subTotal = 0.obs;

  RxList<SalesItemModel> salesItemList = <SalesItemModel>[].obs;
  static final List<SalesItemModel> salesReturnItemList = [];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  late DateTime salesDate = DateTime.now();

  final GlobalKey<FormState> createSalesFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> warehouseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateSalesFormKey = GlobalKey<FormState>();
  var dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> getSales(int id, bool isReturn) async {
    final response = await salesRepository.getSales(id: id);
    if (response != null && response.statusCode == 200) {
      salesResponse.value = SaleDetailsModel.fromJson(response.data);
      if (isReturn) {
        dateController.text = dateFormat.format(DateTime.now());
        salesDate = DateTime.now();
        selectedWarehouse.value = WarehouseModel(
            id: salesResponse.value?.warehouse?.id ?? 0,
            name: salesResponse.value?.warehouse?.name ?? "",
            phone: salesResponse.value!.warehouse!.phone,
            email: salesResponse.value!.warehouse!.email,
            address: salesResponse.value!.warehouse!.address,
            city: salesResponse.value!.warehouse!.city);
        selectedCustomer.value = CustomerModel(
            id: salesResponse.value?.customer?.id ?? 0,
            name: salesResponse.value?.customer?.name ?? "",
            phone: salesResponse.value!.customer!.phone,
            email: salesResponse.value!.customer!.email,
            address: salesResponse.value!.customer!.address,
            city: salesResponse.value!.customer!.city);
        //print(salesResponse.value!.saleItems.length);
        List<SalesItemModel> myList = [];
        for (var val in salesResponse.value!.saleItems) {
          myList.add(SalesItemModel(
              productId: val.productId!,
              productName: val.productName!,
              quantity: 0,
              profit: val.profit!,
              stock: val.quantity!,
              productPrice: val.productPrice!,
              unit: val.unitName!,
              productCost: val.productCost!,
              subTotal: 0,
              oldQuantity: val.quantity!));
        }
        salesItemList.value = myList;

        // shipping.value = salesResponse.value!.shipping!;
        // shippingController.text = salesResponse.value!.shipping!.toString();
        // descriptionController.text = salesResponse.value!.note!;
        calculateGrandTotal();
      }
    }
  }

  Future<void> getSaleWithStock(int id) async {
    final response = await salesRepository.getSalesWithStock(id: id);
    if (response != null && response.statusCode == 200) {
      final sales = SaleDetailsModel.fromJson(response.data);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(sales.date!);
      dateController.text = dateFormat.format(date);
      salesDate = date;
      selectedWarehouse.value = WarehouseModel(
          id: sales.warehouse?.id ?? 0,
          name: sales.warehouse?.name ?? "",
          phone: sales.warehouse!.phone,
          email: sales.warehouse!.email,
          address: sales.warehouse!.address,
          city: sales.warehouse!.city);
      selectedCustomer.value = CustomerModel(
          id: sales.customer?.id ?? 0,
          name: sales.customer?.name ?? "",
          phone: sales.customer!.phone,
          email: sales.customer!.email,
          address: sales.customer!.address,
          city: sales.customer!.city);
      List<SalesItemModel> myList = [];
      for (var val in sales.saleItems) {
        myList.add(SalesItemModel(
            productId: val.productId!,
            productName: val.productName!,
            quantity: val.quantity!,
            profit: val.profit!,
            stock: val.stock!,
            oldQuantity: val.quantity!,
            productPrice: val.productPrice!,
            unit: val.unitName!,
            productCost: val.productCost!,
            subTotal: val.subTotal!));
      }
      salesItemList.value = myList;

      shipping.value = sales.shipping!;
      shippingController.text = sales.shipping!.toString();
      //taxValue.value = sales.taxPercent!;
      // double taxPercent =
      //     (sales.taxPercent! / (sales.amount! - sales.discount!)) * 100;
      taxController.text = sales.taxPercent.toString();
      discountValue.value = sales.discount!;
      discountController.text = sales.discount!.toString();
      descriptionController.text = sales.note!;
      selectedStatus.value = sales.status == 0 ? "Received" : "Pending";
      selectedPaymentStatus.value =
          sales.paymentStatus == 0 ? "Paid" : "Unpaid";
      if (sales.paymentType != null) {
        selectedPaymentType.value = PaymentTypeModel(
            id: sales.paymentType?.id, name: sales.paymentType?.name);
      }
      calculateGrandTotal();
    }
  }

  void calculateGrandTotal() {
    int val = salesItemList.fold(0, (sum, item) => sum + item.subTotal);
    subTotal.value = val;

    // Calculate shipping
    int shipping = shippingController.text.isEmpty
        ? 0
        : int.parse(shippingController.text);

    // Calculate discount
    int discount = discountController.text.isEmpty
        ? 0
        : int.parse(discountController.text);

    // Calculate tax
    double taxPercentage =
        taxController.text.isEmpty ? 0.0 : double.parse(taxController.text);
    double taxAmount = (val - discount) * (taxPercentage / 100);
    taxValue.value = taxAmount.round();

    // Calculate grand total
    grandTotal.value = val + shipping - discount + taxAmount.round();
  }

  void createSalesWithItem() async {
    if (salesItemList.isEmpty) return;
    final box = GetStorage();
    final user = box.read("user");
    print(user['userId']);
    List<Map<String, dynamic>> itemList = [];

    for (var item in salesItemList) {
      itemList.add({
        "productId": item.productId,
        "quantity": item.quantity,
        "profit": item.profit,
        "productCost": item.productCost,
        "productPrice": item.productPrice,
        "subTotal": item.subTotal
      });
    }
    Map<String, dynamic> data = {
      "saleDate": salesDate.millisecondsSinceEpoch,
      "status": selectedStatus.value == "Received" ? 0 : 1,
      "amount": subTotal.value,
      "totalAmount": grandTotal.value,
      "note": descriptionController.text,
      "shipping": shipping.value,
      "warehouseId": selectedWarehouse.value!.id,
      "customerId": selectedCustomer.value!.id,
      "paymentTypeId": selectedPaymentType.value?.id ?? 1, //
      "paymentStatus": selectedPaymentStatus.value == "Paid" ? 0 : 1,
      "discount": discountValue.value, //
      "taxPercent":
          taxController.text.isNotEmpty ? int.parse(taxController.text) : 0, //
      "taxAmount": taxValue.value,
      "userId": user["userId"],
      "saleItems": itemList
    };
    final response = await salesRepository.createSalesWithItem(data);
    if (response != null && response.statusCode == 201) {
      dateController.clear();
      salesDate = DateTime.now();
      selectedWarehouse.value = null;
      selectedCustomer.value = null;
      searchController.clear();
      salesItemList.clear();
      taxValue.value = 0;
      taxController.clear();
      discountValue.value = 0;
      discountController.clear();
      subTotal.value = 0;
      shipping.value = 0;
      shippingController.clear();
      grandTotal.value = 0;
      selectedStatus.value = "Received";
      selectedPaymentStatus.value = "Unpaid";
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(salesDate);
      dateController.text = date;
      Get.snackbar("Success", "New Sales Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateSalesWithItem(int saleId) async {
    if (salesItemList.isEmpty) return;
    List<Map<String, dynamic>> itemList = [];

    for (var item in salesItemList) {
      itemList.add({
        "productId": item.productId,
        "quantity": item.quantity,
        "profit": item.profit,
        "productCost": item.productCost,
        "productPrice": item.productPrice,
        "subTotal": item.subTotal
      });
    }
    Map<String, dynamic> data = {
      "saleId": saleId,
      "saleDate": salesDate.millisecondsSinceEpoch,
      "status": selectedStatus.value == "Received" ? 0 : 1,
      "amount": subTotal.value,
      "totalAmount": grandTotal.value,
      "note": descriptionController.text,
      "shipping": shipping.value,
      "warehouseId": selectedWarehouse.value!.id,
      "customerId": selectedCustomer.value!.id,
      "paymentTypeId": selectedPaymentType.value?.id ?? 1, //
      "paymentStatus": selectedPaymentStatus.value == "Paid" ? 0 : 1,
      "discount": discountValue.value, //
      "taxPercent":
          taxController.text.isNotEmpty ? int.parse(taxController.text) : 0, //
      "taxAmount": taxValue.value,
      "userId": 3,
      "saleItems": itemList
    };
    final response = await salesRepository.updateSalesWithItem(data);
    if (response != null && response.statusCode == 200) {
      dateController.clear();
      salesDate = DateTime.now();
      selectedWarehouse.value = null;
      selectedCustomer.value = null;
      searchController.clear();
      salesItemList.clear();
      taxValue.value = 0;
      taxController.clear();
      discountValue.value = 0;
      discountController.clear();
      subTotal.value = 0;
      shipping.value = 0;
      shippingController.clear();
      grandTotal.value = 0;
      selectedStatus.value = "Received";
      selectedPaymentStatus.value = "Unpaid";
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(salesDate);
      dateController.text = date;
      Get.snackbar("Success", "New Sales Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void createSalesReturnWithItem(int saleId) async {
    if (salesItemList.isEmpty) return;
    List<Map<String, dynamic>> itemList = [];

    for (var item in salesItemList) {
      itemList.add({
        "productId": item.productId,
        "quantity": item.quantity,
        "productCost": item.productCost,
        "productPrice": item.productPrice,
        "subTotal": item.subTotal
      });
    }
    Map<String, dynamic> data = {
      "returnDate": salesDate.millisecondsSinceEpoch,
      "warehouseId": selectedWarehouse.value!.id,
      "status": 0,
      "totalAmount": (grandTotal.value - shipping.value),
      "note": descriptionController.text,
      "saleId": saleId,
      "returnItems": itemList
    };
    final response = await salesRepository.createSalesReturnWithItem(data);
    if (response != null && response.statusCode == 201) {
      dateController.clear();
      salesDate = DateTime.now();
      selectedWarehouse.value = null;
      selectedCustomer.value = null;
      searchController.clear();
      salesItemList.clear();
      grandTotal.value = 0;
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(salesDate);
      dateController.text = date;
      Get.snackbar("Success", "New Sales Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  // void createSales() async {
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
  //   final response = await salesRepository.createSales(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "Sales Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void createSalesItem() async {
  //   Map<String, dynamic> data = {
  //     "quantity": 0,
  //     "subTotal": 0,
  //     "productCost": 100,
  //     "productId": 1,
  //     "salesId": 1
  //   };
  //   final response = await salesRepository.createSalesItem(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "Sales Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void updateSales(int id) async {
  //   final response = await salesRepository.updateSales(
  //       id);
  //   if (response != null && response.statusCode == 200) {
  //     // nameController.clear();
  //     // descriptionController.clear();
  //     // Get.rootController.rootDelegate.canBack
  //     //     ? Get.back()
  //     //     : Get.offAllNamed('${Routes.app}${Routes.saless}');
  //     // Get.snackbar("Success", "Sales Updated.",
  //     //     snackPosition: SnackPosition.bottom);
  //   }
  // }

  Future<List<Map<String, dynamic>>> searchSalesProduct(String pattern) async {
    final response = await salesRepository.searchSalesProduct(params: {
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
      salesDate = picked;
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

  Future<List<CustomerModel>> getAllCustomers() async {
    final CustomerService customerService = CustomerService();
    final response = await customerService.getAllCustomers();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => CustomerModel.fromJson(v)).toList();
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
