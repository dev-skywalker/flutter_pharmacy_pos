class PurchaseTotalModel {
  PurchaseTotalModel({
    required this.totalPurchaseAmount,
    required this.totalShippingAmount,
    required this.totalQuantityPurchased,
    required this.totalPaymentPurchased,
  });

  final int? totalPurchaseAmount;
  final int? totalShippingAmount;
  final int? totalQuantityPurchased;
  final int? totalPaymentPurchased;

  factory PurchaseTotalModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTotalModel(
      totalPurchaseAmount: json["totalPurchaseAmount"],
      totalShippingAmount: json["totalShippingAmount"],
      totalQuantityPurchased: json["totalQuantityPurchased"],
      totalPaymentPurchased: json["totalPaymentPurchased"],
    );
  }

  Map<String, dynamic> toJson() => {
        "totalPurchaseAmount": totalPurchaseAmount,
        "totalShippingAmount": totalShippingAmount,
        "totalQuantityPurchased": totalQuantityPurchased,
        "totalPaymentPurchased": totalPaymentPurchased,
      };
}
