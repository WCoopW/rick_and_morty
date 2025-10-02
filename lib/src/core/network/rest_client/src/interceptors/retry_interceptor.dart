import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    var retries = err.requestOptions.extra['retries'] ?? 0;

    final shouldRetry = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError;

    if (shouldRetry && retries < maxRetries) {
      await Future.delayed(retryDelay);
      final newOptions = Options(
        method: err.requestOptions.method,
        headers: err.requestOptions.headers,
        responseType: err.requestOptions.responseType,
        contentType: err.requestOptions.contentType,
        followRedirects: err.requestOptions.followRedirects,
        validateStatus: err.requestOptions.validateStatus,
        receiveDataWhenStatusError:
            err.requestOptions.receiveDataWhenStatusError,
        extra: Map<String, dynamic>.from(err.requestOptions.extra)
          ..['retries'] = retries + 1,
      );
      try {
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: newOptions,
          cancelToken: err.requestOptions.cancelToken,
          onReceiveProgress: err.requestOptions.onReceiveProgress,
          onSendProgress: err.requestOptions.onSendProgress,
        );
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(e as DioException);
      }
    }
    return handler.next(err);
  }
}
