import 'dart:io';

import 'package:dio/dio.dart';

class AppExceptionHandler {
  static String handleError(dynamic error) {
    // DIO EXCEPTIONS
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout! Please try again.";

        case DioExceptionType.sendTimeout:
          return "Request timed out while sending data.";

        case DioExceptionType.receiveTimeout:
          return "Server is taking too long to respond.";

        case DioExceptionType.badResponse:
          return _handleStatusCode(
            error.response?.statusCode,
            error.response?.data,
          );

        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return "No Internet Connection!";
          }
          return "Unexpected network error occurred.";

        default:
          return "Something went wrong.";
      }
    }

    // Socket exception (no internet)
    if (error is SocketException) {
      return "No Internet Connection!";
    }

    // Any other unknown error
    return "Unexpected error occurred!";
  }

  // HANDLE HTTP STATUS CODES
  static String _handleStatusCode(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return data["message"] ?? "Bad Request!";
      case 401:
        return data["message"] ?? "Unauthorized! Please login again.";
      case 403:
        return data["message"] ?? "You don’t have permission.";
      case 404:
        return data["message"] ?? "Requested resource not found.";
      case 409:
        return "Conflict! Duplicate request.";
      case 500:
        return "Server error! Please try again later.";
      default:
        return data["message"] ?? "Oops! Something went wrong.";
    }
  }
}
