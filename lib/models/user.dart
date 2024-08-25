import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/models/profile.dart';

part 'user.g.dart';

enum HowYouFoundUs {
  facebook,
  twitter,
  instagram,
  youtube,
  techEvent,
  afriblockMember,
  afriblockEmployee,
}

enum AccountType { company, freelancer, unknown }

@JsonSerializable()
class User extends BaseModel {
  final String? email;
  final String? username;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final AccountType? accountType;
  final String? role;
  final String? id;
  final Profile? profile;
  final Freelancer? freelancer;
  final Company? company;

  const User({
    this.email,
    this.username,
    this.accountType,
    this.role,
    this.id,
    this.profile,
    this.company,
    this.freelancer,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
