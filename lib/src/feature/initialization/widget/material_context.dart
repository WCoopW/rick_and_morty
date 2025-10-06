import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/core/constant/localization/localization.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/characters_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorites_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/navigation_bar_screen.dart';
import 'package:rick_and_morty/src/feature/settings/widget/settings_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatelessWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();
  static const double _textScaleMin = 0.5;
  static const double _textScaleMax = 2.0;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.settingsOf(context);
    final mediaQueryData = MediaQuery.of(context);

    return MaterialApp(
      theme: settings.appTheme?.lightTheme ?? AppTheme.defaultTheme.lightTheme,
      darkTheme: settings.appTheme?.darkTheme ?? AppTheme.defaultTheme.darkTheme,
      themeMode: settings.appTheme?.themeMode ?? ThemeMode.system,
      locale: settings.locale,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      home: const NavigationBarScreen(),
      builder: (context, child) => MediaQuery(
        key: _globalKey,
        data: mediaQueryData.copyWith(
          textScaler: TextScaler.linear(
            mediaQueryData.textScaler
                .scale(settings.textScale ?? 1)
                .clamp(_textScaleMin, _textScaleMax),
          ),
        ),
        child: FavoritesScope(
          child: CharactersScope(
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
