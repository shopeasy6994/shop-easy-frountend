import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/home_provider.dart';
import 'package:shop_easyy/screens/products/category_products_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading && homeProvider.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (homeProvider.categories.isEmpty) {
            return const Center(
              child: Text(
                'No categories found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: homeProvider.categories.length,
            itemBuilder: (context, index) {
              final categoryName = homeProvider.categories[index].toString();
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryProductsScreen(categoryName: categoryName),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.shopping_bag_outlined,
                          color: Colors.blue[800], size: 30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categoryName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
