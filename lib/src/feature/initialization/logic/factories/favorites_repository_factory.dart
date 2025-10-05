import 'package:rick_and_morty/src/core/database/rick_and_morty_db.dart';
import 'package:rick_and_morty/src/feature/initialization/logic/composition_root.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/local/implementation/local_characters_data_source.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/local/implementation/local_characters_repository.dart';

class FavoritesRepositoryFactory extends AsyncFactory<LocalCharactersRepository> {
/* -------------------------------------------------------------------------- */
  final RickAndMortyDb db;
/* -------------------------------------------------------------------------- */
  FavoritesRepositoryFactory({
    required this.db,
  });
/* -------------------------------------------------------------------------- */
  @override
  Future<LocalCharactersRepository> create() async {
    return new LocalCharactersRepository(
      localDs: new LocalCharactersDataSource(
        db: db,
      ),
    );
  }
/* -------------------------------------------------------------------------- */
}
