// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool?,
      addressName: json['address_name'] as String?,
      streetName: json['street_name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      town: json['town'] as String?,
      country: json['country'] as String?,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
      user: json['user'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  writeNotNull('is_active', instance.isActive);
  writeNotNull('address_name', instance.addressName);
  writeNotNull('street_name', instance.streetName);
  writeNotNull('address', instance.address);
  writeNotNull('city', instance.city);
  writeNotNull('town', instance.town);
  writeNotNull('country', instance.country);
  writeNotNull('lat', instance.lat);
  writeNotNull('lon', instance.lon);
  writeNotNull('user', instance.user);
  return val;
}
