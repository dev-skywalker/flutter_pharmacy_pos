class SaleDetailsModel {
  SaleDetailsModel({
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
    required this.paymentType,
    required this.note,
    required this.warehouse,
    required this.customer,
    required this.createdAt,
    required this.updatedAt,
    required this.saleItems,
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
  final PaymentType? paymentType;
  final String? note;
  final Customer? warehouse;
  final Customer? customer;
  final int? createdAt;
  final int? updatedAt;
  final List<SaleItem> saleItems;

  factory SaleDetailsModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailsModel(
      id: json["id"],
      date: json["date"],
      status: json["status"],
      amount: json["amount"],
      shipping: json["shipping"],
      discount: json["discount"],
      taxPercent: json["taxPercent"],
      taxAmount: json["taxAmount"],
      totalAmount: json["totalAmount"],
      paymentStatus: json["paymentStatus"],
      paymentType: json["paymentType"] == null
          ? null
          : PaymentType.fromJson(json["paymentType"]),
      note: json["note"],
      warehouse: json["warehouse"] == null
          ? null
          : Customer.fromJson(json["warehouse"]),
      customer:
          json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      saleItems: json["saleItems"] == null
          ? []
          : List<SaleItem>.from(
              json["saleItems"]!.map((x) => SaleItem.fromJson(x))),
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
        "paymentType": paymentType?.toJson(),
        "note": note,
        "warehouse": warehouse?.toJson(),
        "customer": customer?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "saleItems": saleItems.map((x) => x.toJson()).toList(),
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

class SaleItem {
  SaleItem({
    required this.productId,
    required this.quantity,
    required this.stock,
    required this.profit,
    required this.subTotal,
    required this.productName,
    required this.productPrice,
    required this.productCost,
    required this.unitName,
  });

  final int? productId;
  final int? quantity;
  final int? stock;
  final int? profit;
  final int? subTotal;
  final String? productName;
  final int? productPrice;
  final int? productCost;
  final String? unitName;

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      productId: json["productId"],
      quantity: json["quantity"],
      stock: json["stock"],
      profit: json["profit"],
      subTotal: json["subTotal"],
      productName: json["productName"],
      productPrice: json["productPrice"],
      productCost: json["productCost"],
      unitName: json["unitName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "quantity": quantity,
        "profit": profit,
        "subTotal": subTotal,
        "productName": productName,
        "productPrice": productPrice,
        "productCost": productCost,
        "unitName": unitName,
      };
}
