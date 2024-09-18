import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/freelancer_service.dart';
import 'package:tugela/models/portfolio_item.dart';
import 'package:tugela/models/skill.dart';
import 'package:tugela/models/work_experience.dart';

part 'freelancer.g.dart';

enum DeliveryDuration { day, week, month }

@JsonSerializable(includeIfNull: false)
class Freelancer extends BaseModel {
  final String? id;
  @JsonKey(includeFromJson: false)
  final String? user;
  final String? title;
  final String? fullname;
  final String? bio;
  final String? location;
  final String? contact;
  final String? website;
  final String? phoneNumber;
  final String? profileImage;
  final String? xrpAddress;
  final String? xrpSeed;
  final List<Skill> skills;
  final String? howYouFoundUs;
  @JsonKey(includeToJson: false)
  final int totalApplications;
  @JsonKey(includeToJson: false)
  final int acceptedApplications;
  @JsonKey(includeToJson: false)
  final int rejectedApplications;
  final List<WorkExperience> workExperiences;
  final List<PortfolioItem> portfolioItem;
  final List<FreelancerService> services;

  const Freelancer({
    this.id,
    this.user,
    this.title,
    this.fullname,
    this.bio,
    this.location,
    this.contact,
    this.website,
    this.phoneNumber,
    this.profileImage,
    this.xrpAddress,
    this.xrpSeed,
    this.skills = const [],
    this.workExperiences = const [],
    this.portfolioItem = const [],
    this.services = const [],
    this.howYouFoundUs,
    this.totalApplications = 0,
    this.acceptedApplications = 0,
    this.rejectedApplications = 0,
  });

  factory Freelancer.fromJson(Map<String, dynamic> json) =>
      _$FreelancerFromJson(json);

  Map<String, dynamic> toJson() => _$FreelancerToJson(this);

  Map<String, dynamic> toInputJson() {
    final j = _$FreelancerToJson(this);
    j['skills'] = skills.map((s) => s.id).toList();
    j["user"] = user;
    j.remove("id");
    j.remove("total_applications");
    j.remove("accepted_applications");
    j.remove("rejected_applications");
    return j;
  }
}
