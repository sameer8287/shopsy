import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_fm/core/router/routes_name.dart';
import 'package:pocket_fm/core/uitls/helper_function.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:pocket_fm/features/products/presentation/widgets/product_card.dart';
import 'package:pocket_fm/features/products/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    try {
      await context.read<ProductProvider>().getProductList();
    } catch (e, stacktrace) {
      HelperFunctions.printLog("Error in product list", e.toString());
      HelperFunctions.printLog("Stack trace", stacktrace.toString());
      HelperFunctions.showSnackBar(context, "Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products List")),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          if (value.productList.isEmpty) return Center(child: Text("No Data Found"));
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              ProductEntity item = value.productList[index];
              return GestureDetector(
                onTap: () => context.goNamed(RoutesName.productDetail, queryParameters: {'id': item.id}),
                child: ProductCard(product: item),
              );
            },
            itemCount: value.productList.length, // Example item count
          );
        },
      ),
    );
  }
}
