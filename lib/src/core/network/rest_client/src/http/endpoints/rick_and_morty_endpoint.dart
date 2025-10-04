import 'package:tarkov_mobile/src/core/rest_client/src/http/endpoints/endpoints.dart';

class RickAndMortyEndpoints extends Endpoints {
/* -------------------------------------------------------------------------- */
  final String _characters;
/* -------------------------------------------------------------------------- */
  RickAndMortyEndpoints({
    required super.baseUrl,
    required super.apiVersion,
    required String characters,
  }) : _characters = characters;
/* -------------------------------------------------------------------------- */
  String characters(String eventId) {
    return buildApiEndpoint('events/$eventId/capture-points/stats/');
  }

  String get charactersList => buildApiEndpoint(_characters);

/* -------------------------------------------------------------------------- */
}
