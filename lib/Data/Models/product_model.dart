// lib/core/models/product_model.dart

import '../../Domain/Entities/product_entities.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required int id,
    required String groupId,
    required String categoryId,
    required String brandId,
    required String unitId,
    required String code,
    required String name,
    required String price,
    required String quantity,
    required String discount,
    required String model,
    required String warrantyDay,
    String? lifeTime,
    required String openingBalance,
    required String openingBalanceDate,
    required String slug,
    required String assetType,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    required StockModel stock,
  }) : super(
    id: id,
    groupId: groupId,
    categoryId: categoryId,
    brandId: brandId,
    unitId: unitId,
    code: code,
    name: name,
    price: price,
    quantity: quantity,
    discount: discount,
    model: model,
    warrantyDay: warrantyDay,
    lifeTime: lifeTime,
    openingBalance: openingBalance,
    openingBalanceDate: openingBalanceDate,
    slug: slug,
    assetType: assetType,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    stock: stock,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      groupId: json['group_id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      brandId: json['brand_id'] as String? ?? '',
      unitId: json['unit_id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      price: json['price'] as String? ?? '0',
      quantity: json['quantity'] as String? ?? '0',
      discount: json['discount'] as String? ?? '0',
      model: json['model'] as String? ?? '',
      warrantyDay: json['warranty_day'] as String? ?? '0',
      lifeTime: json['life_time'] as String?,
      openingBalance: json['opening_balance'] as String? ?? '0',
      openingBalanceDate: json['opening_balance_date'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      assetType: json['asset_type'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      stock: StockModel.fromJson(json['stock'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'category_id': categoryId,
      'brand_id': brandId,
      'unit_id': unitId,
      'code': code,
      'name': name,
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'model': model,
      'warranty_day': warrantyDay,
      'life_time': lifeTime,
      'opening_balance': openingBalance,
      'opening_balance_date': openingBalanceDate,
      'slug': slug,
      'asset_type': assetType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'stock': (stock as StockModel).toJson(),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      groupId: groupId,
      categoryId: categoryId,
      brandId: brandId,
      unitId: unitId,
      code: code,
      name: name,
      price: price,
      quantity: quantity,
      discount: discount,
      model: model,
      warrantyDay: warrantyDay,
      lifeTime: lifeTime,
      openingBalance: openingBalance,
      openingBalanceDate: openingBalanceDate,
      slug: slug,
      assetType: assetType,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      stock: (stock as StockModel).toEntity(),
    );
  }
}

class StockModel extends StockEntity {
  StockModel({
    required int id,
    required String quantity,
    required String productId,
    required String price,
    required String finalPrice,
    required String discount,
  }) : super(
    id: id,
    quantity: quantity,
    productId: productId,
    price: price,
    finalPrice: finalPrice,
    discount: discount,
  );

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] as int? ?? 0,
      quantity: json['quantity'] as String? ?? '0',
      productId: json['product_id'] as String? ?? '',
      price: json['price'] as String? ?? '0',
      finalPrice: json['final_price'] as String? ?? '0',
      discount: json['discount'] as String? ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'product_id': productId,
      'price': price,
      'final_price': finalPrice,
      'discount': discount,
    };
  }

  StockEntity toEntity() {
    return StockEntity(
      id: id,
      quantity: quantity,
      productId: productId,
      price: price,
      finalPrice: finalPrice,
      discount: discount,
    );
  }
}