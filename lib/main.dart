import 'package:flutter/material.dart';
import 'package:pocket_fm/features/products/data/repository/product_repository_impl.dart';
import 'package:pocket_fm/features/products/provider/product_provider.dart';
import 'package:pocket_fm/features/cart/data/repository/cart_repository_impl.dart';
import 'package:pocket_fm/features/cart/domain/usecase/cart_usecase.dart';
import 'package:pocket_fm/features/cart/provider/cart_provider.dart';
import 'package:pocket_fm/core/widgets/cart_inherited_widget.dart';
import 'package:provider/provider.dart';

import 'core/router/routes.dart';
import 'data/local/db_helper.dart';
import 'features/products/domain/usecase/product_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider(ProductUseCase(ProductRepositoryImpl()))),
        ChangeNotifierProvider(create: (context) => CartProvider(CartUseCase(CartRepositoryImpl()))),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return CartInheritedWidget(
          cartItems: cartProvider.cartItems,
          getCartQuantity: (productId) {
            try {
              final cartItem = cartProvider.cartItems.firstWhere(
                (item) => item.productId == productId,
              );
              return cartItem.quantity ?? 0;
            } catch (e) {
              return 0;
            }
          },
          child: MaterialApp.router(
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xff5340E8),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                iconTheme: IconThemeData(color: Colors.white),
              ),
            ),
            title: 'Shopsy',
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
