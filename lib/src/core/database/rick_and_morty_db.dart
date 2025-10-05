import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rick_and_morty/src/core/database/tables/favorites_characters.dart';
import 'package:rick_and_morty/src/core/database/tables/locations.dart';

part 'rick_and_morty_db.g.dart';

@DriftDatabase(tables: [FavoritesCharacters, Locations])
class RickAndMortyDb extends _$RickAndMortyDb {
  RickAndMortyDb([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
