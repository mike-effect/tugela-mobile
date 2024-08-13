// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: json['id'] as String?,
      title: json['title'] as String?,
      company: json['company'] as String?,
      description: json['description'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      address: json['address'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      priceType: json['price_type'] as String?,
      price: json['price'] as String?,
      currency: json['currency'] as String?,
      applicationType: json['application_type'] as String?,
      status: json['status'] as String?,
      externalApplyLink: json['external_apply_link'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$JobToJson(Job instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('company', instance.company);
  writeNotNull('description', instance.description);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('location', instance.location);
  writeNotNull('address', instance.address);
  val['tags'] = instance.tags;
  writeNotNull('price_type', instance.priceType);
  writeNotNull('price', instance.price);
  writeNotNull('currency', instance.currency);
  writeNotNull('application_type', instance.applicationType);
  writeNotNull('status', instance.status);
  writeNotNull('external_apply_link', instance.externalApplyLink);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
