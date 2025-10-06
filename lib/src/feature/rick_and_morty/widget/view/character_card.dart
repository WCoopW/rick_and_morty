import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorite_button.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/components/character_details_modal.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/characters_scope.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

/// {@template character_card}
/// CharacterCard displays a single character with their image, name, status and species.
/// {@endtemplate}
class CharacterCard extends StatelessWidget {
  /// {@macro character_card}
  const CharacterCard({
    required this.character,
    super.key,
  });

  final CharacterEntity character;

  static const double _cardMargin = 8.0;
  static const double _cardPadding = 16.0;
  static const double _imageBorderRadius = 6.0;
  static const double _imageSize = 80.0;
  static const double _imageBorderWidth = 2.0;
  static const double _statusIndicatorSize = 8.0;
  static const double _iconSize = 40.0;
  static const double _spacingSmall = 4.0;
  static const double _spacingMedium = 16.0;
  static const double _cardBorderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(_cardMargin),
      child: InkWell(
        onTap: () async {
          final scope = CharactersScope.of(context, listen: false);
          final characterWithLocation = await scope.fetchCharacterLocation(character);
          if (context.mounted) {
            CharacterDetailsModal.show(context, characterWithLocation);
          }
        },
        borderRadius: const BorderRadius.all(Radius.circular(_cardBorderRadius)),
        child: Padding(
          padding: const EdgeInsets.all(_cardPadding),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(_imageBorderRadius)),
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(_imageBorderRadius)),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: _getStatusColor(character.status),
                        width: _imageBorderWidth,
                      ),
                    ),
                  ),
                  child: Image.network(
                    character.image,
                    width: _imageSize,
                    height: _imageSize,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      return SizedBox(
                        width: _imageSize,
                        height: _imageSize,
                        child: loadingProgress == null
                            ? child
                            : Padding(
                                padding: EdgeInsetsGeometry.all(
                                  _spacingMedium,
                                ),
                                child: RepaintBoundary(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.lightGreen,
                                  ),
                                ),
                              ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: _imageSize,
                        height: _imageSize,
                        child: Icon(
                          Icons.person,
                          color: _getStatusColor(character.status),
                          size: _iconSize,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: _spacingMedium),
              // Character info
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  spacing: _spacingSmall,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightGreen,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      spacing: _spacingSmall,
                      children: [
                        SizedBox(
                          width: _statusIndicatorSize,
                          height: _statusIndicatorSize,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStatusColor(character.status),
                            ),
                          ),
                        ),
                        Text(
                          '${character.status} - ${character.species}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      character.location.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: _spacingMedium),
              FavoriteButton(
                characterId: character.id,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return AppTheme.lightGreen;
      case 'dead':
        return Colors.red;
      default:
        return AppTheme.rickGreen;
    }
  }
}
