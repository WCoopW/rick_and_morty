import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

/// {@template characters_screen}
/// LoadingView widget.
/// {@endtemplate}
class LoadingView extends StatelessWidget {
  /// {@macro characters_screen}
  const LoadingView({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading characters...',
            style: TextStyle(
              color: AppTheme.lightGreen,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
