import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._privateConstructor();

  static SecureStorage get instance => _instance;
  SecureStorage._privateConstructor();
  factory SecureStorage() {
    return _instance;
  }
  late FlutterSecureStorage _flutterSecureStorage;

  Future<void> init() async {
    _flutterSecureStorage = FlutterSecureStorage();
  }

  Future removeUserId() async {
    return await _flutterSecureStorage.delete(key: 'user_id');
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _flutterSecureStorage.write(key: 'access_token', value: accessToken);
  }

  Future<String> getAccessToken() async {
    return await _flutterSecureStorage.read(key: 'access_token') ?? '';
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _flutterSecureStorage.write(
      key: 'refresh_token',
      value: refreshToken,
    );
  }

  Future<String> getRefreshToken() async {
    return await _flutterSecureStorage.read(key: 'refresh_token') ?? '';
  }

  Future<void> saveVendorLoginStatus(String value) async {
    await _flutterSecureStorage.write(key: 'login_status', value: value);
  }

  Future<String> getVendorLoginStatus() async {
    return await _flutterSecureStorage.read(key: 'login_status') ?? 'false';
  }

  Future<void> delete(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }

  Future<void> saveVendorDeviceid(String value) async {
    await _flutterSecureStorage.write(key: 'device_id', value: value);
  }

  Future<String?> getVendorDeviceid() async {
    return await _flutterSecureStorage.read(key: 'device_id');
  }

  Future<void> saveVendorUserAgent(String value) async {
    await _flutterSecureStorage.write(key: 'user_agent', value: value);
  }

  Future<String?> getVendorUserAgent() async {
    return await _flutterSecureStorage.read(key: 'user_agent');
  }

  Future<void> deleteAllExcept() async {
    // Step 1: Read value of key you want to keep
    final deviceId = await _flutterSecureStorage.read(key: 'device_id');
    final userAgent = await _flutterSecureStorage.read(key: 'user_agent');

    // Step 2: Delete everything
    await _flutterSecureStorage.deleteAll();

    // Step 3: Restore only the one key
    if (deviceId != null && userAgent != null) {
      await _flutterSecureStorage.write(key: 'device_id', value: deviceId);
      await _flutterSecureStorage.write(key: 'user_agent', value: userAgent);
    }
  }
}
