import 'package:dio/dio.dart';
import 'package:tarkov_mobile/src/core/network/exceptions/network_exceptions.dart';

/// Фабрика для создания сетевых исключений из DioException
class NetworkExceptionFactory {
  const NetworkExceptionFactory._();

  /// Создает соответствующее исключение на основе DioException
  static NetworkException fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException(
          message: _getTimeoutMessage(exception.type),
          statusCode: exception.response?.statusCode,
          cause: exception,
          requestOptions: exception.requestOptions,
          responseData: exception.response?.data,
        );

      case DioExceptionType.connectionError:
        return ConnectionException(
          message: 'Ошибка подключения к серверу',
          statusCode: exception.response?.statusCode,
          cause: exception,
          requestOptions: exception.requestOptions,
          responseData: exception.response?.data,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);

      case DioExceptionType.cancel:
        return ConnectionException(
          message: 'Запрос был отменен',
          statusCode: exception.response?.statusCode,
          cause: exception,
          requestOptions: exception.requestOptions,
          responseData: exception.response?.data,
        );

      case DioExceptionType.badCertificate:
        return ConnectionException(
          message: 'Ошибка SSL сертификата',
          statusCode: exception.response?.statusCode,
          cause: exception,
          requestOptions: exception.requestOptions,
          responseData: exception.response?.data,
        );

      case DioExceptionType.unknown:
        return UnknownNetworkException(
          message: exception.message ?? 'Неизвестная ошибка сети',
          statusCode: exception.response?.statusCode,
          cause: exception,
          requestOptions: exception.requestOptions,
          responseData: exception.response?.data,
        );
    }
  }

  /// Обрабатывает ошибки с ответом сервера
  static NetworkException _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    // Обработка ошибок аутентификации
    if (statusCode == 401 || statusCode == 403) {
      return AuthenticationException(
        message: _extractErrorMessage(data) ?? 'Ошибка аутентификации',
        statusCode: statusCode,
        cause: exception,
        requestOptions: exception.requestOptions,
        responseData: data,
      );
    }

    // Обработка ошибок валидации
    if (statusCode == 400 || statusCode == 422) {
      final validationErrors = _extractValidationErrors(data);
      return ValidationException(
        message: _extractErrorMessage(data) ?? 'Ошибка валидации данных',
        statusCode: statusCode,
        cause: exception,
        requestOptions: exception.requestOptions,
        validationErrors: validationErrors,
        responseData: data,
      );
    }

    // Ошибки сервера
    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: _extractErrorMessage(data) ?? 'Внутренняя ошибка сервера',
        statusCode: statusCode,
        cause: exception,
        requestOptions: exception.requestOptions,
        responseData: data,
      );
    }

    // Ошибки клиента
    if (statusCode != null && statusCode >= 400) {
      return ClientException(
        message: _extractErrorMessage(data) ?? 'Ошибка запроса',
        statusCode: statusCode,
        cause: exception,
        requestOptions: exception.requestOptions,
        responseData: data,
      );
    }

    // Неизвестная ошибка с ответом
    return UnknownNetworkException(
      message: _extractErrorMessage(data) ?? 'Неизвестная ошибка',
      statusCode: statusCode,
      cause: exception,
      requestOptions: exception.requestOptions,
      responseData: data,
    );
  }

  /// Извлекает сообщение об ошибке из ответа сервера
  /// Возвращает null если не удалось извлечь сообщение (например, HTML код)
  /// В этом случае будут использованы кастомные сообщения об ошибках
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    // Проверяем, что это не HTML код
    if (data is String) {
      // Если это строка, проверяем, не HTML ли это
      if (data.contains('<html') ||
          data.contains('<!DOCTYPE') ||
          data.contains('<body')) {
        return null; // Не извлекаем сообщения из HTML
      }
      // Если это обычная строка (не HTML), возвращаем её
      if (data.isNotEmpty) return data;
      return null;
    }

    // Обрабатываем только Map (JSON объекты)
    if (data is Map<String, dynamic>) {
      // 1. Стандартный формат ошибки - поле 'message'
      if (data.containsKey('message')) {
        return data['message']?.toString();
      }

      // 2. Поле 'detail' (часто используется в DRF и других фреймворках)
      if (data.containsKey('detail')) {
        return data['detail']?.toString();
      }

      // 3. Поле 'error' - может быть строкой или объектом
      if (data.containsKey('error')) {
        final error = data['error'];
        if (error is String) return error;

        // Если error - это объект с полем message
        if (error is Map<String, dynamic> && error.containsKey('message')) {
          return error['message']?.toString();
        }

        // Если error - это объект с полем detail
        if (error is Map<String, dynamic> && error.containsKey('detail')) {
          return error['detail']?.toString();
        }

        // Если error - это объект, но не знаем структуру, возвращаем как строку
        if (error is Map<String, dynamic>) {
          return error.toString();
        }
      }

      // 4. Для ошибок валидации
      if (data.containsKey('errors')) {
        return 'Ошибка валидации данных';
      }
    }

    // Если ничего не удалось извлечь, возвращаем null
    // Это приведет к использованию кастомных сообщений об ошибках
    return null;
  }

  /// Извлекает ошибки валидации из ответа сервера
  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return null;

    final errors = data['errors'];
    if (errors is! Map<String, dynamic>) return null;

    final result = <String, List<String>>{};
    errors.forEach((key, value) {
      if (value is List) {
        result[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        result[key] = [value];
      }
    });

    return result.isEmpty ? null : result;
  }

  /// Получает сообщение для ошибок таймаута
  static String _getTimeoutMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Превышено время ожидания подключения';
      case DioExceptionType.receiveTimeout:
        return 'Превышено время ожидания ответа';
      case DioExceptionType.sendTimeout:
        return 'Превышено время отправки данных';
      default:
        return 'Превышено время ожидания';
    }
  }
}
