import 'package:drift/drift.dart';
import 'package:rick_and_morty/src/core/database/rick_and_morty_db.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/local/i_local_characters_data_source.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/location_entity.dart';

class LocalCharactersDataSource implements ILocalCharactersDataSource {
  final RickAndMortyDb db;
  $FavoritesCharactersTable get favorites => db.favoritesCharacters;
  $LocationsTable get locations => db.locations;

  LocalCharactersDataSource({
    required this.db,
  });

  @override
  Future<int> addFavorite(CharacterEntity item) async {
    await _insertLocation(item.location);

    return await db.into(favorites).insert(
          FavoritesCharactersCompanion.insert(
            id: item.id,
            image: item.image,
            name: item.name,
            status: item.status,
            gender: Value(item.gender),
            species: Value(item.species),
            type: Value(item.type),
            locationId: item.location.id!,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> _insertLocation(LocationEntity location) async {
    final existingLocation =
        await (db.select(locations)..where((tbl) => tbl.id.equals(location.id!))).getSingleOrNull();

    if (existingLocation == null) {
      await db.into(locations).insert(
            LocationsCompanion(
              id: Value(location.id!),
              name: Value(location.name),
              type: Value(location.type),
              dimension: Value(location.dimension),
              url: Value(location.url),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  @override
  Future<int> deleteFavorite(int id) async {
    final character = await (db.select(favorites)..where((f) => f.id.equals(id))).getSingleOrNull();
    final deleted = await (db.delete(favorites)..where((f) => f.id.equals(id))).go();

    if (character != null && deleted > 0) {
      await _deleteUnusedLocation(character.locationId);
    }

    return deleted;
  }

  Future<int> _deleteUnusedLocation(int id) async {
    final isUsed = await (db.select(favorites)..where((tbl) => tbl.locationId.equals(id))).get();

    if (isUsed.isNotEmpty) {
      return 0;
    }

    final query = db.delete(locations)..where((tbl) => tbl.id.equals(id));
    return await query.go();
  }

  @override
  Future<List<CharacterEntity>> getFavorites(String? status) async {
    final query = db.select(favorites).join([
      innerJoin(
        locations,
        locations.id.equalsExp(
          favorites.locationId!,
        ),
      ),
    ]);
    if (status != null) query.where(favorites.status.like(status));
    final rows = await query.get();
    return rows.map((row) {
      final character = row.readTable(favorites);
      final location = row.readTable(locations);
      return CharacterEntity(
        id: character.id,
        name: character.name,
        status: character.status,
        species: character.species,
        type: character.type,
        gender: character.gender,
        image: character.image,
        location: LocationEntity(
          id: location.id,
          name: location.name,
          type: location.type,
          dimension: location.dimension,
          url: location.url,
        ),
      );
    }).toList();
  }
}
