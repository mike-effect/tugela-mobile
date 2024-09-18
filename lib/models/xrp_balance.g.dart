// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xrp_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XRPBalance _$XRPBalanceFromJson(Map<String, dynamic> json) => XRPBalance(
      xrpAddress: json['xrp_address'] as String?,
      account: json['account'] as String?,
      balance: json['balance'] as String?,
      xrpBalance: (json['xrp_balance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$XRPBalanceToJson(XRPBalance instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('xrp_address', instance.xrpAddress);
  writeNotNull('account', instance.account);
  writeNotNull('balance', instance.balance);
  writeNotNull('xrp_balance', instance.xrpBalance);
  return val;
}
