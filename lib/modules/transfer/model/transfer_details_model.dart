class TransferDetailsModel {
  TransferDetailsModel({
    required this.transferId,
    required this.transferDate,
    required this.transferStatus,
    required this.transferAmount,
    required this.transferShipping,
    required this.note,
    required this.fromWarehouse,
    required this.toWarehouse,
    required this.createdAt,
    required this.updatedAt,
    required this.transferItems,
  });

  final int? transferId;
  final int? transferDate;
  final int? transferStatus;
  final int? transferAmount;
  final int? transferShipping;
  final String? note;
  final Warehouse? fromWarehouse;
  final Warehouse? toWarehouse;
  final int? createdAt;
  final int? updatedAt;
  final List<TransferItem> transferItems;

  factory TransferDetailsModel.fromJson(Map<String, dynamic> json) {
    return TransferDetailsModel(
      transferId: json["transferId"],
      transferDate: json["transferDate"],
      transferStatus: json["transferStatus"],
      transferAmount: json["transferAmount"],
      transferShipping: json["transferShipping"],
      note: json["note"],
      fromWarehouse: json["fromWarehouse"] == null
          ? null
          : Warehouse.fromJson(json["fromWarehouse"]),
      toWarehouse: json["toWarehouse"] == null
          ? null
          : Warehouse.fromJson(json["toWarehouse"]),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      transferItems: json["transferItems"] == null
          ? []
          : List<TransferItem>.from(
              json["transferItems"]!.map((x) => TransferItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "transferId": transferId,
        "transferDate": transferDate,
        "transferStatus": transferStatus,
        "transferAmount": transferAmount,
        "transferShipping": transferShipping,
        "note": note,
        "fromWarehouse": fromWarehouse?.toJson(),
        "toWarehouse": toWarehouse?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "transferItems": transferItems.map((x) => x.toJson()).toList(),
      };
}

class Warehouse {
  Warehouse({
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

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
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

class TransferItem {
  TransferItem({
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.subTotal,
    required this.productPrice,
    required this.productCost,
    required this.unitName,
  });

  final int? productId;
  final int? quantity;
  final String? productName;
  final int? subTotal;
  final int? productPrice;
  final int? productCost;
  final String? unitName;

  factory TransferItem.fromJson(Map<String, dynamic> json) {
    return TransferItem(
      productId: json["productId"],
      quantity: json["quantity"],
      productName: json["productName"],
      subTotal: json["subTotal"],
      productPrice: json["productPrice"],
      productCost: json["productCost"],
      unitName: json["unitName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "quantity": quantity,
        "productName": productName,
        "subTotal": subTotal,
        "productPrice": productPrice,
        "productCost": productCost,
        "unitName": unitName,
      };
}
