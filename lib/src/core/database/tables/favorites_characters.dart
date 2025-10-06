import 'package:drift/drift.dart';
import 'package:rick_and_morty/src/core/database/tables/locations.dart';

class FavoritesCharacters extends Table {
  IntColumn get id => integer().unique()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get species => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get image => text()();
  TextColumn get locationUrl => text().references(Locations, #url)();
}
