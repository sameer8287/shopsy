import 'package:pocket_fm/features/cart/domain/entity/cart_entity.dart';
import 'package:pocket_fm/features/cart/domain/repository/cart_repository.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';

class CartUseCase {
  final CartRepository _cartRepository;

  CartUseCase(this._cartRepository);

  Future<List<CartEntity>> getAllCartItems() async {
    return await _cartRepository.getCartItems();
  }

  Future<void> removeItem(String productId) async {
    return await _cartRepository.removeFromCart(productId);
  }

  Future<void> update(CartEntity item) async {
    await _cartRepository.updateCartItemQuantity(item);
  }
}
