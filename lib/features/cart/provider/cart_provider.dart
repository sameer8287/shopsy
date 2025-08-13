import 'package:flutter/widgets.dart';
import 'package:pocket_fm/features/cart/domain/entity/cart_entity.dart';
import 'package:pocket_fm/features/cart/domain/usecase/cart_usecase.dart';

class CartProvider extends ChangeNotifier {
  final CartUseCase _cartUseCase;

  CartProvider(this._cartUseCase) {
    initCart();
  }

  List<CartEntity> _cartItems = [];

  List<CartEntity> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price ?? 0) * (item.quantity ?? 0));
  }

  int get totalQuantity {
    return _cartItems.fold(0, (qtySum, item) => qtySum + (item.quantity ?? 0));
  }

  initCart() async {
    _cartItems = await _cartUseCase.getAllCartItems();
    notifyListeners();
  }

  Future<void> updateItem(CartEntity item) async {
    await _cartUseCase.update(item);
    await initCart();
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    await _cartUseCase.removeItem(id);
    await initCart();
    notifyListeners();
  }
}
