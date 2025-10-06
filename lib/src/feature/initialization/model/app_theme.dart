import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// An immutable class that holds properties needed
/// to build a [ThemeData] for the app.
/// {@endtemplate}
@immutable
final class AppTheme with Diagnosticable {
  /// {@macro app_theme}
  AppTheme({required this.themeMode, required this.seed})
      : darkTheme = _buildRickAndMortyTheme(),
        lightTheme = _buildRickAndMortyTheme();

  /// Rick and Morty цветовая схема (темная тема)
  static const Color rickGreen = Color(0xFF00B4D8);
  static const Color mortyYellow = Color(0xFFF7DC6F);
  static const Color darkGreen = Color(0xFF1A5F3F);
  static const Color lightGreen = Color(0xFF2ECC71);
  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF1A1F2E);
  static const Color darkSurfaceVariant = Color(0xFF2A2F3E);

  // Константы для размеров
  static const double _borderRadius = 12.0;
  static const double _buttonBorderRadius = 25.0;
  static const double _cardElevation = 4.0;
  static const double _cardBorderWidth = 1.0;
  static const double _cardBorderRadius = 12.0;
  static const double _cardBorderOpacity = 0.4;
  static const double _shadowOpacity = 0.3;

  /// Создает тему в стиле Rick and Morty (темная)
  static ThemeData _buildRickAndMortyTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: rickGreen,
        brightness: Brightness.dark,
        primary: rickGreen,
        secondary: lightGreen,
        surface: darkSurface,
        background: darkBackground,
        surfaceVariant: darkSurfaceVariant,
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white70,
        error: const Color(0xFFE53E3E),
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkGreen,
        indicatorColor: lightGreen,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        ),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: rickGreen,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(_buttonBorderRadius)),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: _cardElevation,
        shadowColor: lightGreen.withValues(alpha: _shadowOpacity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_cardBorderRadius)),
          side: BorderSide(
            color: lightGreen.withValues(alpha: _cardBorderOpacity),
            width: _cardBorderWidth,
          ),
        ),
      ),
    );
  }

  /// The type of theme to use.
  final ThemeMode themeMode;

  /// The seed color to generate the [ColorScheme] from.
  final Color seed;

  /// The dark [ThemeData] for this [AppTheme].
  final ThemeData darkTheme;

  /// The light [ThemeData] for this [AppTheme].
  final ThemeData lightTheme;

  /// The default [AppTheme].
  static final defaultTheme = AppTheme(
    themeMode: ThemeMode.dark,
    seed: rickGreen,
  );

  /// The [ThemeData] for this [AppTheme].
  /// This is computed based on the [themeMode].
  ThemeData computeTheme() {
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        return PlatformDispatcher.instance.platformBrightness == Brightness.dark
            ? darkTheme
            : lightTheme;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('seed', seed));
    properties.add(EnumProperty<ThemeMode>('type', themeMode));
    properties.add(DiagnosticsProperty<ThemeData>('lightTheme', lightTheme));
    properties.add(DiagnosticsProperty<ThemeData>('darkTheme', darkTheme));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme && seed == other.seed && themeMode == other.themeMode;

  @override
  int get hashCode => Object.hash(seed, themeMode);
}
