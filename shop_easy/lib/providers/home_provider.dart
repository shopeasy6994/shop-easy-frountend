import 'package:flutter/material.dart';
import 'package:shop_easyy/api/api_service.dart';
import 'package:shop_easyy/models/product.dart';
import 'package:shop_easyy/models/category.dart';
import 'package:shop_easyy/models/notification.dart';

class HomeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _featuredProducts = [];
  List<Product> _newArrivals = [];
  List<Product> _recommended = [];
  List<Category> _categories = [];
  List<String> _offerImageUrls = [];
  List<AppNotification> _notifications = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get newArrivals => _newArrivals;
  List<Product> get recommended => _recommended;
  List<Category> get categories => _categories;
  List<String> get offerImageUrls => _offerImageUrls;
  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch only the first page for the home screen highlights
      final response = await _apiService.fetchProducts(page: 1, limit: 10);
      final allProducts = response.data; // CORRECTED: Access the data list

      _featuredProducts = allProducts.take(5).toList();
      _newArrivals = allProducts.reversed.take(5).toList();
      _recommended = allProducts.toList();

      _categories = [
        Category(
            id: '1',
            name: 'Electronics',
            imageUrl: 'https://via.placeholder.com/150'),
        Category(
            id: '2',
            name: 'Fashion',
            imageUrl: 'https://via.placeholder.com/150'),
      ];
      _offerImageUrls = [
        "https://via.placeholder.com/400x200.png?text=Offer+1",
        "https://via.placeholder.com/400x200.png?text=Offer+2",
      ];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNotifications() async {
    _notifications = [
      AppNotification(
          id: '1',
          title: 'Welcome!',
          message: 'Thanks for joining.',
          dateTime: DateTime.now(),
          isRead: false),
    ];
    notifyListeners();
  }

  void clearNotifications() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }
}
