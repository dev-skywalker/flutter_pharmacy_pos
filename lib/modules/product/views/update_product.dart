import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/product/model/product_model.dart';

class UpdateProductPage extends StatelessWidget {
  const UpdateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    print(Get.arguments);
    ProductModel productModel = Get.arguments as ProductModel;
    String id = Get.parameters['id'] ?? '';
    print(id);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Update Product"),
            Text("param $id"),
            Text("arg ${productModel.name}"),
          ],
        ),
      ),
    );
  }
}
