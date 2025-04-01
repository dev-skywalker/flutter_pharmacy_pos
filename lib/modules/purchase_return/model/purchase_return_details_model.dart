class PurchaseReturnDetailsModel {
  PurchaseReturnDetailsModel({
    required this.purchaseReturn,
    required this.purchaseReturnDate,
    required this.purchaseReturnStatus,
    required this.purchaseReturnReturnAmount,
    required this.purchaseReturnReturnNote,
    required this.warehouse,
    required this.supplier,
    required this.purchaseReturnItems,
  });

  final int? purchaseReturn;
  final int? purchaseReturnDate;
  final int? purchaseReturnStatus;
  final int? purchaseReturnReturnAmount;
  final String? purchaseReturnReturnNote;
  final Warehouse? warehouse;
  final Supplier? supplier;
  final List<PurchaseReturnItem> purchaseReturnItems;

  factory PurchaseReturnDetailsModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReturnDetailsModel(
      purchaseReturn: json["purchaseReturn"],
      purchaseReturnDate: json["purchaseReturnDate"],
      purchaseReturnStatus: json["purchaseReturnStatus"],
      purchaseReturnReturnAmount: json["purchaseReturnReturnAmount"],
      purchaseReturnReturnNote: json["purchaseReturnReturnNote"],
      warehouse: json["warehouse"] == null
          ? null
          : Warehouse.fromJson(json["warehouse"]),
      supplier:
          json["supplier"] == null ? null : Supplier.fromJson(json["supplier"]),
      purchaseReturnItems: json["purchaseReturnItems"] == null
          ? []
          : List<PurchaseReturnItem>.from(json["purchaseReturnItems"]!
              .map((x) => PurchaseReturnItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "purchaseReturn": purchaseReturn,
        "purchaseReturnDate": purchaseReturnDate,
        "purchaseReturnStatus": purchaseReturnStatus,
        "purchaseReturnReturnAmount": purchaseReturnReturnAmount,
        "purchaseReturnReturnNote": purchaseReturnReturnNote,
        "warehouse": warehouse?.toJson(),
        "supplier": supplier?.toJson(),
        "purchaseReturnItems":
            purchaseReturnItems.map((x) => x.toJson()).toList(),
      };
}

class PurchaseReturnItem {
  PurchaseReturnItem({
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

  factory PurchaseReturnItem.fromJson(Map<String, dynamic> json) {
    return PurchaseReturnItem(
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

class Supplier {
  Supplier({
    required this.supplierId,
    required this.supplierName,
    required this.supplierPhone,
    required this.supplierEmail,
    required this.supplierAddress,
    required this.supplierCity,
  });

  final int? supplierId;
  final String? supplierName;
  final String? supplierPhone;
  final String? supplierEmail;
  final String? supplierAddress;
  final String? supplierCity;

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplierId: json["supplierId"],
      supplierName: json["supplierName"],
      supplierPhone: json["supplierPhone"],
      supplierEmail: json["supplierEmail"],
      supplierAddress: json["supplierAddress"],
      supplierCity: json["supplierCity"],
    );
  }

  Map<String, dynamic> toJson() => {
        "supplierId": supplierId,
        "supplierName": supplierName,
        "supplierPhone": supplierPhone,
        "supplierEmail": supplierEmail,
        "supplierAddress": supplierAddress,
        "supplierCity": supplierCity,
      };
}

class Warehouse {
  Warehouse({
    required this.warehouseId,
    required this.warehouseName,
    required this.warehousePhone,
    required this.warehouseEmail,
    required this.warehouseAddress,
    required this.warehouseCity,
  });

  final int? warehouseId;
  final String? warehouseName;
  final String? warehousePhone;
  final String? warehouseEmail;
  final String? warehouseAddress;
  final String? warehouseCity;

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      warehouseId: json["warehouseId"],
      warehouseName: json["warehouseName"],
      warehousePhone: json["warehousePhone"],
      warehouseEmail: json["warehouseEmail"],
      warehouseAddress: json["warehouseAddress"],
      warehouseCity: json["warehouseCity"],
    );
  }

  Map<String, dynamic> toJson() => {
        "warehouseId": warehouseId,
        "warehouseName": warehouseName,
        "warehousePhone": warehousePhone,
        "warehouseEmail": warehouseEmail,
        "warehouseAddress": warehouseAddress,
        "warehouseCity": warehouseCity,
      };
}
