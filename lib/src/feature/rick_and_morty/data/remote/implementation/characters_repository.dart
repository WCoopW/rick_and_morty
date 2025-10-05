import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/i_characters_data_source.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/i_characters_repository.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/location_entity.dart';

class CharactersRepository implements ICharactersRepository {
/* -------------------------------------------------------------------------- */
  final ICharactersDataSource dataSource;
/* -------------------------------------------------------------------------- */
  CharactersRepository({required this.dataSource});
/* -------------------------------------------------------------------------- */
  @override
  Future<({List<CharacterEntity> characters, int lastPage})> getCharactersByPage(int page) {
    return dataSource.getCharactersByPage(page).then(
          (paginatedData) => (
            characters: paginatedData.toEntities(),
            lastPage: paginatedData.info.pages,
          ),
        );
  }

/* -------------------------------------------------------------------------- */
  @override
  Future<LocationEntity> getLocation(String url) {
    return dataSource.getLocation(url).then((location) => location.toEntity());
  }
}
