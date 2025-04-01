class PurchaseDetailsModel {
  PurchaseDetailsModel({
    required this.id,
    required this.date,
    required this.status,
    required this.amount,
    required this.shipping,
    required this.paymentType,
    required this.paymentStatus,
    required this.refCode,
    required this.note,
    required this.warehouse,
    required this.supplier,
    required this.createdAt,
    required this.updatedAt,
    required this.purchaseItems,
  });

  final int? id;
  final int? date;
  final int? status;
  final int? amount;
  final int? shipping;
  final PaymentType? paymentType;
  final int? paymentStatus;
  final String? refCode;
  final String? note;
  final Supplier? warehouse;
  final Supplier? supplier;
  final int? createdAt;
  final int? updatedAt;
  final List<PurchaseItem> purchaseItems;

  factory PurchaseDetailsModel.fromJson(Map<String, dynamic> json) {
    return PurchaseDetailsModel(
      id: json["id"],
      date: json["date"],
      status: json["status"],
      amount: json["amount"],
      shipping: json["shipping"],
      paymentType: json["paymentType"] == null
          ? null
          : PaymentType.fromJson(json["paymentType"]),
      paymentStatus: json["paymentStatus"],
      refCode: json["refCode"],
      note: json["note"],
      warehouse: json["warehouse"] == null
          ? null
          : Supplier.fromJson(json["warehouse"]),
      supplier:
          json["supplier"] == null ? null : Supplier.fromJson(json["supplier"]),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      purchaseItems: json["purchaseItems"] == null
          ? []
          : List<PurchaseItem>.from(
              json["purchaseItems"]!.map((x) => PurchaseItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "status": status,
        "amount": amount,
        "shipping": shipping,
        "paymentType": paymentType?.toJson(),
        "paymentStatus": paymentStatus,
        "refCode": refCode,
        "note": note,
        "warehouse": warehouse?.toJson(),
        "supplier": supplier?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "purchaseItems": purchaseItems.map((x) => x.toJson()).toList(),
      };
}

class PaymentType {
  PaymentType({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class PurchaseItem {
  PurchaseItem({
    required this.productId,
    required this.quantity,
    required this.productCost,
    required this.itemSubTotal,
    required this.productName,
    required this.unitName,
  });

  final int? productId;
  final int? quantity;
  final int? productCost;
  final int? itemSubTotal;
  final String? productName;
  final String? unitName;

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      productId: json["productId"],
      quantity: json["quantity"],
      productCost: json["productCost"],
      itemSubTotal: json["itemSubTotal"],
      productName: json["productName"],
      unitName: json["unitName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "quantity": quantity,
        "productCost": productCost,
        "itemSubTotal": itemSubTotal,
        "productName": productName,
        "unitName": unitName,
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
