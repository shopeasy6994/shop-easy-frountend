import 'package:flutter/material.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Logic to fetch products for this category should be added to ProductProvider
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: const Center(
        child: Text('Displaying products for the selected category.'),
      ),
    );
  }
}
