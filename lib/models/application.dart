import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'application.g.dart';

@JsonSerializable()
class Application extends BaseModel {
  final String? id;
  final String? freelancer;
  final String? job;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Application(
      {this.id,
      this.freelancer,
      this.job,
      this.status,
      this.createdAt,
      this.updatedAt});

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}
