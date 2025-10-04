import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/location_entity.dart';

part 'location_d_t_o.g.dart';

@JsonSerializable()
class LocationDTO {
  @JsonKey(name: 'id', required: false)
  final int? id;

  @JsonKey(name: 'name', required: true)
  final String name;

  @JsonKey(name: 'type', required: false)
  final String? type;

  @JsonKey(name: 'dimension', required: false)
  final String? dimension;
  @JsonKey(name: 'url', required: true)
  final String url;

  LocationDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.url,
  });

  factory LocationDTO.fromJson(Map<String, dynamic> json) => _$LocationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDTOToJson(this);

  LocationEntity toEntity() => LocationEntity(
        id: id,
        name: name,
        type: type,
        dimension: dimension,
        url: url,
      );
}
