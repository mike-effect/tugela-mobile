import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'company_manager.g.dart';

@JsonSerializable()
class CompanyManager extends BaseModel {
  final String? id;
  final String? user;
  final String? company;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CompanyManager({
    this.id,
    this.user,
    this.company,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyManager.fromJson(Map<String, dynamic> json) =>
      _$CompanyManagerFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyManagerToJson(this);
}
