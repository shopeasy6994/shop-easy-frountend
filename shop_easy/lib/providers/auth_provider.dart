import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_easyy/api/api_service.dart';
import 'package:shop_easyy/models/user.dart';
import 'package:shop_easyy/models/address.dart';
import 'package:shop_easyy/api/api_client.dart';
import 'package:shop_easyy/services/secure_storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storageService = SecureStorageService();

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;
  bool get isAuth => isAuthenticated;

  AuthProvider() {
    tryAutoLogin();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    String? token = await _storageService.read('token');
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('token')) {
        token = prefs.getString('token');
        if (token != null) {
          await _storageService.write('token', token);
          await prefs.remove('token');
        }
      }
    }
    _token = token;
    if (_token == null) return false;

    _apiClient.setAuthToken(_token);
    // You might fetch user profile here upon successful auto-login
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final responseUser = await _apiService.login(email, password);
      _user = responseUser;
      final tempToken = _apiClient.dio.options.headers['Authorization']
          ?.toString()
          .replaceFirst('Bearer ', '');
      if (tempToken != null) {
        _token = tempToken;
        await _storageService.write('token', _token!);
        _apiClient.setAuthToken(_token);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      _user = await _apiService.register(name, email, password);
      final tempToken = _apiClient.dio.options.headers['Authorization']
          ?.toString()
          .replaceFirst('Bearer ', '');
      if (tempToken != null) {
        _token = tempToken;
        await _storageService.write('token', _token!);
        _apiClient.setAuthToken(_token);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _apiClient.setAuthToken(null);
    await _storageService.delete('token');
    notifyListeners();
  }

  Future<void> updateUserProfile(User updatedUser) async {
    _user = updatedUser;
    notifyListeners();
  }

  // --- ADDRESS MANAGEMENT LOGIC ---

  Future<void> fetchUserAddresses() async {
    if (_user == null) return;
    _setLoading(true);
    try {
      final addresses = await _apiService.fetchAddresses();
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        addresses: addresses,
        rewardCoins: _user!.rewardCoins,
        referralCode: _user!.referralCode,
      );
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
  }

  Future<void> addAddress(Address address) async {
    if (_user == null) return;
    try {
      final newAddress = await _apiService.addAddress(address);
      final updatedAddresses = List<Address>.from(_user!.addresses)
        ..add(newAddress);
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        addresses: updatedAddresses,
        rewardCoins: _user!.rewardCoins,
        referralCode: _user!.referralCode,
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> updateAddress(Address address) async {
    if (_user == null) return;
    try {
      final updatedAddress = await _apiService.updateAddress(address);
      final addressIndex =
          _user!.addresses.indexWhere((a) => a.id == updatedAddress.id);
      if (addressIndex != -1) {
        final updatedAddresses = List<Address>.from(_user!.addresses);
        updatedAddresses[addressIndex] = updatedAddress;
        _user = User(
          id: _user!.id,
          name: _user!.name,
          email: _user!.email,
          addresses: updatedAddresses,
          rewardCoins: _user!.rewardCoins,
          referralCode: _user!.referralCode,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> removeAddress(String addressId) async {
    if (_user == null) return;
    try {
      await _apiService.deleteAddress(addressId);
      final updatedAddresses = List<Address>.from(_user!.addresses)
        ..removeWhere((a) => a.id == addressId);
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        addresses: updatedAddresses,
        rewardCoins: _user!.rewardCoins,
        referralCode: _user!.referralCode,
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
}
