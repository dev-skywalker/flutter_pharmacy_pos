class PaymentTypeModel {
  PaymentTypeModel({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? name;
  final int? createdAt;
  final int? updatedAt;

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypeModel(
      id: json["id"],
      name: json["name"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
