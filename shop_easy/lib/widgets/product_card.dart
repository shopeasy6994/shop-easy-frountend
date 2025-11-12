import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // IMPORT THIS
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shop_easyy/models/product.dart';
import 'package:shop_easyy/providers/cart_provider.dart';
import 'package:shop_easyy/api/api_client.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final int cacheSize =
        (150 * MediaQuery.of(context).devicePixelRatio).round();
    final imageUrl = product.imageUrl.startsWith('http')
        ? product.imageUrl
        : '${ApiClient.rootUrl}/${product.imageUrl}';

    return GestureDetector(
      // WRAP WITH GESTUREDETECTOR
      onTap: () {
        // NAVIGATE TO THE DETAIL PAGE
        context.go('/home/product/${product.id}');
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                // Add a Hero widget for a nice animation
                tag: 'product-image-${product.id}',
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: cacheSize,
                    memCacheHeight: cacheSize,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('₹${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green)),
                  if (product.discountPercentage > 0)
                    Text(
                      'MRP: ₹${product.mrp.toStringAsFixed(2)}',
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12),
                    ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Consumer<CartProvider>(
                builder: (ctx, cart, _) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    cart.addItem(product);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Added to cart!'),
                          duration: Duration(seconds: 1)),
                    );
                  },
                  child:
                      const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
