import 'package:flutter/material.dart';
import 'package:tugela/models/job_submission.dart';

class ApplicationOfferDetails extends StatefulWidget {
  final JobSubmission submission;
  const ApplicationOfferDetails({
    super.key,
    required this.submission,
  });

  @override
  State<ApplicationOfferDetails> createState() =>
      _ApplicationOfferDetailsState();
}

class _ApplicationOfferDetailsState extends State<ApplicationOfferDetails> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
