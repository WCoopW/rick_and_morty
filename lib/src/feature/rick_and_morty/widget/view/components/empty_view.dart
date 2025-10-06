import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

/// {@template empty_view}
/// EmptyView widget for displaying empty states.
/// {@endtemplate}
class EmptyView extends StatelessWidget {
  /// {@macro empty_view}
  const EmptyView({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
  });

  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  static const double _opacityValueLight = 0.1;
  static const double _opacityValue = 0.3;
  static const double _paddingValue = 20.0;
  static const double _containerBorderRadius = 20.0;
  static const double _borderWidth = 2.0;
  static const double _iconSize = 80.0;
  static const double _buttonBorderRadius = 25.0;
  static const double _bodyFontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(_paddingValue),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen.withValues(alpha: _opacityValueLight),
              borderRadius: const BorderRadius.all(
                Radius.circular(_containerBorderRadius),
              ),
              border: Border.all(
                color: AppTheme.lightGreen.withValues(alpha: _opacityValue),
                width: _borderWidth,
              ),
            ),
            child: Icon(
              Icons.favorite,
              size: _iconSize,
              color: AppTheme.lightGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _bodyFontSize,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (buttonLabel != null && onButtonPressed != null) ...[
            const SizedBox(height: 32),
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.all(
                  Radius.circular(_buttonBorderRadius),
                ),
              ),
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(_buttonBorderRadius),
                    ),
                  ),
                ),
                child: Text(
                  buttonLabel ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
