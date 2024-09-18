import 'package:flutter/material.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/ui/profile/profile_freelancer.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/sliver_scaffold.dart';

class FreelancerDetails extends StatefulWidget {
  final Freelancer freelancer;
  const FreelancerDetails({super.key, required this.freelancer});

  @override
  State<FreelancerDetails> createState() => _FreelancerDetailsState();
}

class _FreelancerDetailsState extends State<FreelancerDetails> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: AppBar(
          // title: const Text("Company"),
          ),
      bodyPadding: ContentPadding,
      body: ProfileFreelancer(freelancer: widget.freelancer),
    );
  }
}
