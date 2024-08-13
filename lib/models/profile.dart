import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile extends BaseModel {
  final String? id;
  final String? user;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? addressName;
  final String? gender;
  final DateTime? dob;
  final String? phoneNumber;
  final String? profileImage;

  const Profile({
    this.id,
    this.user,
    this.firstName,
    this.lastName,
    this.email,
    this.addressName,
    this.gender,
    this.dob,
    this.phoneNumber,
    this.profileImage,
  });

  String? get genderName {
    final map = {
      'm': 'Male',
      'f': 'Female',
      'o': 'Other',
    };
    return map[gender];
  }

  static String? getGender(String? gender) {
    final map = {
      'm': 'Male',
      'f': 'Female',
      'o': 'Other',
    };
    return map[gender];
  }

  Map<String, dynamic> toJson() {
    final map = _$ProfileToJson(this);
    if (map.containsKey('dob')) {
      map['dob'] = dob?.toIso8601String().split('T').first;
    }
    return map;
  }

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
