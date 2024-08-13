import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'freelancer.g.dart';

@JsonSerializable()
class Freelancer extends BaseModel {
  final String? id;
  final String? user;
  final String? howYouFoundUs;

  const Freelancer({this.id, this.user, this.howYouFoundUs});

  factory Freelancer.fromJson(Map<String, dynamic> json) =>
      _$FreelancerFromJson(json);

  Map<String, dynamic> toJson() => _$FreelancerToJson(this);
}
