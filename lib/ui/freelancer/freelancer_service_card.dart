import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/models/freelancer_service.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/skeleton.dart';

class FreelancerServiceCard extends StatelessWidget {
  final FreelancerService service;
  const FreelancerServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.title ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          VSizedBox4,
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
