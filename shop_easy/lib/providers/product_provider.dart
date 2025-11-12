import 'package:flutter/material.dart';
import 'package:shop_easyy/api/api_service.dart';
import 'package:shop_easyy/models/product.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // --- STATE FOR PRODUCT LIST (PAGINATION) ---
  List<Product> _products = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  String? _listErrorMessage;

  // --- STATE FOR PRODUCT DETAIL VIEW ---
  Product? _selectedProduct;
  bool _isDetailLoading = false;
  String? _detailErrorMessage;

  // --- GETTERS FOR LIST VIEW ---
  List<Product> get products => _products;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  bool get isLoadMoreRunning => _isLoadMoreRunning;
  String? get listErrorMessage => _listErrorMessage; // Corrected getter name

  // --- GETTERS FOR DETAIL VIEW ---
  Product? get selectedProduct => _selectedProduct;
  bool get isDetailLoading => _isDetailLoading;
  String? get detailErrorMessage => _detailErrorMessage;

  // --- METHODS ---

  Future<void> fetchFirstPage() async {
    _isFirstLoadRunning = true;
    _listErrorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchProducts(page: 1);
      _products = response.data;
      _currentPage = response.page;
      _hasNextPage = response.hasNextPage;
    } catch (e) {
      _listErrorMessage = e.toString();
    } finally {
      _isFirstLoadRunning = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (_isLoadMoreRunning || !_hasNextPage) return;

    _isLoadMoreRunning = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchProducts(page: _currentPage + 1);
      _products.addAll(response.data);
      _currentPage = response.page;
      _hasNextPage = response.hasNextPage;
    } catch (e) {
      _listErrorMessage = e.toString();
    } finally {
      _isLoadMoreRunning = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductById(String productId) async {
    _isDetailLoading = true;
    _selectedProduct = null;
    _detailErrorMessage = null;
    notifyListeners();

    try {
      _selectedProduct = await _apiService.fetchProductById(productId);
    } catch (e) {
      _detailErrorMessage = e.toString();
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }
}
