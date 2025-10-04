import 'package:dio/dio.dart';
import 'package:rick_and_morty/src/core/network/exceptions/network_exceptions.dart';
import 'package:rick_and_morty/src/core/network/utils/error_handler.dart';

abstract class BaseDataSource {
  const BaseDataSource();

  Future<T> handleNetworkRequest<T>({
    required Future<T> Function() request,
    required String context,
    T? defaultValue,
  }) async {
    try {
      return await request();
    } on DioException catch (e) {
      final networkException = NetworkErrorHandler.handleDioException(e);
      NetworkErrorHandler.logError(networkException, context);
      throw networkException;
    } on NetworkException {
      rethrow;
    } on Object catch (e, stackTrace) {
      final networkException = NetworkErrorHandler.handleException(e, stackTrace);
      NetworkErrorHandler.logError(networkException, context);
      throw networkException;
    }
  }

  bool isSuccessfulResponse(Response response) {
    return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
  }

  bool isSuccessfulStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  bool isAlreadyExistsStatusCode(int statusCode) {
    return statusCode == 208;
  }

  bool isCreatedStatusCode(int statusCode) {
    return statusCode == 201;
  }

  bool isOkStatusCode(int statusCode) {
    return statusCode == 200;
  }

  String getUserFriendlyErrorMessage(NetworkException exception) {
    return NetworkErrorHandler.getUserFriendlyMessage(exception);
  }

  bool isCriticalError(NetworkException exception) {
    return NetworkErrorHandler.isCriticalError(exception);
  }

  Future<bool> handlePostRequest({
    required Future<Response> Function() request,
    required String context,
    List<int>? successStatusCodes,
    List<int>? additionalSuccessCodes,
  }) async {
    return handleNetworkRequest<bool>(
      context: context,
      request: () async {
        final response = await request();
        return _validateResponse(response, successStatusCodes, additionalSuccessCodes);
      },
    );
  }

  Future<T> handleGetRequest<T>({
    required Future<Response> Function() request,
    required T Function(dynamic data) parser,
    required String context,
    List<int>? successStatusCodes,
  }) async {
    return handleNetworkRequest<T>(
      context: context,
      request: () async {
        final response = await request();
        _validateResponse(response, successStatusCodes);
        return _parseResponse(response.data, parser, response.statusCode);
      },
    );
  }

  bool _validateResponse(Response response, List<int>? successStatusCodes,
      [List<int>? additionalSuccessCodes]) {
    final statusCode = response.statusCode;
    if (statusCode == null) {
      throw UnknownNetworkException(
        message: 'Получен ответ без статус кода',
        statusCode: statusCode,
      );
    }

    final allSuccessCodes = [
      ...(successStatusCodes ?? [200, 201]),
      ...(additionalSuccessCodes ?? [208]),
    ];

    if (allSuccessCodes.contains(statusCode)) {
      return true;
    }

    throw ClientException(
      message: 'Неожиданный статус код: $statusCode',
      statusCode: statusCode,
    );
  }

  T _parseResponse<T>(
    dynamic data,
    T Function(dynamic data) parser,
    int? statusCode,
  ) {
    try {
      return parser(data);
    } on Object catch (e) {
      throw ParseException(
        message: 'Ошибка парсинга данных: ${e.toString()}',
        statusCode: statusCode,
        cause: e,
      );
    }
  }
}
