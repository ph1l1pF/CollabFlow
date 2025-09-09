import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _authAccessTokenKey = 'auth_access_token';
  static const String _authRefreshTokenKey = 'auth_refresh_token';
  static const String _userIdKey = 'user_id';

 Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _authAccessTokenKey, value: token);
  }

   Future<String?> getAuthAccessToken() async {
    return await _storage.read(key: _authAccessTokenKey);
  }

   Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _authRefreshTokenKey, value: token);
  }

   Future<String?> getAuthRefreshToken() async {
    return await _storage.read(key: _authRefreshTokenKey);
  }

   Future<void> storeUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

   Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

   Future<bool> isAuthenticated() async {
    final token = await getAuthAccessToken();
    return token != null && token.isNotEmpty;
  }

   Future<void> clearAuthData() async {
    await _storage.delete(key: _authAccessTokenKey);
    await _storage.delete(key: _authRefreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }

   Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
