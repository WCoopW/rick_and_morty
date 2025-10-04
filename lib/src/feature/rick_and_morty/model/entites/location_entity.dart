class LocationEntity {
  const LocationEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.url,
  });
  final int? id;
  final String name;
  final String url;
  final String? type;
  final String? dimension;

  bool isFetched() {
    return id != null;
  }
}
