import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/providers/job_provider.dart';
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
  void initState() {
    final companyProvider = context.read<CompanyProvider>();
    if (companyProvider.company[widget.company.id] == null) {
      companyProvider.getCompany(widget.company.id!);
    }
    final jobProvider = context.read<JobProvider>();
    if ((jobProvider.jobs[widget.company.id]?.data ?? []).isEmpty) {
      jobProvider.getJobs(
        mapId: widget.company.id!,
        params: {"company": widget.company.id!},
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: AppBar(
          // title: const Text("Company"),
          ),
      bodyPadding: ContentPadding,
      body: ProfileCompany(company: widget.company),
    );
  }
}
