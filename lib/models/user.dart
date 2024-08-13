import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
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
  unknown,
}

@JsonSerializable()
class User extends BaseModel {
  final String? email;
  final String? username;
  final String? accountType;
  final String? role;
  final String? id;
  final Profile? profile;

  const User({
    this.email,
    this.username,
    this.accountType,
    this.role,
    this.id,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
