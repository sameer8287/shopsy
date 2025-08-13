// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

import 'package:pocket_fm/features/products/data/model/product_model.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:pocket_fm/features/cart/domain/entity/cart_entity.dart';

CartModel cartFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartToJson(CartModel data) => json.encode(data.toJson());

class CartModel extends CartEntity {
  final String? productId;
  final int? quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? price;
  final ProductModel? product;

  CartModel({this.productId, this.quantity, this.createdAt, this.updatedAt, this.price, this.product});

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    productId: json["product_id"],
    quantity: json["quantity"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    price: json["price"]?.toDouble(),
    product: json["product_data"] == null ? null : ProductModel.fromJson(jsonDecode(json["product_data"])),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "quantity": quantity,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "price": price,
    "product_data": product?.toJson(),
  };
}
