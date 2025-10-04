import 'package:dio/dio.dart';
import 'package:rick_and_morty/src/core/network/exceptions/exception_factory.dart';
import 'package:rick_and_morty/src/core/network/exceptions/network_exceptions.dart';

/// Утилита для обработки сетевых ошибок
class NetworkErrorHandler {
  const NetworkErrorHandler._();

  /// Обрабатывает DioException и возвращает соответствующее NetworkException
  static NetworkException handleDioException(DioException exception) {
    return NetworkExceptionFactory.fromDioException(exception);
  }

  /// Обрабатывает любую ошибку и возвращает NetworkException
  static NetworkException handleException(Object exception, [StackTrace? stackTrace]) {
    if (exception is DioException) {
      return handleDioException(exception);
    }

    if (exception is NetworkException) {
      return exception;
    }

    // Для других типов ошибок создаем UnknownNetworkException
    return UnknownNetworkException(
      message: exception.toString(),
      cause: exception,
    );
  }

  /// Проверяет, является ли ошибка критичной для отображения пользователю
  static bool isCriticalError(NetworkException exception) {
    return exception is! ValidationException && exception is! AuthenticationException;
  }

  /// Получает пользовательское сообщение об ошибке
  static String getUserFriendlyMessage(NetworkException exception) {
    // Сначала пытаемся извлечь детальное сообщение из данных ответа
    if (exception.responseData != null) {
      final detailedMessage = _extractDetailedMessage(exception.responseData);
      if (detailedMessage != null && detailedMessage.isNotEmpty) {
        return detailedMessage;
      }
    }

    // Если детального сообщения не удалось извлечь (например, HTML код или непонятный формат),
    // возвращаем наши кастомные сообщения об ошибках
    switch (exception.runtimeType) {
      case ConnectionException:
        return 'Ошибка подключения к серверу. Проверьте интернет-соединение.';
      case TimeoutException:
        return 'Превышено время ожидания ответа от сервера.';
      case ServerException:
        return 'Ошибка на стороне сервера. Попробуйте позже.';
      case AuthenticationException:
        return 'Ошибка аутентификации. Проверьте ваши данные.';
      case ValidationException:
        return exception.message;
      case ClientException:
        return 'Ошибка в запросе. Проверьте введенные данные.';
      case ParseException:
        return 'Ошибка обработки ответа сервера.';
      default:
        return 'Произошла неизвестная ошибка. Попробуйте еще раз.';
    }
  }

  /// Извлекает детальное сообщение об ошибке из данных ответа сервера
  /// Возвращает null если не удалось извлечь сообщение (например, HTML код)
  /// В этом случае будут использованы кастомные сообщения об ошибках
  static String? _extractDetailedMessage(dynamic data) {
    if (data == null) return null;

    // Проверяем, что это не HTML код
    if (data is String) {
      // Если это строка, проверяем, не HTML ли это
      if (data.contains('<html') || data.contains('<!DOCTYPE') || data.contains('<body')) {
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
        final message = data['message']?.toString();
        if (message != null && message.isNotEmpty) return message;
      }

      // 2. Поле 'detail' (часто используется в DRF и других фреймворках)
      if (data.containsKey('detail')) {
        final detail = data['detail']?.toString();
        if (detail != null && detail.isNotEmpty) return detail;
      }

      // 3. Поле 'error' - может быть строкой или объектом
      if (data.containsKey('error')) {
        final error = data['error'];
        if (error is String && error.isNotEmpty) return error;

        // Если error - это объект с полем message
        if (error is Map<String, dynamic> && error.containsKey('message')) {
          final message = error['message']?.toString();
          if (message != null && message.isNotEmpty) return message;
        }

        // Если error - это объект с полем detail
        if (error is Map<String, dynamic> && error.containsKey('detail')) {
          final detail = error['detail']?.toString();
          if (detail != null && detail.isNotEmpty) return detail;
        }

        // Если error - это объект, но не знаем структуру, возвращаем как строку
        if (error is Map<String, dynamic>) {
          return error.toString();
        }
      }
    }

    // Если ничего не удалось извлечь, возвращаем null
    // Это приведет к использованию кастомных сообщений об ошибках
    return null;
  }

  /// Логирует ошибку для отладки
  static void logError(NetworkException exception, [String? context]) {
    final contextInfo = context != null ? '[$context] ' : '';
    print('$contextInfo${exception.toString()}');

    if (exception.cause != null) {
      print('Причина: ${exception.cause}');
    }

    if (exception.requestOptions != null) {
      print('URL: ${exception.requestOptions!.uri}');
      print('Метод: ${exception.requestOptions!.method}');
    }

    // Логируем данные ответа сервера для лучшей отладки
    if (exception.responseData != null) {
      print('Тип данных ответа: ${exception.responseData.runtimeType}');
      print('Данные ответа: ${exception.responseData}');
    }
  }
}
