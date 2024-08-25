import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'industry.g.dart';

@JsonSerializable()
class Industry extends BaseModel {
  final String? id;
  final String? name;

  const Industry({
    this.id,
    this.name,
  });

  factory Industry.fromJson(Map<String, dynamic> json) =>
      _$IndustryFromJson(json);

  Map<String, dynamic> toJson() => _$IndustryToJson(this);

  @override
  List<Object?> get props => [id, name];
}
