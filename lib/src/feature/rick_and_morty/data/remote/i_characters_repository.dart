import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/i_characters_data_source.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/location_entity.dart';

abstract interface class ICharactersRepository {
/* -------------------------------------------------------------------------- */
  final ICharactersDataSource dataSource;
/* -------------------------------------------------------------------------- */
  ICharactersRepository({
    required this.dataSource,
  });

  /// Returns a tuple of (characters, totalCount)
  Future<({List<CharacterEntity> characters, int lastPage})> getCharactersByPage(int page);

  Future<LocationEntity> getLocation(String url);
}
