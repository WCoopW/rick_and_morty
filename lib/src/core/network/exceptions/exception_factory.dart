import 'package:dio/dio.dart';
import 'package:tarkov_mobile/src/core/network/exceptions/network_exceptions.dart';

/// Factory for creating network exceptions from DioException
class NetworkExceptionFactory {
  const NetworkExceptionFactory._();

  /// Creates the corresponding exception based on DioException
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

  static NetworkException _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    // Handling authentication errors
    if (statusCode == 401 || statusCode == 403) {
      return AuthenticationException(
        message: _extractErrorMessage(data) ?? 'Ошибка аутентификации',
        statusCode: statusCode,
        cause: exception,
        requestOptions: exception.requestOptions,
        responseData: data,
      );
    }

    // Handling validation errors
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

    // Server errors
    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: _extractErrorMessage(data) ?? 'Внутренняя ошибка сервера',
        statusCode: statusCode,
        cause: exception,
        requestOptions: exception.requestOptions,
        responseData: data,
      );
    }

    // Client errors
    if (statusCode != null && statusCode >= 400) {
      return ClientException(
        message: _extractErrorMessage(data) ?? 'Ошибка запроса',
        statusCode: statusCode,
        cause: exception,
        requestOptions: exception.requestOptions,
        responseData: data,
      );
    }

    // Unknown error with response
    return UnknownNetworkException(
      message: _extractErrorMessage(data) ?? 'Неизвестная ошибка',
      statusCode: statusCode,
      cause: exception,
      requestOptions: exception.requestOptions,
      responseData: data,
    );
  }

  /// Extracts the error message from the server response
  /// Returns null if the message cannot be extracted (for example, HTML code)
  /// In this case, custom error messages will be used
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      if (data.contains('<html') ||
          data.contains('<!DOCTYPE') ||
          data.contains('<body')) {
        return null; 
      }
      if (data.isNotEmpty) return data;
      return null;
    }

    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message']?.toString();
      }

      if (data.containsKey('detail')) {
        return data['detail']?.toString();
      }

      if (data.containsKey('error')) {
        final error = data['error'];
        if (error is String) return error;

        if (error is Map<String, dynamic> && error.containsKey('message')) {
          return error['message']?.toString();
        }

        if (error is Map<String, dynamic> && error.containsKey('detail')) {
          return error['detail']?.toString();
        }

        if (error is Map<String, dynamic>) {
          return error.toString();
        }
      }

      if (data.containsKey('errors')) {
        return 'Ошибка валидации данных';
      }
    }

    return null;
  }

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
