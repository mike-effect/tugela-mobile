import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/utils/spacing.dart';

class SectionHeader<T> extends StatelessWidget {
  final String title;
  final Function(BuildContext context)? onViewAll;
  final List<T> list;
  final EdgeInsets? padding;
  final int maxLength;
  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.list = const [],
    this.padding,
    this.maxLength = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.cinzel().copyWith(
              fontSize: 17,
              height: 1,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
            ),
          ),
          Space,
          if (list.length > maxLength)
            GestureDetector(
              onTap: () {
                onViewAll?.call(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: context.theme.dividerColor.withOpacity(0.4),
                  ),
                ),
                child: const Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
