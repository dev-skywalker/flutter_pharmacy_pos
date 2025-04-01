class TransferModel {
  TransferModel({
    required this.id,
    required this.date,
    required this.status,
    required this.note,
    required this.fromWarehouseName,
    required this.toWarehouseName,
    required this.amount,
    required this.shipping,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? date;
  final int? status;
  final String? note;
  final String? fromWarehouseName;
  final String? toWarehouseName;
  final int? amount;
  final int? shipping;
  final int? createdAt;
  final int? updatedAt;

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json["id"],
      date: json["date"],
      status: json["status"],
      note: json["note"],
      fromWarehouseName: json["fromWarehouseName"],
      toWarehouseName: json["toWarehouseName"],
      amount: json["amount"],
      shipping: json["shipping"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "status": status,
        "note": note,
        "fromWarehouseName": fromWarehouseName,
        "toWarehouseName": toWarehouseName,
        "amount": amount,
        "shipping": shipping,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
