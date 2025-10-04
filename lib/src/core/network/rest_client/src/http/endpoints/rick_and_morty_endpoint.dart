import 'package:rick_and_morty/src/core/network/rest_client/src/http/endpoints/endpoints.dart';

class RickAndMortyEndpoint extends Endpoints {
/* -------------------------------------------------------------------------- */
  final String _characters;
/* -------------------------------------------------------------------------- */
  final String _location;
/* -------------------------------------------------------------------------- */
  RickAndMortyEndpoint({
    required super.baseUrl,
    required super.apiVersion,
    required String characters,
    required String location,
  })  : _characters = characters,
        _location = location;
/* -------------------------------------------------------------------------- */
  String get charactersList => buildApiEndpoint(_characters);
/* -------------------------------------------------------------------------- */
  String get location => buildApiEndpoint(_location);
/* -------------------------------------------------------------------------- */
}
