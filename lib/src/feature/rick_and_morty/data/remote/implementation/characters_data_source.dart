import 'package:dio/dio.dart';
import 'package:rick_and_morty/src/core/network/base/base_data_source.dart';
import 'package:rick_and_morty/src/core/network/rest_client/src/http/endpoints/rick_and_morty_endpoint.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/data/remote/i_characters_data_source.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/dtos/location_d_t_o.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/dtos/paginated/paginated_characters_d_t_o.dart';

class CharactersDataSource extends BaseDataSource implements ICharactersDataSource {
  final Dio client;
/* -------------------------------------------------------------------------- */
  final RickAndMortyEndpoint endpoint;
/* -------------------------------------------------------------------------- */
  const CharactersDataSource({
    required this.client,
    required this.endpoint,
  });
/* -------------------------------------------------------------------------- */
  @override
  Future<PaginatedCharactersDTO> getCharactersByPage(int page) {
    return handleGetRequest<PaginatedCharactersDTO>(
      context: 'CharactersDataSource.getCharactersByPage',
      request: () => client.get(endpoint.paginatedCharacters(page)),
      parser: (data) => PaginatedCharactersDTO.fromJson(data),
      successStatusCodes: [200],
    );
  }

/* -------------------------------------------------------------------------- */
  @override
  Future<LocationDTO> getLocation(String url) {
    return handleGetRequest<LocationDTO>(
      context: 'CharactersDataSource.getLocation',
      request: () => client.get(endpoint.location(url)),
      parser: (data) => LocationDTO.fromJson(data),
      successStatusCodes: [200],
    );
  }
/* -------------------------------------------------------------------------- */
}
