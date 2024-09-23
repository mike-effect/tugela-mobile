import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/ui/freelancer/freelancer_experience_card.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio.dart';
import 'package:tugela/ui/freelancer/freelancer_portfolio_card.dart';
import 'package:tugela/ui/freelancer/freelancer_service_card.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/app_avatar.dart';
import 'package:tugela/widgets/layout/section_header.dart';

class ProfileFreelancer extends StatelessWidget {
  final Freelancer freelancer;
  const ProfileFreelancer({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    const chipStyle = TextStyle(height: 1.2, fontSize: 13);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppAvatar(
              radius: 55,
              imageUrl: freelancer.profileImage,
            ),
            HSizedBox20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    freelancer.fullname ?? '',
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  VSizedBox4,
                  Text(
                    freelancer.title ?? '',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: context.textTheme.bodySmall?.color,
                    ),
                  ),
                  // if ((_company.tagline ?? '').isNotEmpty) ...[
                  VSizedBox8,
                  if ((freelancer.website ?? '').isNotEmpty)
                    RawChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        (freelancer.website ?? '')
                            .replaceAll(RegExp(r'^http(s)?://(www.)?'), ''),
                        style: const TextStyle(height: 1),
                      ),
                    ),
                  // ],
                ],
              ),
            ),
          ],
        ),
        if ((freelancer.bio ?? '').isNotEmpty) ...[
          VSizedBox24,
          Text(
            (freelancer.bio ?? ''),
            style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
          ),
        ],
        if ((freelancer.location ?? '').isNotEmpty) ...[
          VSizedBox8,
          Text(
            (freelancer.location ?? ''),
            style: context.textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
        ],
        VSizedBox12,
        SizedBox(
          height: 40,
          child: ListView(
            // spacing: 7,
            // runSpacing: 7,
            scrollDirection: Axis.horizontal,
            children: [
              ...(freelancer.skills).map((v) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIconsFill.heart,
                          size: 15,
                          color: context.textTheme.bodySmall?.color,
                        ),
                        HSizedBox4,
                        Text(
                          v.name ?? '',
                          style: chipStyle,
                          textScaler: maxTextScale(context, 1.07),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const Divider(height: 48),
        if (freelancer.services.isNotEmpty) ...[
          const SectionHeader(
            title: "Services",
            // list: freelancer.services,
          ),
          ...freelancer.services.map((data) {
            return FreelancerServiceCard(service: data);
          }),
          const Divider(height: 48),
        ],
        if (freelancer.workExperiences.isNotEmpty) ...[
          const SectionHeader(
            title: "Work Experience",
            // list: freelancer.workExperiences,
          ),
          ...freelancer.workExperiences.map((data) {
            return FreelancerExperienceCard(experience: data);
          }),
          const Divider(height: 48),
        ],
        if (freelancer.portfolioItem.isNotEmpty) ...[
          SectionHeader(
            title: "Portfolio",
            // list: freelancer.portfolioItem,
            onViewAll: (context) {
              push(
                context: context,
                builder: (_) => FreelancerPortfolio(mapId: freelancer.id ?? ""),
                rootNavigator: true,
              );
            },
          ),
          ...freelancer.portfolioItem.map((data) {
            return FreelancerPortfolioCard(portfolio: data);
          })
        ],
      ],
    );
  }
}
