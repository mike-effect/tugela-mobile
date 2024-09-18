import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/models/user.dart';
import 'package:tugela/providers/user_provider.dart';

class AccountTypeView extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    Freelancer? freelancer,
  )? freelancer;
  final Widget Function(
    BuildContext context,
    Company? company,
  )? company;
  final EdgeInsets? padding;
  const AccountTypeView({
    super.key,
    this.company,
    this.freelancer,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: (userProvider.user?.accountType == AccountType.company
              ? company?.call(context, userProvider.user?.company)
              : freelancer?.call(context, userProvider.user?.freelancer)) ??
          const SizedBox.shrink(),
    );
  }
}
