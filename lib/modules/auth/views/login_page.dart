import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet or Desktop Layout
            return Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.indigo,
                    child: const Center(
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: LoginWidget(controller: controller),
                  ),
                ),
              ],
            );
          } else {
            // Mobile Layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LoginWidget(controller: controller),
            );
          }
        },
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    super.key,
    required this.controller,
  });

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        const Text(
          'Let\'s Sign You In',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Welcome Back.\nYou\'ve been missed!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: controller.loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: controller.emailController,
                validator: (value) => controller.validateEmail(value!),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Your Email',
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  validator: (value) =>
                      controller.validateEmpty(value!, "Password"),
                  obscureText: !controller.isLoginPasswordVisible.value,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        size: 18,
                        controller.isLoginPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.isLoginPasswordVisible.value =
                            !controller.isLoginPasswordVisible.value;
                      },
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.checkForm(controller.loginFormKey)) {
                    controller.loginWithEmail();
                  }
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Obx(
                  () => controller.isLoading.value == false
                      ? const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        )
                      : const SizedBox(
                          width: 18,
                          height: 18,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Center(
        //   child: TextButton(
        //     onPressed: () {
        //       Get.toNamed('/register');
        //     },
        //     child: const Text(
        //       'Don\'t have an account? Register',
        //       style: TextStyle(color: Color(0xFF835DF1)),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
