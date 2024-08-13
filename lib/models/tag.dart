import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag extends BaseModel {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Tag({this.id, this.name, this.createdAt, this.updatedAt});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
