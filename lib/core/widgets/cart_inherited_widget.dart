import 'package:flutter/material.dart';
import 'package:pocket_fm/features/cart/domain/entity/cart_entity.dart';

class CartInheritedWidget extends InheritedWidget {
  final List<CartEntity> cartItems;
  final Function(String productId) getCartQuantity;

  const CartInheritedWidget({
    super.key,
    required this.cartItems,
    required this.getCartQuantity,
    required super.child,
  });

  static CartInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartInheritedWidget>();
  }

  @override
  bool updateShouldNotify(CartInheritedWidget oldWidget) {
    return cartItems != oldWidget.cartItems;
  }
} 
