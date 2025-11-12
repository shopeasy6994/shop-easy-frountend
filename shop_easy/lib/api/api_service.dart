import 'package:dio/dio.dart';
import 'package:shop_easyy/api/api_client.dart';
import 'package:shop_easyy/models/paginated_response.dart';
import 'package:shop_easyy/models/product.dart';
import 'package:shop_easyy/models/user.dart';
import 'package:shop_easyy/models/address.dart';

class ApiService {
  final Dio _dio = ApiClient().dio;

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio
          .post('/auth/login', data: {'email': email, 'password': password});
      if (response.data != null &&
          response.data['token'] != null &&
          response.data['user'] != null) {
        ApiClient().setAuthToken(response.data['token']);
        return User.fromJson(response.data['user']);
      } else {
        throw Exception('Invalid response format from server.');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error'] ?? e.message ?? 'A network error occurred';
      throw Exception('Failed to login: $errorMessage');
    } catch (e) {
      throw Exception(
          'Failed to login: An unknown error occurred. ${e.toString()}');
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register',
          data: {'name': name, 'email': email, 'password': password});
      if (response.data != null &&
          response.data['token'] != null &&
          response.data['user'] != null) {
        ApiClient().setAuthToken(response.data['token']);
        return User.fromJson(response.data['user']);
      } else {
        throw Exception('Invalid response format from server.');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error'] ?? e.message ?? 'A network error occurred';
      throw Exception('Failed to register: $errorMessage');
    } catch (e) {
      throw Exception(
          'Failed to register: An unknown error occurred. ${e.toString()}');
    }
  }

  Future<PaginatedResponse<Product>> fetchProducts(
      {int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {'page': page, 'limit': limit},
      );
      return PaginatedResponse.fromJson(
          response.data, (json) => Product.fromJson(json));
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error'] ?? e.message ?? 'A network error occurred';
      throw Exception('Failed to fetch products: $errorMessage');
    } catch (e) {
      throw Exception(
          'Failed to fetch products: An unknown error occurred. ${e.toString()}');
    }
  }

  // --- ADD THE MISSING METHOD HERE ---
  Future<Product> fetchProductById(String productId) async {
    try {
      final response = await _dio.get('/products/$productId');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error'] ?? e.message ?? 'A network error occurred';
      throw Exception('Failed to fetch product: $errorMessage');
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while fetching the product.');
    }
  }
}

Future<List<Address>> fetchAddresses() async {
  // final response = await _dio.get('/addresses');
  // return (response.data as List).map((addr) => Address.fromJson(addr)).toList();
  await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
  return []; // Return empty list for now
}

Future<Address> addAddress(Address address) async {
  // final response = await _dio.post('/addresses', data: address.toJson());
  // return Address.fromJson(response.data);
  await Future.delayed(const Duration(milliseconds: 500));
  return address; // Return the same address back
}

Future<Address> updateAddress(Address address) async {
  // final response = await _dio.put('/addresses/${address.id}', data: address.toJson());
  // return Address.fromJson(response.data);
  await Future.delayed(const Duration(milliseconds: 500));
  return address;
}

Future<void> deleteAddress(String addressId) async {
  // await _dio.delete('/addresses/$addressId');
  await Future.delayed(const Duration(milliseconds: 500));
}
