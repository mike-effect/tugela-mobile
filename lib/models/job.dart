import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/company.dart';

part 'job.g.dart';

@JsonSerializable()
class Job extends BaseModel {
  final String? id;
  final String? title;
  final Company? company;
  final String? description;
  final String? experience;
  final String? responsibilities;
  final DateTime? date;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JobLocation? location;
  final String? address;
  final List<String> tags;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final PriceType? priceType;
  final String? price;
  final String? maxPrice;
  final String? minPrice;
  final String? currency;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JobApplicationType? applicationType;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JobStatus? status;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JobRoleType? roleType;
  final String? externalApplyLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Job({
    this.id,
    this.title,
    this.company,
    this.description,
    this.experience,
    this.responsibilities,
    this.date,
    this.location,
    this.address,
    this.tags = const [],
    this.priceType,
    this.price,
    this.minPrice,
    this.maxPrice,
    this.currency,
    this.applicationType,
    this.status,
    this.externalApplyLink,
    this.createdAt,
    this.updatedAt,
    this.roleType,
  });

  double get compensation {
    return double.tryParse(minPrice ?? "") ?? 0;
  }

  bool get isCompensationRange {
    return (double.tryParse(maxPrice ?? '') ?? 0) >
        (double.tryParse(minPrice ?? '') ?? 0);
  }

  bool get canHaveCompensationRange {
    return priceType != PriceType.perProject;
  }

  bool get isOnsite {
    return location == JobLocation.onsite && (address ?? '').isNotEmpty;
  }

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$JobToJson(this);
    json['company'] = company?.id;
    return json;
  }
}

@JsonEnum(fieldRename: FieldRename.snake)
enum JobRoleType {
  partTime,
  contract,
  fullTime,
  internship,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum PriceType {
  perProject,
  @JsonValue("per_day")
  daily,
  @JsonValue("per_hour")
  hourly,
  @JsonValue("per_week")
  weekly,
  @JsonValue("per_month")
  monthly,
  @JsonValue("per_year")
  yearly,
}

enum JobApplicationType {
  internal,
  external,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum JobStatus {
  active,
  inactive,
  assigned,
  completed,
}

enum JobLocation {
  @JsonValue("on-site")
  onsite,
  remote,
  hybrid,
}
