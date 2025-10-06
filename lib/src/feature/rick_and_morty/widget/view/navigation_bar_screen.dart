import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/characters_screen.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorites_screen.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => NavigationBarScreenState();
}

class NavigationBarScreenState extends State<NavigationBarScreen> {
  int currentPageIndex = 0;

  static const double _shadowBlurRadius = 10.0;
  static const double _shadowOffsetY = -2.0;
  static const double _opacityValue = 0.3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkGreen,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightGreen.withValues(alpha: _opacityValue),
              blurRadius: _shadowBlurRadius,
              offset: const Offset(0, _shadowOffsetY),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: AppTheme.lightGreen,
          indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          selectedIndex: currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.person_pin_sharp,
                color: Colors.white70,
              ),
              label: 'Characters',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.favorite_border,
                color: Colors.white70,
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
      body: <Widget>[
        const CharactersScreen(),
        const FavoritesScreen(),
      ][currentPageIndex],
    );
  }
}
