import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

/// {@template error_view}
/// ErrorView widget for displaying error states.
/// {@endtemplate}
class ErrorView extends StatelessWidget {
  /// {@macro error_view}
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.lightGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading characters',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightGreen,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
