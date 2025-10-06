import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/empty_view.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/error_view.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/favorites_list.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/status_filter_chips.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorites_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/navigation_bar_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  static const double _heightThreshold = 600.0;

  @override
  Widget build(BuildContext context) {
    final scope = FavoritesScope.of(context, listen: true);
    return Scaffold(
      body: CustomScrollView(
        controller: scope.scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: MediaQuery.sizeOf(context).height > _heightThreshold,
            floating: true,
            snap: true,
            title: const Text('Favorite characters'),
          ),
          if (scope.state.hasError)
            SliverToBoxAdapter(
              child: Center(
                child: ErrorView(
                  message: scope.state.message,
                  onRetry: () => scope.fetchFavorites(null),
                ),
              ),
            ),
          if (!scope.state.hasError && scope.characters.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: EmptyView(
                  title: 'Пока нет любимых персонажей',
                  subtitle: 'Добавьте персонажей в избранное,\nчтобы они появились здесь',
                  buttonLabel: 'Посмотреть персонажей',
                  onButtonPressed: () {
                    final navigationState =
                        context.findAncestorStateOfType<NavigationBarScreenState>();
                    if (navigationState != null) {
                      navigationState.setState(() {
                        navigationState.currentPageIndex = 0;
                      });
                    } else {
                      print('NavigationBarScreenState not found');
                    }
                  },
                ),
              ),
            )
          else ...[
            // Filter chips
            SliverToBoxAdapter(
              child: StatusFilterChips(
                selectedStatus: scope.selectedStatus,
                onStatusChanged: scope.setStatusFilter,
              ),
            ),
            const FavoritesList(),
          ],
        ],
      ),
    );
  }
}
