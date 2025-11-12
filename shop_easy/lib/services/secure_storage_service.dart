import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Create a singleton instance
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  final FlutterSecureStorage _storage;

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal() : _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
