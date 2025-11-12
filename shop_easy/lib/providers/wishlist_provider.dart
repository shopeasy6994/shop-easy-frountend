import 'package:flutter/material.dart';
import 'package:shop_easyy/models/product.dart';

class WishlistProvider with ChangeNotifier {
  // final ApiService _apiService = ApiService();
  final List<Product> _wishlistItems = [];
  final Set<String> _loadingIds = {}; // To track loading state per item

  List<Product> get wishlistItems => _wishlistItems;

  bool isLoadingFor(String productId) => _loadingIds.contains(productId);

  Future<void> toggleWishlist(Product product) async {
    final isExisting = _wishlistItems.any((item) => item.id == product.id);
    _loadingIds.add(product.id);
    notifyListeners();

    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 300));

    if (isExisting) {
      _wishlistItems.removeWhere((item) => item.id == product.id);
      // await _apiService.removeFromWishlist(product.id);
    } else {
      _wishlistItems.add(product);
      // await _apiService.addToWishlist(product.id);
    }

    _loadingIds.remove(product.id);
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }
}
