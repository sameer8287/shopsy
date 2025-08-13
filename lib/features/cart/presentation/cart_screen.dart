import 'package:flutter/material.dart';
import 'package:pocket_fm/core/uitls/helper_function.dart';
import 'package:pocket_fm/features/cart/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    initCartData();
  }

  initCartData() async {
    try {
      await context.read<CartProvider>().initCart();
    } catch (e, stacktrace) {
      HelperFunctions.printLog("Error in cart init", e.toString());
      HelperFunctions.printLog("Error in cart StackTrace", stacktrace.toString());
      HelperFunctions.showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.cartItems.isEmpty) return Center(child: Text("No Data Found"));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartProvider.cartItems[index];
              final product = cartItem.product;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product?.media?.thumbnails?[0] ?? "",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 60),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Product details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product?.title ?? "Unknown Product", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("\$${(product?.price ?? 0).toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, color: Colors.green)),
                          ],
                        ),
                      ),

                      // Quantity controls
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () async {
                              if (cartItem.quantity == null) {
                                return;
                              } else if (cartItem.quantity! <= 1 && cartItem.productId != null) {
                                await context.read<CartProvider>().removeItem(cartItem.productId!);
                                return;
                              }

                              final updatedQuantity = cartItem.quantity! - 1;
                              await context.read<CartProvider>().updateItem(cartItem.copyWith(quantity: updatedQuantity));
                            },
                          ),
                          Text(cartItem.quantity.toString(), style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () async {
                              final updatedQuantity = cartItem.quantity! + 1;
                              await context.read<CartProvider>().updateItem(cartItem.copyWith(quantity: updatedQuantity));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: cartProvider.cartItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      // Checkout logic
                    },
                    child: const Text("Checkout"),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
