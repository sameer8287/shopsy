import 'package:pocket_fm/features/cart/domain/entity/cart_entity.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';

abstract class CartRepository {
  Future<void> addToCart(String productId, int quantity);

  Future<void> removeFromCart(String productId);

  Future<void> updateCartItemQuantity(CartEntity product);

  Future<List<CartEntity>> getCartItems();
}
