import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_fm/core/uitls/helper_function.dart';
import 'package:pocket_fm/core/widgets/cart_inherited_widget.dart';
import 'package:pocket_fm/data/local/db_helper.dart';
import 'package:pocket_fm/features/cart/data/local/schema/cart_schema.dart';
import 'package:pocket_fm/features/cart/domain/entity/cart_entity.dart';
import 'package:pocket_fm/features/cart/provider/cart_provider.dart';
import 'package:pocket_fm/features/products/data/model/product_model.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class AddToCartBottomsheet extends StatelessWidget {
  final ProductEntity productEntity;

  const AddToCartBottomsheet({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    // Get current cart quantity from inherited widget
    final cartInherited = CartInheritedWidget.of(context);
    final int currentQuantity = cartInherited?.getCartQuantity(productEntity.id ?? "") ?? 0;

    int quantity = currentQuantity > 0 ? currentQuantity : 1; // Use current quantity or default to 1

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productEntity.media?.thumbnails?.first ??
                          "https://plus.unsplash.com/premium_photo-1710409625244-e9ed7e98f67b?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE2fHx8ZW58MHx8fHx8",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product Name & Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productEntity.title ?? "Product Name",
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${productEntity.currency ?? "₹"}${productEntity.price?.toStringAsFixed(2) ?? "299"}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                      IconButton(
                        onPressed: () {
                          setState(() => quantity++);
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await saveDataToCart(productEntity, quantity, context);
                    } catch (e) {
                      HelperFunctions.showSnackBar(context, e.toString());
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> saveDataToCart(ProductEntity productEntity, int quantity, BuildContext context) async {
  await context.read<CartProvider>().updateItem(
    CartEntity(productId: productEntity.id, quantity: quantity, price: productEntity.price ?? 0.0, product: productEntity, updatedAt: DateTime.now()),
  );
}
