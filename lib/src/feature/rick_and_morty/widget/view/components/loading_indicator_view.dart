import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

/// {@template loading_indicator_view}
/// LoadingIndicatorView widget for pagination loading.
/// {@endtemplate}
class LoadingIndicatorView extends StatelessWidget {
  /// {@macro loading_indicator_view}
  const LoadingIndicatorView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.lightGreen),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading more characters...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightGreen,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
