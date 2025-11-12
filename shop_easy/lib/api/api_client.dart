import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  late final String _baseUrl;

  factory ApiClient() {
    return _instance;
  }

  // Static getter for the root URL, useful for images
  static String get rootUrl {
    // Return the base URL without the '/api' part
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    return baseUrl.replaceAll('/api', '');
  }

  ApiClient._internal() {
    _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (_baseUrl.isEmpty) {
      throw Exception("API_BASE_URL not found in .env file");
    }

    final options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  void setAuthToken(String? token) {
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }
}
