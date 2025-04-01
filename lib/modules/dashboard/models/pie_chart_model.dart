import 'package:flutter/material.dart';

class PieChartModel {
  PieChartModel({
    required this.productName,
    required this.qty,
    required this.color,
  });

  final String? productName;
  final int? qty;
  final Color? color;

  factory PieChartModel.fromJson(Map<String, dynamic> json) {
    return PieChartModel(
      productName: json["productName"],
      qty: json["qty"],
      color: json["color"],
    );
  }

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "qty": qty,
        "color": color,
      };
}
