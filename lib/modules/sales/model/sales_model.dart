class SalesModel {
  SalesModel({
    required this.id,
    required this.date,
    required this.status,
    required this.amount,
    required this.shipping,
    required this.discount,
    required this.taxPercent,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentStatus,
    required this.note,
    required this.warehouse,
    required this.customer,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? date;
  final int? status;
  final int? amount;
  final int? shipping;
  final int? discount;
  final int? taxPercent;
  final int? taxAmount;
  final int? totalAmount;
  final int? paymentStatus;
  final String? note;
  final Customer? warehouse;
  final Customer? customer;
  final int? createdAt;
  final int? updatedAt;

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      id: json["id"],
      date: json["date"],
      status: json["status"],
      amount: json["amount"],
      shipping: json["shipping"],
      discount: json["discount"],
      taxPercent: json["taxPercent"],
      taxAmount: json['taxAmount'],
      totalAmount: json['totalAmount'],
      paymentStatus: json["paymentStatus"],
      note: json["note"],
      warehouse: json["warehouse"] == null
          ? null
          : Customer.fromJson(json["warehouse"]),
      customer:
          json["customer"] == null ? null : Customer.fromJson(json["customer"]),
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
        "discount": discount,
        "taxPercent": taxPercent,
        "taxAmount": taxAmount,
        "totalAmount": totalAmount,
        "paymentStatus": paymentStatus,
        "note": note,
        "warehouse": warehouse?.toJson(),
        "customer": customer?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class Customer {
  Customer({
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

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
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
