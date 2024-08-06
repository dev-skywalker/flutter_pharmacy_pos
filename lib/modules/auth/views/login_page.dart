import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  final bool register;
  const LoginPage(this.register, {super.key});

  @override
  Widget build(BuildContext context) {
    if (register) {
      controller.isLoginPage(false);
    } else {
      controller.isLoginPage(true);
    }
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        child: Obx(() {
          if (controller.isLoginPage.value) {
            return LoginWidget(controller: controller, context: context);
          } else {
            return RegisterWidget(controller: controller, context: context);
          }
        }),
      ),
    );
  }
}

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({
    super.key,
    required this.controller,
    required this.context,
  });

  final AuthController controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(
        //   height: 14,
        // ),
        // FadeInDown(
        //   delay: const Duration(milliseconds: 900),
        //   duration: const Duration(milliseconds: 1000),
        //   child: IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: const Icon(
        //         Icons.arrow_back_ios,
        //       )),
        // ),
        const SizedBox(
          height: 70,
        ),
        FadeInDown(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 900),
          child: const Text(
            'Let\'s Sign Up',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FadeInDown(
          delay: const Duration(milliseconds: 700),
          duration: const Duration(milliseconds: 800),
          child: const Text(
            'Welcome ...',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Form(
          key: controller.registerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FadeInDown(
              //   delay: const Duration(milliseconds: 700),
              //   duration: const Duration(milliseconds: 800),
              //   child: const Text(
              //     'Name',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 4,
              // ),
              // FadeInDown(
              //   delay: const Duration(milliseconds: 600),
              //   duration: const Duration(milliseconds: 700),
              //   child: TextFormField(
              //     controller: controller.fullNameController,
              //     validator: (value) =>
              //         controller.validateEmpty(value!, "Name"),
              //     style: const TextStyle(fontWeight: FontWeight.w500),
              //     decoration: const InputDecoration(
              //         border: OutlineInputBorder(), hintText: 'Your Full Name'),
              //   ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 800),
                child: const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 700),
                child: TextFormField(
                  controller: controller.emailController,
                  validator: (value) => controller.validateEmail(value!),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Your Email'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 500),
                child: Obx(() => TextFormField(
                      controller: controller.passwordController,
                      validator: (value) =>
                          controller.validateEmpty(value!, "Password"),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              size: 18,
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.isPasswordVisible.value =
                                  !controller.isPasswordVisible.value;
                            },
                          ),
                          border: const OutlineInputBorder(),
                          hintText: 'Password'),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 500),
                child: Obx(() => TextFormField(
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      controller: controller.confirmPasswordController,
                      validator: (value) =>
                          controller.validateConfirmPassword(value!),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              size: 18,
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.isConfirmPasswordVisible.value =
                                  !controller.isConfirmPasswordVisible.value;
                            },
                          ),
                          border: const OutlineInputBorder(),
                          hintText: 'Password Confirmation'),
                    )),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 700),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    bool isValidate =
                        controller.checkForm(controller.registerFormKey);
                    if (isValidate) {
                      controller.registerWithEmail();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      //elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      backgroundColor: const Color(0xFF835DF1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    duration: const Duration(milliseconds: 800),
                    child: Obx(() => controller.isLoading.value == false
                        ? const Text('Register',
                            style: TextStyle(color: Colors.white))
                        : const SizedBox(
                            width: 18,
                            height: 18,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          )),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // FadeInUp(
        //   delay: const Duration(milliseconds: 600),
        //   duration: const Duration(milliseconds: 700),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       // Container(
        //       //   width: 40,
        //       //   height: 40,
        //       //   decoration: const BoxDecoration(
        //       //       shape: BoxShape.circle,
        //       //       image: DecorationImage(
        //       //           image: AssetImage('assets/images/facebook.png'))),
        //       // ),
        //       // const SizedBox(
        //       //   width: 20,
        //       // ),
        //       // Container(
        //       //   width: 40,
        //       //   height: 40,
        //       //   decoration: const BoxDecoration(
        //       //       shape: BoxShape.circle,
        //       //       image: DecorationImage(
        //       //           image: AssetImage('assets/images/google.png'))),
        //       // ),
        //       // const SizedBox(
        //       //   width: 20,
        //       // ),
        //       // Container(
        //       //   width: 40,
        //       //   height: 40,
        //       //   decoration: const BoxDecoration(
        //       //       shape: BoxShape.circle,
        //       //       image: DecorationImage(
        //       //           image: AssetImage('assets/images/apple.png'))),
        //       // ),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: 14,
        // ),
        FadeInUp(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 900),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                  onPressed: () {
                    controller.cleanController();
                    controller.isLoginPage(true);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF835DF1),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    super.key,
    required this.controller,
    required this.context,
  });

  final AuthController controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(
        //   height: 14,
        // ),
        // FadeInDown(
        //   delay: const Duration(milliseconds: 900),
        //   duration: const Duration(milliseconds: 1000),
        //   child: IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: const Icon(
        //         Icons.arrow_back_ios,
        //       )),
        // ),
        const SizedBox(
          height: 70,
        ),
        FadeInDown(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 900),
          child: const Text(
            'Let\'s Sign You In',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FadeInDown(
          delay: const Duration(milliseconds: 700),
          duration: const Duration(milliseconds: 800),
          child: const Text(
            'Welcome Back.',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        FadeInDown(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 700),
          child: const Text(
            'You\'ve been missed!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Form(
          key: controller.loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 800),
                child: const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 700),
                child: TextFormField(
                  controller: controller.emailController,
                  validator: (value) => controller.validateEmail(value!),
                  decoration: const InputDecoration(
                      //isDense: true,
                      //contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                      hintText: 'Your Email'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 500),
                child: Obx(() => TextFormField(
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
                          hintText: 'Password'),
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 700),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    bool isValidate =
                        controller.checkForm(controller.loginFormKey);
                    if (isValidate) {
                      controller.loginWithEmail();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      //elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      backgroundColor: const Color(0xFF835DF1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    duration: const Duration(milliseconds: 800),
                    child: Obx(() => controller.isLoading.value == false
                        ? const Text('Sign In',
                            style: TextStyle(color: Colors.white))
                        : const SizedBox(
                            width: 18,
                            height: 18,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          )),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // FadeInUp(
        //   delay: const Duration(milliseconds: 600),
        //   duration: const Duration(milliseconds: 700),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         width: 40,
        //         height: 40,
        //         decoration: const BoxDecoration(
        //             shape: BoxShape.circle,
        //             image: DecorationImage(
        //                 image: AssetImage('assets/images/facebook.png'))),
        //       ),
        //       const SizedBox(
        //         width: 20,
        //       ),
        //       Container(
        //         width: 40,
        //         height: 40,
        //         decoration: const BoxDecoration(
        //             shape: BoxShape.circle,
        //             image: DecorationImage(
        //                 image: AssetImage('assets/images/google.png'))),
        //       ),
        //       // const SizedBox(
        //       //   width: 20,
        //       // ),
        //       // Container(
        //       //   width: 40,
        //       //   height: 40,
        //       //   decoration: const BoxDecoration(
        //       //       shape: BoxShape.circle,
        //       //       image: DecorationImage(
        //       //           image: AssetImage('assets/images/apple.png'))),
        //       // ),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: 14,
        // ),
        FadeInUp(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 900),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account?',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                  onPressed: () {
                    controller.cleanController();
                    controller.isLoginPage(false);
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Color(0xFF835DF1),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
