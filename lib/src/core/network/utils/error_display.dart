import 'package:flutter/material.dart';
import 'package:tarkov_mobile/src/core/network/exceptions/network_exceptions.dart';
import 'package:tarkov_mobile/src/core/network/utils/error_handler.dart';

/// Утилита для отображения сетевых ошибок в UI
class NetworkErrorDisplay {
  const NetworkErrorDisplay._();

  /// Показывает ошибку в snackbar с автоматическим определением типа
  static void showErrorSnackBar(
    BuildContext context,
    NetworkException exception, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final message = NetworkErrorHandler.getUserFriendlyMessage(exception);
    final backgroundColor = _getErrorColor(exception);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Показывает ошибку в snackbar по сообщению
  static void showErrorSnackBarByMessage(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor ?? Colors.red[600],
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Показывает предупреждение в snackbar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[600],
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Показывает успешное сообщение в snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Получает цвет для типа ошибки
  static Color _getErrorColor(NetworkException exception) {
    switch (exception.runtimeType) {
      case ConnectionException:
      case TimeoutException:
        return Colors.orange[600]!;
      case ServerException:
        return Colors.red[700]!;
      case AuthenticationException:
        return Colors.red[600]!;
      case ValidationException:
        return Colors.orange[600]!;
      case ClientException:
        return Colors.red[600]!;
      case ParseException:
        return Colors.purple[600]!;
      default:
        return Colors.red[600]!;
    }
  }

  /// Показывает диалог с детальной информацией об ошибке
  static void showErrorDialog(
    BuildContext context,
    NetworkException exception, {
    String? title,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    final message = NetworkErrorHandler.getUserFriendlyMessage(exception);
    final isCritical = NetworkErrorHandler.isCriticalError(exception);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Ошибка'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (isCritical) ...[
              const SizedBox(height: 8),
              Text(
                'Это критическая ошибка. Попробуйте позже.',
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 12,
                ),
              ),
            ],
            if (exception.statusCode != null) ...[
              const SizedBox(height: 8),
              Text(
                'Код ошибки: ${exception.statusCode}',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (onDismiss != null)
            TextButton(
              onPressed: onDismiss,
              child: const Text('Закрыть'),
            ),
          if (onRetry != null && !isCritical)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
        ],
      ),
    );
  }
}
