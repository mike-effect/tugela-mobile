import 'package:json_annotation/json_annotation.dart';

part 'xrp_balance.g.dart';

@JsonSerializable()
class XRPBalance {
  final String? xrpAddress;
  final String? account;
  final String? balance;
  final double? xrpBalance;

  XRPBalance({
    this.xrpAddress,
    this.account,
    this.balance,
    this.xrpBalance,
  });

  factory XRPBalance.fromJson(Map<String, dynamic> json) =>
      _$XRPBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$XRPBalanceToJson(this);
}
