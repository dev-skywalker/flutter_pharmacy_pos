class SaleReturnDetailsModel {
  SaleReturnDetailsModel({
    required this.id,
    required this.date,
    required this.status,
    required this.amount,
    required this.note,
    required this.warehouse,
    required this.customer,
    required this.createdAt,
    required this.updatedAt,
    required this.salesReturnItems,
  });

  final int? id;
  final int? date;
  final int? status;
  final int? amount;
  final String? note;
  final Customer? warehouse;
  final Customer? customer;
  final int? createdAt;
  final int? updatedAt;
  final List<SalesReturnItem> salesReturnItems;

  factory SaleReturnDetailsModel.fromJson(Map<String, dynamic> json) {
    return SaleReturnDetailsModel(
      id: json["id"],
      date: json["date"],
      status: json["status"],
      amount: json["amount"],
      note: json["note"],
      warehouse: json["warehouse"] == null
          ? null
          : Customer.fromJson(json["warehouse"]),
      customer:
          json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      salesReturnItems: json["salesReturnItems"] == null
          ? []
          : List<SalesReturnItem>.from(json["salesReturnItems"]!
              .map((x) => SalesReturnItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "status": status,
        "amount": amount,
        "note": note,
        "warehouse": warehouse?.toJson(),
        "customer": customer?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "salesReturnItems": salesReturnItems.map((x) => x.toJson()).toList(),
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

class SalesReturnItem {
  SalesReturnItem({
    required this.productId,
    required this.quantity,
    required this.subTotal,
    required this.productName,
    required this.productPrice,
    required this.productCost,
    required this.unitName,
  });

  final int? productId;
  final int? quantity;
  final int? subTotal;
  final String? productName;
  final int? productPrice;
  final int? productCost;
  final String? unitName;

  factory SalesReturnItem.fromJson(Map<String, dynamic> json) {
    return SalesReturnItem(
      productId: json["productId"],
      quantity: json["quantity"],
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
        "subTotal": subTotal,
        "productName": productName,
        "productPrice": productPrice,
        "productCost": productCost,
        "unitName": unitName,
      };
}
