

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/texts/brand_title.dart';
import 'package:shopping_store/utils/constants/enums.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class HkBrandTitleWithVerifyIcon extends StatelessWidget {
  const HkBrandTitleWithVerifyIcon({super.key,
    this.textColor,
    this.maxLines = 1,
    required this.title,
    this.iconColor = HkColors.primary,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    // Brand text size switch case se dynamic handle karne ke liye
    double getFontSize() {
      switch (brandTextSize) {
        case TextSizes.small:
          return 12.0; // Figma me small standard text size
        case TextSizes.medium:
          return 14.0;
        case TextSizes.large:
          return 16.0;
        default:
          return 12.0;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: maxLines,
            textAlign: textAlign,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: textColor ?? const Color(0XFF939393),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: HkSizes.xs),
        Icon(
          Iconsax.verify5,
          color: Color(0XFF006FFF),
          size: 10,
        ),
      ],
    );
  }

}
