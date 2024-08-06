import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/routes/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final auth = Get.find<CheckAuthService>();
    // auth.subscribe();
    // _navigateToNextScreen(auth.authed.value);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Home Page',
              style: TextStyle(fontSize: 50, color: Colors.amber),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.offNamed(Routes.app);
                },
                child: const Text("Go App"))
          ],
        ),
      ),
    );
  }

  // void _navigateToNextScreen(bool isLoggedIn) async {
  //   //await Future.delayed(Duration(seconds: 2)); // Simulate some loading time

  //   // Example condition: Check if user is logged in

  //   if (isLoggedIn) {
  //     Get.offNamed(Routes.app); // Replace with your home route
  //   } else {
  //     Get.offNamed(Routes.login); // Replace with your login route
  //   }
  // }
}
