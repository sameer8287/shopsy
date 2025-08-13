import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_fm/core/router/routes_name.dart';
import 'package:pocket_fm/features/cart/provider/cart_provider.dart';
import 'package:pocket_fm/features/landing/provider/landing_provider.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  final Widget child;

  const LandingScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff5340E8),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Products'),
          BottomNavigationBarItem(
            icon: Visibility(
              visible: context.watch<CartProvider>().cartItems.isNotEmpty ? true : false,
              replacement: Icon(Icons.shopping_cart),
              child: Badge(label: Text(context.watch<CartProvider>().totalQuantity.toString()), child: const Icon(Icons.shopping_cart_outlined)),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Profile'),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: context.watch<LandingProvider>().currentIndex,
        // Set the current index based on your logic
        onTap: (index) {
          if (index == 0) {
            context.go(RoutesName.product);
          } else if (index == 1) {
            context.go(RoutesName.cart);
          } else if (index == 2) {
            context.go(RoutesName.profile);
          }
          context.read<LandingProvider>().currentIndex = index; // Assuming you have a LandingProvider to manage state
        },
      ),
    );
  }
}
