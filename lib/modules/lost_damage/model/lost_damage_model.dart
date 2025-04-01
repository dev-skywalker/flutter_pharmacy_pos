class LostDamageModel {
  LostDamageModel({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.reason,
    required this.warehouseName,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? productName;
  final int? quantity;
  final int? amount;
  final String? reason;
  final String? warehouseName;
  final int? createdAt;
  final int? updatedAt;

  factory LostDamageModel.fromJson(Map<String, dynamic> json) {
    return LostDamageModel(
      id: json["id"],
      productName: json["productName"],
      quantity: json["quantity"],
      amount: json["amount"],
      reason: json["reason"],
      warehouseName: json["warehouseName"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "quantity": quantity,
        "amount": amount,
        "reason": reason,
        "warehouseName": warehouseName,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
