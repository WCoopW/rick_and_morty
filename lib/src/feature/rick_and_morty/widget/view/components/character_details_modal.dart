import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/widget/view/favorites/favorite_button.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

/// {@template character_details_modal}
/// CharacterDetailsModal displays full character information in a modal dialog.
/// {@endtemplate}
class CharacterDetailsModal extends StatelessWidget {
  /// {@macro character_details_modal}
  const CharacterDetailsModal({
    required this.character,
    super.key,
  });

  final CharacterEntity character;

  static const double _imageSize = 200.0;
  static const double _imageBorderRadius = 12.0;
  static const double _imageBorderWidth = 3.0;
  static const double _statusIndicatorSize = 12.0;
  static const double _spacingSmall = 8.0;
  static const double _spacingMedium = 16.0;
  static const double _spacingLarge = 24.0;
  static const double _modalPadding = 24.0;
  static const double _infoItemSpacing = 12.0;
  static const double _dialogBorderRadius = 16.0;
  static const double _labelWidth = 100.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_dialogBorderRadius)),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(_modalPadding),
            child: Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Character Details',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: colorScheme.onSurface,
                    ),
                  ],
                ),
                const SizedBox(height: _spacingLarge),

                // Character image
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
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: _imageSize,
                        height: _imageSize,
                        color: colorScheme.surfaceVariant,
                        child: const Icon(Icons.person, size: 80),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: _spacingLarge),

                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        character.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: _spacingMedium),
                    FavoriteButton(characterId: character.id),
                  ],
                ),
                const SizedBox(height: _spacingMedium),

                // Status indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _statusIndicatorSize,
                      height: _statusIndicatorSize,
                      decoration: BoxDecoration(
                        color: _getStatusColor(character.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: _spacingSmall),
                    Text(
                      character.status,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _spacingLarge),

                // Character information
                _CharacterInfoSection(
                  title: 'Basic Information',
                  items: [
                    _CharacterInfoItem(label: 'Species', value: character.species ?? 'Unknown'),
                    _CharacterInfoItem(label: 'Type', value: character.type ?? 'Unknown'),
                    _CharacterInfoItem(label: 'Gender', value: character.gender ?? 'Unknown'),
                  ],
                ),
                const SizedBox(height: _spacingLarge),

                // Location information
                _CharacterInfoSection(
                  title: 'Location',
                  items: [
                    _CharacterInfoItem(label: 'Name', value: character.location.name),
                    if (character.location.type != null)
                      _CharacterInfoItem(label: 'Type', value: character.location.type ?? ''),
                    if (character.location.dimension != null)
                      _CharacterInfoItem(
                          label: 'Dimension', value: character.location.dimension ?? ''),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      case 'unknown':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  /// Shows the character details modal
  static void show(BuildContext context, CharacterEntity character) {
    showDialog(
      context: context,
      builder: (context) => CharacterDetailsModal(character: character),
    );
  }
}

class _CharacterInfoSection extends StatelessWidget {
  const _CharacterInfoSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_CharacterInfoItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: CharacterDetailsModal._spacingMedium),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: CharacterDetailsModal._infoItemSpacing),
              child: item,
            )),
      ],
    );
  }
}

class _CharacterInfoItem extends StatelessWidget {
  const _CharacterInfoItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: CharacterDetailsModal._labelWidth,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
