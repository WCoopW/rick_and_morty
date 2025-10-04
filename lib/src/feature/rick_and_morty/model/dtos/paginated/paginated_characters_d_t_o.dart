import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/dtos/character_d_t_o.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/dtos/paginated/info_d_t_o.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

part 'paginated_characters_d_t_o.g.dart';

@JsonSerializable()
class PaginatedCharactersDTO {
  @JsonKey(name: 'info')
  final InfoDTO info;

  @JsonKey(name: 'results')
  final List<CharacterDTO> results;

  PaginatedCharactersDTO({
    required this.info,
    required this.results,
  });

  factory PaginatedCharactersDTO.fromJson(Map<String, dynamic> json) =>
      _$PaginatedCharactersDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedCharactersDTOToJson(this);

  List<CharacterEntity> toEntities() =>
      this.results.map((character) => character.toEntity()).toList();
}
