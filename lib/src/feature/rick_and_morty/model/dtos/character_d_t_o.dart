import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/dtos/location_d_t_o.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/character_entity.dart';

part 'character_d_t_o.g.dart';

@JsonSerializable()
class CharacterDTO {
  @JsonKey(name: 'id', required: true)
  final int id;

  @JsonKey(name: 'name', required: true)
  final String name;

  @JsonKey(name: 'status', required: true)
  final String status;

  @JsonKey(name: 'species', required: false)
  final String species;

  @JsonKey(name: 'type', required: false)
  final String type;

  @JsonKey(name: 'gender', required: false)
  final String gender;

  @JsonKey(name: 'image', required: true)
  final String image;

  @JsonKey(name: 'location', required: false)
  final LocationDTO location;

  CharacterDTO({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.location,
  });

  factory CharacterDTO.fromJson(Map<String, dynamic> json) => _$CharacterDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterDTOToJson(this);

  CharacterEntity toEntity() => CharacterEntity(
        id: id,
        name: name,
        status: status,
        species: species,
        type: type,
        gender: gender,
        image: image,
        location: location.toEntity(),
      );
}
