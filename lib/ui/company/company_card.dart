import 'package:flutter/material.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/company.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/company/company_details.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/app_image.dart';

class CompanyCard extends StatelessWidget {
  final Company company;
  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        push(
          context: context,
          builder: (_) => CompanyDetails(company: company),
          rootNavigator: true,
        );
      },
      child: Container(
        padding: ContentPadding,
        decoration: BoxDecoration(
          borderRadius: AppTheme.cardBorderRadius,
          border: Border.all(
            color: context.inputTheme.enabledBorder!.borderSide.color,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppImage(
                  width: 58,
                  height: 58,
                  borderRadius: AppTheme.avatarBorderRadius,
                  imageUrl: company.logo,
                ),
                HSizedBox12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name ?? 'Company',
                        style: context.textTheme.titleLarge?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      if ((company.location ?? '').isNotEmpty) ...[
                        VSizedBox4,
                        Text(
                          company.location ?? '',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: context.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if ((company.description ?? '').isNotEmpty) ...[
              VSizedBox12,
              Text(
                company.description ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textScaler: TextScaler.noScaling,
              ),
            ],
            // if (company.industry?.name != null) ...[
            //   VSizedBox12,
            //   Text(
            //     company.industry?.name ?? '',
            //     overflow: TextOverflow.ellipsis,
            //     maxLines: 2,
            //     textScaler: TextScaler.noScaling,
            //     style: TextStyle(
            //       fontSize: 13.5,
            //       color: context.textTheme.bodySmall?.color,
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
