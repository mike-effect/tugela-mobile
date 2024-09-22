import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/company_manager.dart';
import 'package:tugela/models/company_value.dart';
import 'package:tugela/models/industry.dart';
import 'package:tugela/models/user.dart';

part 'company.g.dart';

@JsonSerializable()
class Company extends BaseModel {
  final String? id;
  final String? xrpAddress;
  final String? xrpSeed;
  final String? address;
  final String? name;
  final String? description;
  final String? email;
  final String? phoneNumber;
  final String? tagline;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final CompanySize? companySize;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final OrganizationType? organizationType;
  final String? website;
  final String? logo;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final HowYouFoundUs? howYouFoundUs;
  final String? founded;
  final String? location;
  @JsonKey(includeToJson: false)
  final int totalJobs;
  @JsonKey(includeToJson: false)
  final int activeJobs;
  @JsonKey(includeToJson: false)
  final int assignedJobs;
  @JsonKey(includeToJson: false)
  final int completedJobs;
  @JsonKey(includeToJson: false)
  final int totalApplications;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CompanyManager> managers;
  final Industry? industry;
  final List<CompanyValue> values;
  @JsonKey(includeFromJson: false)
  final User? user;

  const Company({
    this.id,
    this.address,
    this.xrpAddress,
    this.xrpSeed,
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
    this.founded,
    this.location,
    this.totalJobs = 0,
    this.activeJobs = 0,
    this.assignedJobs = 0,
    this.completedJobs = 0,
    this.totalApplications = 0,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.managers = const [],
    this.industry,
    this.values = const [],
    this.user,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  Map<String, dynamic> toInputJson() {
    final j = _$CompanyToJson(this);
    j['values'] = values.map((c) => c.id).toList();
    j['industry'] = industry?.id;
    j['user'] = user?.id;
    return j;
  }
}

enum CompanySize {
  small,
  medium,
  big,
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
}
