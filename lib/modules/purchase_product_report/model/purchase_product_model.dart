class PurchaseProductModel {
  PurchaseProductModel({
    required this.id,
    required this.date,
    required this.status,
    required this.amount,
    required this.shipping,
    required this.paymentStatus,
    required this.refCode,
    required this.note,
    required this.supplier,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? date;
  final int? status;
  final int? amount;
  final int? shipping;
  final int? paymentStatus;
  final String? refCode;
  final String? note;
  final Supplier? supplier;
  final int? createdAt;
  final int? updatedAt;

  factory PurchaseProductModel.fromJson(Map<String, dynamic> json) {
    return PurchaseProductModel(
      id: json["id"],
      date: json["date"],
      status: json["status"],
      amount: json["amount"],
      shipping: json["shipping"],
      paymentStatus: json["paymentStatus"],
      refCode: json["refCode"],
      note: json["note"],
      supplier:
          json["supplier"] == null ? null : Supplier.fromJson(json["supplier"]),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "status": status,
        "amount": amount,
        "shipping": shipping,
        "paymentStatus": paymentStatus,
        "refCode": refCode,
        "note": note,
        "supplier": supplier?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class Supplier {
  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.address,
  });

  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? city;
  final String? address;

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      city: json["city"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "address": address,
      };
}
