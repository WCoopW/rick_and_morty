import 'package:dio/dio.dart';

/// Base class for all network exceptions
abstract class NetworkException implements Exception {
  const NetworkException({
    required this.message,
    this.statusCode,
    this.cause,
    this.requestOptions,
    this.responseData,
  });

  final String message;

  final int? statusCode;

  final Object? cause;

  final RequestOptions? requestOptions;

  final dynamic responseData;

  @override
  String toString() => 'NetworkException: $message';
}

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

class ValidationException extends NetworkException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.cause,
    super.requestOptions,
    super.responseData,
    this.validationErrors,
  });

  final Map<String, List<String>>? validationErrors;

  @override
  String toString() => 'ValidationException: $message';
}

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
