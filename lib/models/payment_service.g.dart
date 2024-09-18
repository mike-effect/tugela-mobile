// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentService _$PaymentServiceFromJson(Map<String, dynamic> json) =>
    PaymentService(
      id: json['id'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$PaymentServiceToJson(PaymentService instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('url', instance.url);
  writeNotNull('status', instance.status);
  return val;
}
