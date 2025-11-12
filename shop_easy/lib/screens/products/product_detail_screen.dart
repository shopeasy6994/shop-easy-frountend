import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shop_easyy/api/api_client.dart';
import 'package:shop_easyy/providers/cart_provider.dart';
import 'package:shop_easyy/providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ProductProvider>(
        builder: (ctx, provider, _) {
          if (provider.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.detailErrorMessage != null) {
            return Center(child: Text('Error: ${provider.detailErrorMessage}'));
          }
          if (provider.selectedProduct == null) {
            return const Center(child: Text('Product not found.'));
          }

          final product = provider.selectedProduct!;
          final imageUrl = product.imageUrl.startsWith('http')
              ? product.imageUrl
              : '${ApiClient.rootUrl}/${product.imageUrl}';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  placeholder: (context, url) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('₹${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24)),
                      if (product.discountPercentage > 0)
                        Text(
                          'MRP: ₹${product.mrp.toStringAsFixed(2)}',
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                        ),
                      const SizedBox(height: 16),
                      Text(product.description),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Added to cart!'),
                                duration: Duration(seconds: 1)),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
