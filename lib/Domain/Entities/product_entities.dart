class ProductEntity {
  final int id;
  final int groupId;
  final int categoryId;
  final int brandId;
  final int unitId;
  final String code;
  final String name;
  final String price;
  final String quantity;
  final String discount;
  final String model;
  final String warrantyDay;
  final String? lifeTime;
  final int openingBalance;
  final String openingBalanceDate;
  final String slug;
  final String assetType;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final StockEntity stock;

  ProductEntity({
    required this.id,
    required this.groupId,
    required this.categoryId,
    required this.brandId,
    required this.unitId,
    required this.code,
    required this.name,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.model,
    required this.warrantyDay,
    required this.lifeTime,
    required this.openingBalance,
    required this.openingBalanceDate,
    required this.slug,
    required this.assetType,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.stock,
  });
}

class StockEntity {
  final int id;
  final String quantity;
  final int productId;
  final String price;
  final String finalPrice;
  final String discount;

  StockEntity({
    required this.id,
    required this.quantity,
    required this.productId,
    required this.price,
    required this.finalPrice,
    required this.discount,
  });
}