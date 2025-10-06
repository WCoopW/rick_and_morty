import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

abstract interface class ILocalCharactersDataSource {
  Future<int> addFavorite(CharacterEntity character);
  Future<int> deleteFavorite(int id);
  Future<List<CharacterEntity>> getFavorites(String? status);
}
