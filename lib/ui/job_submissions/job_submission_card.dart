import 'package:flutter/material.dart';
import 'package:tugela/models/job_submission.dart';
import 'package:tugela/utils.dart';

class JobSubmissionCard extends StatelessWidget {
  final JobSubmission submission;
  const JobSubmissionCard({
    super.key,
    required this.submission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContentPadding,
      child: const Column(
        children: [],
      ),
    );
  }
}
