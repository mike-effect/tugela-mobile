import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'company_value.g.dart';

@JsonSerializable()
class CompanyValue extends BaseModel {
  final String? id;
  final String? name;

  const CompanyValue({
    this.id,
    this.name,
  });

  factory CompanyValue.fromJson(Map<String, dynamic> json) =>
      _$CompanyValueFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyValueToJson(this);

  @override
  List<Object?> get props => [id, name];
}
