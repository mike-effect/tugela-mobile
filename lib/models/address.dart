import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'address.g.dart';

@JsonSerializable()
class Address extends BaseModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final String? addressName;
  final String? streetName;
  final String? address;
  final String? city;
  final String? town;
  final String? country;
  final String? lat;
  final String? lon;
  final String? user;

  const Address({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.addressName,
    this.streetName,
    this.address,
    this.city,
    this.town,
    this.country,
    this.lat,
    this.lon,
    this.user,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
