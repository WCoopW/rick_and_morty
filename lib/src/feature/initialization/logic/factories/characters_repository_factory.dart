import 'package:dio/dio.dart';
import 'package:rick_and_morty/src/core/network/rest_client/src/http/endpoints/rick_and_morty_endpoint.dart';
import 'package:rick_and_morty/src/feature/initialization/logic/composition_root.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/implementation/characters_data_source.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/implementation/characters_repository.dart';

class CharactersRepositoryFactory extends AsyncFactory<CharactersRepository> {
/* -------------------------------------------------------------------------- */
  final Dio client;

/* -------------------------------------------------------------------------- */
  CharactersRepositoryFactory({
    required this.client,
  });
/* -------------------------------------------------------------------------- */
  @override
  Future<CharactersRepository> create() async {
    return new CharactersRepository(
      dataSource: new CharactersDataSource(
        client: client,
        endpoint: RickAndMortyEndpoint(
          baseUrl: 'https://rickandmortyapi.com',
          apiVersion: 'api',
          characters: 'character',
          location: 'location',
          paginatedQuery: 'page',
        ),
      ),
    );
  }
/* -------------------------------------------------------------------------- */
}
