class BestSellingProductModel {
  BestSellingProductModel({
    required this.productId,
    required this.productName,
    required this.productUnit,
    required this.productQuantitySold,
    required this.productSalesAmount,
    required this.totalProfit,
  });

  final int? productId;
  final String? productName;
  final String? productUnit;
  final int? productQuantitySold;
  final int? productSalesAmount;
  final int? totalProfit;

  factory BestSellingProductModel.fromJson(Map<String, dynamic> json) {
    return BestSellingProductModel(
      productId: json["productId"],
      productName: json["productName"],
      productUnit: json["productUnit"],
      productQuantitySold: json["productQuantitySold"],
      productSalesAmount: json["productSalesAmount"],
      totalProfit: json["totalProfit"],
    );
  }

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "productUnit": productUnit,
        "productQuantitySold": productQuantitySold,
        "productSalesAmount": productSalesAmount,
        "totalProfit": totalProfit,
      };
}
