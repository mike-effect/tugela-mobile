import 'package:flutter/material.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/ui/profile/profile_company.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class CompanyDetails extends StatefulWidget {
  final Company company;
  const CompanyDetails({super.key, required this.company});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: AppBar(),
      bodyPadding: ContentPadding,
      body: ProfileCompany(
        company: widget.company,
      ),
    );
  }
}
