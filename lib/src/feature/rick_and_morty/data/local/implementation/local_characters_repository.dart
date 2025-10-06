import 'package:rick_and_morty/src/feature/rick_and_morty/data/local/i_local_characters_data_source.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/local/i_local_characters_repository.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

class LocalCharactersRepository implements ILocalCharactersRepository {
  final ILocalCharactersDataSource localDs;

  LocalCharactersRepository({required this.localDs});

  @override
  Future<int> addFavorite(CharacterEntity character) {
    return localDs.addFavorite(character);
  }

  @override
  Future<List<CharacterEntity>> getFavorites(String? status) {
    return localDs.getFavorites(status);
  }

  @override
  Future<int> removeFavorite(int id) {
    return localDs.deleteFavorite(id);
  }
}
