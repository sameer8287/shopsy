import 'package:flutter/material.dart';
import 'package:pocket_fm/core/uitls/helper_function.dart';
import 'package:pocket_fm/core/widgets/add_to_cart_bottomsheet.dart';
import 'package:pocket_fm/features/products/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final String id;

  const ProductDetails({super.key, required this.id});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    try {
      await context.read<ProductProvider>().getProductById(widget.id);
    } catch (e, stackTrace) {
      HelperFunctions.printLog("Error in Product Details", e.toString());
      HelperFunctions.printLog("stacktrace Product Details", stackTrace.toString());
      HelperFunctions.showSnackBar(context, "Failed to load product details");
    }
  }

  @override
  Widget build(BuildContext context) {
    final productDetail = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Visibility(
          visible: productDetail.productDetail == null ? false : true,
          replacement: Center(child: Text("No Data Found")),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  productDetail.productDetail?.media?.thumbnails?[0] ?? '',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Title & Subtitle
              Text(productDetail.productDetail?.title ?? '', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              if (productDetail.productDetail?.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(productDetail.productDetail!.subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              ],
              const SizedBox(height: 12),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 4),
                  Text(productDetail.productDetail?.rating?.toStringAsFixed(1) ?? "N/A", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 16),

              // Price
              if (productDetail.productDetail?.price != null) ...[
                Text(
                  "${productDetail.productDetail?.currency ?? '₹'} ${productDetail.productDetail?.price!.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
              ],

              // Genre
              if (productDetail.productDetail?.genre != null && productDetail.productDetail!.genre!.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  children: productDetail.productDetail!.genre!.map((g) => Chip(label: Text(g), backgroundColor: Colors.blue.shade50)).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Description
              Text("Description", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(productDetail.productDetail?.description ?? "No description available.", style: Theme.of(context).textTheme.bodyMedium),

              const SizedBox(height: 24),

              // Buy Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Add to cart"),
                  onPressed: () {
                    if (productDetail.productDetail == null) return;
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                      builder: (context) {

                        return AddToCartBottomsheet(productEntity: productDetail.productDetail!);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
