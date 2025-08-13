

import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';

class CartEntity {
  final String? productId;
  final int? quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? price;
  final ProductEntity? product;

  CartEntity({
    this.productId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.product,
  });

  CartEntity copyWith({
    String? productId,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? price,
    ProductEntity? productEntity,
  }) => CartEntity(
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    price: price ?? this.price,
    product: productEntity ?? this.product,
  );


}
