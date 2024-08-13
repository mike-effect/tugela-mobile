import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'skill.g.dart';

@JsonSerializable()
class Skill extends BaseModel {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Skill({this.id, this.name, this.createdAt, this.updatedAt});

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
