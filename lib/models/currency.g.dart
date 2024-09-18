// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      id: json['id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      factor: json['factor'] as String?,
      precision: (json['precision'] as num?)?.toInt(),
      symbol: json['symbol'] as String?,
      type: $enumDecodeNullable(_$CurrencyTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('code', instance.code);
  writeNotNull('name', instance.name);
  writeNotNull('factor', instance.factor);
  writeNotNull('precision', instance.precision);
  writeNotNull('symbol', instance.symbol);
  writeNotNull('type', _$CurrencyTypeEnumMap[instance.type]);
  return val;
}

const _$CurrencyTypeEnumMap = {
  CurrencyType.fiat: 'fiat',
  CurrencyType.crypto: 'crypto',
};
