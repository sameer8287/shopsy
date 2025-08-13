import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:pocket_fm/features/products/domain/repository/product_repository.dart';

class ProductUseCase {
  final ProductRepository productRepository;

  ProductUseCase(this.productRepository);

  Future<List<ProductEntity>> getProducts() async {
    return await productRepository.getProductsList();
  }

  Future<ProductEntity?> getProductById(String id) async {
    return await productRepository.getProductById(id);
  }
}
