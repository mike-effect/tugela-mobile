// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freelancer_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreelancerService _$FreelancerServiceFromJson(Map<String, dynamic> json) =>
    FreelancerService(
      id: json['id'] as String?,
      freelancer: json['freelancer'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      deliveryTime: json['delivery_time'] as String?,
      startingPrice: json['starting_price'] as String?,
      currency: json['currency'] as String?,
      priceType: $enumDecodeNullable(_$PriceTypeEnumMap, json['price_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      serviceImage: json['service_image'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FreelancerServiceToJson(FreelancerService instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('freelancer', instance.freelancer);
  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('category', instance.category);
  writeNotNull('skills', instance.skills);
  writeNotNull('delivery_time', instance.deliveryTime);
  writeNotNull('starting_price', instance.startingPrice);
  writeNotNull('currency', instance.currency);
  writeNotNull('price_type', _$PriceTypeEnumMap[instance.priceType]);
  writeNotNull('service_image', instance.serviceImage);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

const _$PriceTypeEnumMap = {
  PriceType.perProject: 'per_project',
  PriceType.daily: 'per_day',
  PriceType.hourly: 'per_hour',
  PriceType.weekly: 'per_week',
  PriceType.monthly: 'per_month',
  PriceType.yearly: 'per_year',
};
