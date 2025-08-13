import 'dart:convert';

import 'package:pocket_fm/data/local/db_helper.dart';
import 'package:pocket_fm/features/cart/data/local/schema/cart_schema.dart';
import 'package:pocket_fm/features/cart/data/model/cart_model.dart';
import 'package:pocket_fm/features/cart/domain/entity/cart_entity.dart';
import 'package:pocket_fm/features/cart/domain/repository/cart_repository.dart';
import 'package:pocket_fm/features/products/data/model/product_model.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class CartRepositoryImpl extends CartRepository {
  @override
  Future<void> addToCart(String productId, int quantity) {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  @override
  Future<List<CartEntity>> getCartItems() async {
    final db = DatabaseHelper.instance;

    List<Map<String, dynamic>> data = await db.queryAllRows(CartSchema.tableName,orderBy: '${CartSchema.columnProductId} ASC');
    List<CartEntity> cartItems = data.map((item) => CartModel.fromJson(item)).toList();
    return cartItems;
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final db = DatabaseHelper.instance;
    await db.delete(CartSchema.tableName, where: '${CartSchema.columnProductId} = ?', whereArgs: [productId]);
  }

  @override
  Future<void> updateCartItemQuantity(CartEntity cart) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(CartSchema.tableName, {
      CartSchema.columnProductId: cart.productId,
      CartSchema.columnQuantity: cart.quantity,
      CartSchema.columnUpdatedAt: DateTime.now().toIso8601String(),
      CartSchema.columnPrice: cart.price ?? 0.0,
      CartSchema.columnProductData: jsonEncode((cart.product as ProductModel).toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
