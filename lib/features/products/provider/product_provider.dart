import 'package:flutter/cupertino.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:pocket_fm/features/products/domain/usecase/product_usecase.dart';

class ProductProvider extends ChangeNotifier {
  final ProductUseCase _productUseCase;

  ProductProvider(this._productUseCase);

  List<ProductEntity> _productList = [];

  List<ProductEntity> get productList => _productList;

  ProductEntity? _productDetail;

  ProductEntity? get productDetail => _productDetail;

  Future<void> getProductList() async {
    _productList = await _productUseCase.getProducts();
    notifyListeners();
  }

  Future<void> getProductById(String id) async {
    _productDetail = await _productUseCase.getProductById(id);
    notifyListeners();
  }
}