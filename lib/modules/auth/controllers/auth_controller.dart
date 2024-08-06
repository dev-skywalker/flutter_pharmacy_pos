// auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/routes/routes.dart';
import 'package:pharmacy_pos/services/storage_services.dart';
import '../repository/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  AuthController(this.authRepository);

  RxBool isLoginPage = true.obs;
  RxBool loggedIn = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isLoginPasswordVisible = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  final StorageService box = StorageService();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Validation logic
  String? validateEmpty(String value, String name) {
    if (value.isEmpty) {
      return '$name is required';
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Confirm Password is required';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Method to check if the form is valid
  bool checkForm(GlobalKey<FormState> fKey) {
    final isValid = fKey.currentState?.validate();
    if (isValid != null && isValid) {
      // Perform any action on form submission
      //Get.snackbar('Success', 'Form is valid');
      return true;
    } else {
      //Get.snackbar('Error', 'Form is not valid');
      return false;
    }
  }

  void cleanController() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isLoading(false);
  }

  void loginWithEmail() async {
    isLoading(true);
    final response = await authRepository.login(
        email: emailController.text, password: passwordController.text);
    if (response != null && response.statusCode == 200) {
      isLoading(false);
      final token = response.data['token'].toString();
      box.save(key: 'token', data: token);
      cleanController();
      Get.offAllNamed(Routes.app);
      Get.snackbar(
          "Success", "Code - ${response.statusCode}, ${response.statusMessage}",
          snackPosition: SnackPosition.bottom);
    } else {
      isLoading(false);
      Get.snackbar("Something Wrong!",
          "Code - ${response?.statusCode}, ${response?.statusMessage}",
          snackPosition: SnackPosition.bottom);
    }
  }

  void registerWithEmail() async {
    isLoading(true);
    final response = await authRepository.register(
        email: emailController.text,
        password: passwordController.text,
        role: "user",
        isActive: false);
    if (response != null && response.statusCode == 201) {
      isLoading(false);

      cleanController();
      //Get.offAllNamed('/');
      Get.snackbar(
          "Success", "Code - ${response.statusCode}, ${response.statusMessage}",
          snackPosition: SnackPosition.bottom);
    } else {
      isLoading(false);
      Get.snackbar("Something Wrong!",
          "Code - ${response?.statusCode}, ${response?.statusMessage}",
          snackPosition: SnackPosition.bottom);
    }
  }

  void logout() {
    //isLoggedIn.value = false;
  }
}
