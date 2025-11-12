import 'package:flutter/material.dart';
// import 'package:shop_easyy/api/api_service.dart'; // Comment out until used
import 'package:shop_easyy/models/order.dart';
// import 'package:shop_easyy/models/cart_item.dart'; // Comment out until used
import 'package:shop_easyy/models/address.dart';
import 'package:shop_easyy/providers/auth_provider.dart';
import 'package:shop_easyy/providers/cart_provider.dart';

class OrderProvider with ChangeNotifier {
  // final ApiService _apiService = ApiService(); // Comment out until used
  final AuthProvider? _authProvider;
  final List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  OrderProvider(this._authProvider);

  List<Order> get orders => [..._orders];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    if (_authProvider?.token == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      // TODO: Implement fetchOrders in ApiService
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> placeOrder({
    required CartProvider cartProvider,
    required Address address,
  }) async {
    if (_authProvider?.token == null || cartProvider.items.isEmpty) {
      _errorMessage = "User not logged in or cart is empty.";
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // These will be used when the API call is implemented
      // final List<CartItem> cartItems = cartProvider.items.values.toList();
      // final double totalAmount = cartProvider.totalAmount;

      // TODO: Replace with a real API call
      // final newOrder = await _apiService.createOrder(cartItems, totalAmount, address);
      // _orders.insert(0, newOrder);

      await Future.delayed(const Duration(seconds: 2));

      cartProvider.clear();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
