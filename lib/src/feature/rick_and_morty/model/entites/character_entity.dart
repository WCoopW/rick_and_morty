import 'package:rick_and_morty/src/feature/rick_and_morty/model/entites/location_entity.dart';

class CharacterEntity {
  final int id;
  final String name;
  final String status;
  final String? species;
  final String? type;
  final String? gender;
  final String image;
  LocationEntity location;

  CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
    required this.location,
    this.species,
    this.type,
    this.gender,
  });

  CharacterEntity setLocation(LocationEntity location) {
    this.location = location;
    return this;
  }
}
