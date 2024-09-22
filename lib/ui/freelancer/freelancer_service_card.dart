import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/freelancer/freelancer_services_create.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/widgets/layout/bottom_sheet.dart';
import 'package:tugela/widgets/layout/skeleton.dart';

class FreelancerServiceCard extends StatelessWidget {
  final FreelancerService service;
  const FreelancerServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final isOwner = provider.user?.accountType == AccountType.freelancer &&
        provider.user?.freelancer?.id == service.freelancer;
    return Container(
      padding: ContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                service.title ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Space,
              if (isOwner)
                InkWell(
                  child: Icon(
                    Icons.more_horiz,
                    color: context.textTheme.bodySmall?.color,
                  ),
                  onTap: () {
                    showAppBottomSheet(
                      context: context,
                      physics: const NeverScrollableScrollPhysics(),
                      children: (context) {
                        return [
                          Container(
                            padding: ContentPadding,
                            margin: ContentPadding,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.greyBackgroundColor(context),
                            ),
                            child: Text(
                              service.title ?? '',
                              style: TextStyle(
                                color: context.textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text("Edit"),
                            onTap: () async {
                              Navigator.pop(context);
                              push(
                                context: context,
                                rootNavigator: true,
                                builder: (_) => FreelancerServiceCreate(
                                  service: service,
                                ),
                              );
                            },
                          ),
                          ListTile(
                            textColor: context.colorScheme.error,
                            title: const Text("Delete"),
                            onTap: () {
                              delete(context);
                            },
                          ),
                        ];
                      },
                    );
                  },
                ),
            ],
          ),
          if (!isOwner) VSizedBox4,
          Text(
            (service.description ?? '').replaceAll('\n\n', ' '),
            style: TextStyle(
              fontSize: 14,
              color: context.textTheme.bodySmall?.color,
            ),
            // overflow: TextOverflow.ellipsis,
            // maxLines: 3,
          ),
          VSizedBox4,
          if (service.startingPrice != null || service.deliveryTime != null)
            Text(
              [
                'Starting at ${formatAmount(service.startingPrice, customFormat: NumberFormat.compactSimpleCurrency(name: service.currency), factor: 1)}',
                if (service.deliveryTime != null)
                  'Delivery time: ${service.deliveryTime}',
              ].join(' ・ '),
              style: const TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  void delete(BuildContext context) async {
    final freelancerProvider = context.read<FreelancerProvider>();
    Navigator.pop(context);
    await ProviderRequest.api(
      context: context,
      loadingMessage: "Deleting",
      request: freelancerProvider.deleteFreelancerService(service.id!),
      onSuccess: (context, res) async {
        context.read<UserProvider>().getUserMe();
        freelancerProvider.getServices(
          mapId: freelancerProvider.user?.freelancer?.id ?? '',
        );
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
          content: Text("Deleted"),
        ));
      },
    );
  }
}

class FreelancerServiceCardPlaceholder extends StatelessWidget {
  const FreelancerServiceCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(context).rect(width: 150, height: 14),
          VSizedBox8,
          Skeleton(context).rect(height: 8),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
          VSizedBox4,
          Skeleton(context).rect(height: 8),
          VSizedBox4,
          Skeleton(context).rect(width: 100, height: 8),
        ],
      ),
    );
  }
}
