import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_d_t_o.g.dart';

@JsonSerializable()
class InfoDTO {
  @JsonKey(name: 'count', required: true)
  final int count;
  @JsonKey(name: 'pages', required: true)
  final int pages;
  @JsonKey(name: 'next', required: false)
  final String? next;
  @JsonKey(name: 'prev', required: false)
  final String? prev;

  InfoDTO({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  factory InfoDTO.fromJson(Map<String, dynamic> json) => _$InfoDTOFromJson(json);

  Map<String, dynamic> toJson() => _$InfoDTOToJson(this);
}
