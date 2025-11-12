import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/product_provider.dart';
import 'package:shop_easyy/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (productProvider.products.isEmpty) {
      productProvider.fetchFirstPage();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productProvider.fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SHOP EASY')),
      body: Consumer<ProductProvider>(
        builder: (ctx, provider, _) {
          if (provider.isFirstLoadRunning) {
            return const Center(child: CircularProgressIndicator());
          }
          // CORRECTED: Use listErrorMessage here
          if (provider.listErrorMessage != null && provider.products.isEmpty) {
            return Center(
                child: Text('An error occurred: ${provider.listErrorMessage}'));
          }
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount:
                provider.products.length + (provider.isLoadMoreRunning ? 1 : 0),
            itemBuilder: (ctx, i) {
              if (i < provider.products.length) {
                return ProductCard(product: provider.products[i]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}
