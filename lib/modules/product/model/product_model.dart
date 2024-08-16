import '../../units/model/unit_model.dart';

class ProductModel {
  int? id;
  String? name;
  String? barcode;
  String? description;
  String? imageUrl;
  int? tabletOnCard;
  int? cardOnBox;
  bool? isLocalProduct;
  int? unitId;
  int? createdAt;
  int? updatedAt;
  Units? units;

  ProductModel({
    this.id,
    this.name,
    this.barcode,
    this.description,
    this.imageUrl,
    this.tabletOnCard,
    this.cardOnBox,
    this.isLocalProduct,
    this.unitId,
    this.createdAt,
    this.updatedAt,
    this.units,
  });
}
