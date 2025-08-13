import 'package:pocket_fm/features/products/data/repository/product_repository_impl.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProductsList();
  Future<ProductEntity?> getProductById(String id);
}
