class StockModel {
  StockModel({
    required this.productId,
    required this.productName,
    required this.productCost,
    required this.productPrice,
    required this.expireDate,
    required this.warehouseStock,
    required this.unit,
  });

  final int? productId;
  final String? productName;
  final int? productCost;
  final int? productPrice;
  final int? expireDate;
  final int? warehouseStock;
  final String? unit;

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      productId: json["productId"],
      productName: json["productName"],
      productCost: json["productCost"],
      productPrice: json["productPrice"],
      expireDate: json["expireDate"],
      warehouseStock: json["warehouseStock"],
      unit: json["unit"],
    );
  }

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "productCost": productCost,
        "productPrice": productPrice,
        "expireDate": expireDate,
        "warehouseStock": warehouseStock,
        "unit": unit,
      };
}
