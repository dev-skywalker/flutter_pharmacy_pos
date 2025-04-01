class StockAlertModel {
  StockAlertModel({
    required this.productId,
    required this.productName,
    required this.warehouseName,
    required this.warehouseId,
    required this.unitName,
    required this.productCost,
    required this.productPrice,
    required this.quantity,
    required this.alertLevel,
  });

  final int? productId;
  final String? productName;
  final String? warehouseName;
  final int? warehouseId;
  final String? unitName;
  final int? productCost;
  final int? productPrice;
  final int? quantity;
  final int? alertLevel;

  factory StockAlertModel.fromJson(Map<String, dynamic> json) {
    return StockAlertModel(
      productId: json["productId"],
      productName: json["productName"],
      unitName: json["unitName"],
      productCost: json["productCost"],
      productPrice: json["productPrice"],
      quantity: json["quantity"],
      alertLevel: json["alertLevel"],
      warehouseName: json["warehouseName"],
      warehouseId: json["warehouseId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "unitName": unitName,
        "productCost": productCost,
        "productPrice": productPrice,
        "quantity": quantity,
        "alertLevel": alertLevel,
        "warehouseName": warehouseName,
        "warehouseId": warehouseId
      };
}
