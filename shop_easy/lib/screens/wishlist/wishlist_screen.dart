import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/models/product.dart';
import 'package:shop_easyy/providers/home_provider.dart';
import 'package:shop_easyy/providers/wishlist_provider.dart';
import 'package:shop_easyy/widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        // No back button is needed here as it's part of the main navigation stack
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<WishlistProvider, HomeProvider>(
        builder: (context, wishlist, home, child) {
          // If the main product list is still loading, show a spinner.
          if (home.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter the full product list to get only the wishlisted items.
          final List<Product> wishlistProducts = home.recommended
              .where((product) => wishlist.isFavorite(product.id))
              .toList();

          if (wishlistProducts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Your wishlist is empty.\nTap the heart icon on products to save them for later!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            );
          }

          // Display the wishlisted items in a grid.
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65, // Consistent with HomeScreen
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: wishlistProducts.length,
            itemBuilder: (ctx, i) => ProductCard(product: wishlistProducts[i]),
          );
        },
      ),
    );
  }
}
