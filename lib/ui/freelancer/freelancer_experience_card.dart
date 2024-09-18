import 'package:flutter/material.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/work_experience.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/skeleton.dart';

class FreelancerExperienceCard extends StatelessWidget {
  final WorkExperience experience;
  const FreelancerExperienceCard({
    super.key,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${formatDate(experience.startDate, format: 'y')} – "
            "${experience.endDate != null ? formatDate(experience.endDate) : 'Now'}",
            style: TextStyle(
              fontSize: 14,
              color: context.textTheme.bodySmall?.color,
            ),
          ),
          VSizedBox4,
          Text(
            [
              experience.jobTitle ?? '',
              experience.companyName ?? '',
            ].join(' at '),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          VSizedBox8,
          Text(
            (experience.jobDescription ?? '').replaceAll('\n\n', ' '),
            style: TextStyle(
              fontSize: 15,
              color: context.textTheme.bodySmall?.color,
            ),
            // overflow: TextOverflow.ellipsis,
            // maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class FreelancerExperienceCardPlaceholder extends StatelessWidget {
  const FreelancerExperienceCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(context).rect(width: 50, height: 8),
          VSizedBox8,
          Skeleton(context).rect(width: 150, height: 14),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
        ],
      ),
    );
  }
}
