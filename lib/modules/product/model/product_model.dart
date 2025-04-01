import '../../brands/model/brand_model.dart';
import '../../category/model/category_model.dart';
import '../../units/model/unit_model.dart';

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    this.barcode,
    this.description,
    this.productCost,
    this.productPrice,
    this.stockAlert,
    this.quantityLimit,
    this.expireDate,
    this.imageUrl,
    this.tabletOnCard,
    this.cardOnBox,
    this.isLocalProduct,
    required this.unitId,
    required this.brandId,
    this.createdAt,
    this.updatedAt,
    required this.unit,
    required this.brand,
    required this.productCategories,
  });

  final int id;
  final String name;
  final String? barcode;
  final String? description;
  int? productCost;
  int? productPrice;
  final int? stockAlert;
  final int? quantityLimit;
  final int? expireDate;
  final String? imageUrl;
  final int? tabletOnCard;
  final int? cardOnBox;
  final bool? isLocalProduct;
  final int unitId;
  final int brandId;
  final int? createdAt;
  final int? updatedAt;
  final Units unit;
  final Brands brand;
  final List<ProductCategory> productCategories;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"],
      barcode: json["barcode"],
      description: json["description"],
      productCost: json["productCost"],
      productPrice: json["productPrice"],
      stockAlert: json["stockAlert"],
      quantityLimit: json["quantityLimit"],
      expireDate: json["expireDate"],
      imageUrl: json["imageUrl"],
      tabletOnCard: json["tabletOnCard"],
      cardOnBox: json["cardOnBox"],
      isLocalProduct: json["isLocalProduct"],
      unitId: json["unitId"],
      brandId: json["brandId"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      unit: Units.fromJson(json["unit"]),
      brand: Brands.fromJson(json["brand"]),
      productCategories: json["productCategories"] == null
          ? []
          : List<ProductCategory>.from(json["productCategories"]!
              .map((x) => ProductCategory.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "description": description,
        "productCost": productCost,
        "productPrice": productPrice,
        "stockAlert": stockAlert,
        "quantityLimit": quantityLimit,
        "expireDate": expireDate,
        "imageUrl": imageUrl,
        "tabletOnCard": tabletOnCard,
        "cardOnBox": cardOnBox,
        "isLocalProduct": isLocalProduct,
        "unitId": unitId,
        "brandId": brandId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "unit": unit.toJson(),
        "brand": brand.toJson(),
        "productCategories": productCategories.map((x) => x.toJson()).toList(),
      };
}

class ProductCategory {
  ProductCategory({
    required this.category,
  });

  final Category? category;

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      category:
          json["category"] == null ? null : Category.fromJson(json["category"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "category": category?.toJson(),
      };
}
