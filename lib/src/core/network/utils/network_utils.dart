import 'package:dio/dio.dart';
import 'package:tarkov_mobile/src/core/network/exceptions/exception_factory.dart';
import 'package:tarkov_mobile/src/core/network/exceptions/network_exceptions.dart';

/// Утилиты для работы с сетью
class NetworkUtils {
  const NetworkUtils._();

  /// Безопасно выполняет сетевой запрос с автоматической обработкой ошибок
  static Future<T> safeRequest<T>({
    required Future<T> Function() request,
    T? Function(DioException)? onError,
    T? Function(NetworkException)? onNetworkError,
    T? Function(Object)? onUnknownError,
  }) async {
    try {
      return await request();
    } on DioException catch (e) {
      final networkException = NetworkExceptionFactory.fromDioException(e);

      // Пользовательская обработка DioException
      if (onError != null) {
        final result = onError(e);
        if (result != null) return result;
      }

      // Пользовательская обработка NetworkException
      if (onNetworkError != null) {
        final result = onNetworkError(networkException);
        if (result != null) return result;
      }

      // По умолчанию пробрасываем NetworkException
      throw networkException;
    } on NetworkException {
      rethrow;
    } catch (e) {
      // Пользовательская обработка неизвестных ошибок
      if (onUnknownError != null) {
        final result = onUnknownError(e);
        if (result != null) return result;
      }

      // По умолчанию пробрасываем как UnknownNetworkException
      throw UnknownNetworkException(
        message: 'Неизвестная ошибка: ${e.toString()}',
        cause: e,
      );
    }
  }

  /// Проверяет, является ли ошибка ошибкой сети
  static bool isNetworkError(Object error) {
    return error is NetworkException || error is DioException;
  }

  /// Проверяет, является ли ошибка ошибкой аутентификации
  static bool isAuthenticationError(Object error) {
    if (error is AuthenticationException) return true;
    if (error is DioException) {
      return error.response?.statusCode == 401 ||
          error.response?.statusCode == 403;
    }
    return false;
  }

  /// Проверяет, является ли ошибка ошибкой валидации
  static bool isValidationError(Object error) {
    if (error is ValidationException) return true;
    if (error is DioException) {
      return error.response?.statusCode == 400 ||
          error.response?.statusCode == 422;
    }
    return false;
  }

  /// Проверяет, является ли ошибка ошибкой сервера
  static bool isServerError(Object error) {
    if (error is ServerException) return true;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      return statusCode != null && statusCode >= 500;
    }
    return false;
  }

  /// Проверяет, является ли ошибка ошибкой таймаута
  static bool isTimeoutError(Object error) {
    if (error is TimeoutException) return true;
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout;
    }
    return false;
  }

  /// Получает понятное сообщение об ошибке для пользователя
  static String getUserFriendlyMessage(Object error) {
    if (error is NetworkException) {
      return error.message;
    }

    if (error is DioException) {
      final networkException = NetworkExceptionFactory.fromDioException(error);
      return networkException.message;
    }

    return 'Произошла неизвестная ошибка';
  }

  /// Логирует ошибку с дополнительной информацией
  static void logError(Object error, {String? context}) {
    final contextStr = context != null ? '[$context] ' : '';

    if (error is NetworkException) {
      print('${contextStr}Network Error: ${error.message}');
      if (error.statusCode != null) {
        print('${contextStr}Status Code: ${error.statusCode}');
      }
      if (error.cause != null) {
        print('${contextStr}Cause: ${error.cause}');
      }
    } else if (error is DioException) {
      print('${contextStr}Dio Error: ${error.message}');
      print('${contextStr}Type: ${error.type}');
      if (error.response?.statusCode != null) {
        print('${contextStr}Status Code: ${error.response!.statusCode}');
      }
    } else {
      print('${contextStr}Unknown Error: $error');
    }
  }
}
