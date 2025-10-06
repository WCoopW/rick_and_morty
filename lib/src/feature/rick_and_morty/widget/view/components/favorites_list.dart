import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/character_card.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorites_scope.dart';

/// {@template characters_list}
/// CharactersList widget.
/// {@endtemplate}
class FavoritesList extends StatelessWidget {
  /// {@macro characters_list}
  const FavoritesList({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    final scope = FavoritesScope.of(context, listen: true);
    return SliverList.builder(
      itemCount: scope.filteredCharacters.length,
      itemBuilder: (context, index) {
        return CharacterCard(
          key: Key(scope.filteredCharacters[index].id.toString()),
          character: scope.filteredCharacters[index],
        );
      },
    );
  }
}
