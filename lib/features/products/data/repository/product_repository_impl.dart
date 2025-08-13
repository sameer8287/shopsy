import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pocket_fm/features/products/data/model/product_model.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:pocket_fm/features/products/domain/repository/product_repository.dart';
import 'package:collection/collection.dart';

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<List<ProductEntity>> getProductsList() async {
    final String response = await rootBundle.loadString('assets/data/product_list.json');
    final data = jsonDecode(response)['categories'][0]['products'];
    if (data != null && data is List) {
      return data.map((item) => ProductModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    List<ProductEntity> lst = [];
    final String response = await rootBundle.loadString('assets/data/product_list.json');
    final data = jsonDecode(response)['categories'][0]['products'];
    if (data != null && data is List) {
      lst = data.map((item) => ProductModel.fromJson(item)).toList();
    }

    return lst.firstWhereOrNull((element) => element.id == id);
  }
}
