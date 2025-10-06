import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/characters_scope.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorites_scope.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    required this.characterId,
    super.key,
  });

  final int characterId;

  @override
  Widget build(BuildContext context) {
    final charactersScope = CharactersScope.of(context, listen: true);
    final favoritesScope = FavoritesScope.of(context, listen: true);
    final theme = Theme.of(context);

    // Check if character is in favorites by looking at the actual favorites list
    final isFavorite = favoritesScope.characters.any((char) => char.id == characterId);

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? Colors.amber : theme.iconTheme.color,
      ),
      onPressed: () => charactersScope.favoriteButtonClick(characterId),
    );
  }
}
