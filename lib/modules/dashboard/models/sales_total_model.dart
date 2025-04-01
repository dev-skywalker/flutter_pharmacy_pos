class SalesTotalModel {
  SalesTotalModel({
    required this.totalSalesAmount,
    required this.totalShippingAmount,
    required this.totalTaxAmount,
    required this.totalDiscountAmount,
    required this.totalQuantitySold,
    required this.totalProfit,
    required this.paymentReceivedAmount,
  });

  final int? totalSalesAmount;
  final int? totalShippingAmount;
  final int? totalTaxAmount;
  final int? totalDiscountAmount;
  final int? totalQuantitySold;
  final int? totalProfit;
  final int? paymentReceivedAmount;

  factory SalesTotalModel.fromJson(Map<String, dynamic> json) {
    return SalesTotalModel(
      totalSalesAmount: json["totalSalesAmount"],
      totalShippingAmount: json["totalShippingAmount"],
      totalTaxAmount: json["totalTaxAmount"],
      totalDiscountAmount: json["totalDiscountAmount"],
      totalQuantitySold: json["totalQuantitySold"],
      totalProfit: json["totalProfit"],
      paymentReceivedAmount: json["paymentReceivedAmount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "totalSalesAmount": totalSalesAmount,
        "totalShippingAmount": totalShippingAmount,
        "totalTaxAmount": totalTaxAmount,
        "totalDiscountAmount": totalDiscountAmount,
        "totalQuantitySold": totalQuantitySold,
        "totalProfit": totalProfit,
        "paymentReceivedAmount": paymentReceivedAmount,
      };
}
