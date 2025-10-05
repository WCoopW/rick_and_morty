import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

abstract interface class ILocalCharactersRepository {
  Future<List<CharacterEntity>> getFavorites(String? status);
  Future<int> removeFavorite(int id);
  Future<int> addFavorite(CharacterEntity character);
}
