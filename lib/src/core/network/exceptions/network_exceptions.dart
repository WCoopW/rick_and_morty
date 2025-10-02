import 'package:dio/dio.dart';

/// Базовый класс для всех сетевых исключений
abstract class NetworkException implements Exception {
  const NetworkException({
    required this.message,
    this.statusCode,
    this.cause,
    this.requestOptions,
    this.responseData,
  });

  /// Сообщение об ошибке
  final String message;

  /// HTTP статус код (если есть)
  final int? statusCode;

  /// Причина ошибки
  final Object? cause;

  /// Опции запроса Dio
  final RequestOptions? requestOptions;

  /// Данные ответа сервера (если есть)
  final dynamic responseData;

  @override
  String toString() => 'NetworkException: $message';
}

/// Ошибка подключения к сети
class ConnectionException extends NetworkException {
  const ConnectionException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
  });

  @override
  String toString() => 'ConnectionException: $message';
}

/// Ошибка таймаута
class TimeoutException extends NetworkException {
  const TimeoutException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
  });

  @override
  String toString() => 'TimeoutException: $message';
}

/// Ошибка сервера (5xx)
class ServerException extends NetworkException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Ошибка клиента (4xx)
class ClientException extends NetworkException {
  const ClientException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
  });

  @override
  String toString() => 'ClientException: $message (Status: $statusCode)';
}

/// Ошибка аутентификации (401, 403)
class AuthenticationException extends NetworkException {
  const AuthenticationException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
  });

  @override
  String toString() =>
      'AuthenticationException: $message (Status: $statusCode)';
}

/// Ошибка валидации данных
class ValidationException extends NetworkException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
    this.validationErrors,
  });

  /// Детали ошибок валидации
  final Map<String, List<String>>? validationErrors;

  @override
  String toString() => 'ValidationException: $message';
}

/// Ошибка парсинга ответа
class ParseException extends NetworkException {
  const ParseException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
  });

  @override
  String toString() => 'ParseException: $message';
}

/// Неизвестная ошибка
class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
  });

  @override
  String toString() => 'UnknownNetworkException: $message';
}
