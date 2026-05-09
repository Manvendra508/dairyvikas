import 'dart:async';

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/local_datasources/secured_storage_service.dart';
import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:DairyVikas/core/other_services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class DioClient with CommonMixin {
  final authService = AuthService();
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;
  bool _isRefreshing = false;
  final List<Function(String)> _queuedRequests = [];

  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        //   'Content-Type': Headers.formUrlEncodedContentType,
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.headers['skipAuth'] == true) {
            return handler.next(options);
          }
          final accessToken = await SecureStorage().getAccessToken();
          final refreshToken = await SecureStorage().getRefreshToken();

          // If access token exists
          if (accessToken.isNotEmpty) {
            // If access token is expired → refresh it
            if (JwtDecoder.isExpired(accessToken)) {
              if (refreshToken.isNotEmpty) {
                // Call backend to refresh token
                final newToken = await _refreshToken(refreshToken);

                if (newToken != null) {
                  options.headers['Authorization'] = 'Bearer $newToken';
                } else {
                  await authService.logoutVendroRemote(refreshToken, dio);
                  return handler.reject(
                    DioException(
                      requestOptions: options,
                      message: "Unauthorized",
                    ),
                  );
                }
              } else {
                // No refresh token → logout
                await authService.logoutVendroRemote(refreshToken, dio);
                return handler.reject(
                  DioException(
                    requestOptions: options,
                    message: "Unauthorized",
                  ),
                );
              }
            } else {
              // Access token still valid → use it
              options.headers['Authorization'] = 'Bearer $accessToken';
            }
          }

          return handler.next(options);
        },

        onError: (DioException e, handler) async {
          if (e.requestOptions.headers['skipAuth'] == true) {
            // Don’t retry refresh API
            return handler.next(e);
          }
          // Token invalid / expired
          if (e.response?.statusCode == 401) {
            final refreshToken = await SecureStorage().getRefreshToken();

            // If no refresh token → logout immediately
            if (refreshToken.isEmpty) {
              await authService.logoutVendroRemote(refreshToken, dio);
              return handler.next(e);
            }

            // Prevent multiple refresh calls
            if (!_isRefreshing) {
              _isRefreshing = true;

              final newToken = await _refreshToken(refreshToken);

              _isRefreshing = false;

              if (newToken != null) {
                // Retry any queued requests
                for (var callback in _queuedRequests) {
                  callback(newToken);
                }
                _queuedRequests.clear();

                // Retry original request
                e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final retryResponse = await dio.fetch(e.requestOptions);
                return handler.resolve(retryResponse);
              } else {
                await authService.logoutVendroRemote(refreshToken, dio);
                return handler.next(e);
              }
            } else {
              // Queue request until refresh complete
              final response = await _queueRequest(e.requestOptions);
              return handler.resolve(response);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  // Refresh Token Function
  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final tempDio = Dio();
      final newTokens = await authService.refreshAccessToken(
        refreshToken,
        tempDio,
      );
      if (newTokens.isEmpty || newTokens[0].isEmpty) {
        return null;
      }

      final accessToken = newTokens[0]; // ✅ ACCESS TOKEN
      final newRefreshToken = newTokens[1];

      await saveDataSensitiveData(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );

      return accessToken; // ✅ ALWAYS return access token
    } catch (e) {
      return null;
    }
  }

  /// Handle queued requests during refresh
  Future<Response> _queueRequest(RequestOptions requestOptions) async {
    final completer = Completer<Response>();

    _queuedRequests.add((String newToken) async {
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final res = await dio.fetch(requestOptions);
      completer.complete(res);
    });

    return completer.future;
  }
}
