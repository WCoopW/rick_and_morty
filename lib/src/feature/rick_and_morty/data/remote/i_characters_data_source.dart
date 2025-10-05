import 'package:rick_and_morty/src/feature/rick_and_morty/model/dtos/location_d_t_o.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/dtos/paginated/paginated_characters_d_t_o.dart';

abstract interface class ICharactersDataSource {
  Future<PaginatedCharactersDTO> getCharactersByPage(int page);
  Future<LocationDTO> getLocation(String url);
}
