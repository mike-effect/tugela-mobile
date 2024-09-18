import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'currency.g.dart';

enum CurrencyType { fiat, crypto }

@JsonSerializable()
class Currency extends BaseModel {
  final String? id;
  final String? code;
  final String? name;
  final String? factor;
  final int? precision;
  final String? symbol;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final CurrencyType? type;

  const Currency({
    this.id,
    this.code,
    this.name,
    this.factor,
    this.precision,
    this.symbol,
    this.type,
  });

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
