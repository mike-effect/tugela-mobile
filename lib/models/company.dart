import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/user.dart';

part 'company.g.dart';

enum CompanySize {
  small,
  medium,
  big,
  unknown,
}

enum OrganizationType {
  @JsonValue("public_company")
  publicCompany,
  @JsonValue("self_employed")
  selfEmployed,
  @JsonValue("government_agency")
  governmentAgency,
  nonprofit,
  @JsonValue("sole_proprietorship")
  soleProprietorship,
  @JsonValue("privately_held")
  privatelyHeld,
  partnership,
  unknown,
}

@JsonSerializable()
class Company extends BaseModel {
  final String? id;
  final String? user;
  final String? name;
  final String? description;
  final String? email;
  final String? phoneNumber;
  final String? tagline;
  @JsonKey(unknownEnumValue: CompanySize.unknown)
  final CompanySize? companySize;
  @JsonKey(unknownEnumValue: OrganizationType.unknown)
  final OrganizationType? organizationType;
  final String? website;
  final String? logo;
  @JsonKey(unknownEnumValue: HowYouFoundUs.unknown)
  final HowYouFoundUs? howYouFoundUs;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Company({
    this.id,
    this.user,
    this.name,
    this.description,
    this.email,
    this.phoneNumber,
    this.tagline,
    this.companySize,
    this.organizationType,
    this.website,
    this.logo,
    this.howYouFoundUs,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
