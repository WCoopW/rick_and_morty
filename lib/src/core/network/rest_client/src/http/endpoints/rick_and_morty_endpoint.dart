import 'package:rick_and_morty/src/core/network/rest_client/src/http/endpoints/endpoints.dart';

class RickAndMortyEndpoint extends Endpoints {
/* -------------------------------------------------------------------------- */
  final String _characters;
/* -------------------------------------------------------------------------- */
  final String _location;
/* -------------------------------------------------------------------------- */
  final String _paginatedQuery;
/* -------------------------------------------------------------------------- */
  RickAndMortyEndpoint({
    required super.baseUrl,
    required super.apiVersion,
    required String characters,
    required String location,
    required String paginatedQuery,
  })  : _characters = characters,
        _paginatedQuery = paginatedQuery,
        _location = location;
/* -------------------------------------------------------------------------- */
  String paginatedCharacters(int page) =>
      buildApiEndpointWithQuery(_characters, {_paginatedQuery: page});
/* -------------------------------------------------------------------------- */
  String location(String url) => buildApiEndpoint('$_location/$url');
/* -------------------------------------------------------------------------- */
}
