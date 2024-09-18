import 'package:json_annotation/json_annotation.dart';

part 'payment_service.g.dart';

@JsonSerializable()
class PaymentService {
  final String? id;
  final String? name;
  final String? url;
  final String? status;

  PaymentService({
    this.id,
    this.name,
    this.url,
    this.status,
  });

  factory PaymentService.fromJson(Map<String, dynamic> json) =>
      _$PaymentServiceFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentServiceToJson(this);
}
