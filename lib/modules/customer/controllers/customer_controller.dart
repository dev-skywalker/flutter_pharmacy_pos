import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/customer/model/customer_model.dart';
import '../../../routes/routes.dart';
import '../repository/customer_repository.dart';

class CustomerController extends GetxController {
  final CustomerRepository customerRepository;
  CustomerController(this.customerRepository);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> createCustomerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateCustomerFormKey = GlobalKey<FormState>();

  Future<void> getCustomer(int id) async {
    final response = await customerRepository.getCustomer(id: id);
    final customerModel = CustomerModel.fromJson(response?.data);
    nameController.text = customerModel.name;
    phoneController.text = customerModel.phone ?? "";
    emailController.text = customerModel.email ?? "";
    cityController.text = customerModel.city ?? "";
    addressController.text = customerModel.address ?? "";
  }

  void createCustomer() async {
    final response = await customerRepository.createCustomer({
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "city": cityController.text,
      "address": addressController.text
    });
    if (response != null && response.statusCode == 201) {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      cityController.clear();
      addressController.clear();
      Get.snackbar("Success", "Customer Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateCustomer(int id) async {
    final response = await customerRepository.updateCustomer({
      "id": id,
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "city": cityController.text,
      "address": addressController.text,
      "createdAt": DateTime.now().millisecondsSinceEpoch
    });
    if (response != null && response.statusCode == 200) {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      cityController.clear();
      addressController.clear();
      Get.rootController.rootDelegate.canBack
          ? Get.back()
          : Get.offAllNamed('${Routes.app}${Routes.customers}');
      Get.snackbar("Success", "Customer Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }
}
