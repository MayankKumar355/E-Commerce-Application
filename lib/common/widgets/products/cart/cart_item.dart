import 'package:flutter/foundation.dart'; // 🟢 kIsWeb ke liye import kiya
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../texts/brand_title_text_with_verify_icon.dart';
import '../../texts/product_title.dart';

class HkCartItem extends StatelessWidget {
  const HkCartItem({super.key, required this.cartItem, this.showAttributes = true});

  final dynamic cartItem;
  final bool showAttributes;

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    final String imagePath = cartItem['image'] ?? '';

    final bool isNetwork = kIsWeb || imagePath.startsWith('http://') || imagePath.startsWith('https://');

    final Map<dynamic, dynamic> attributes = cartItem['selectedVariation'] != null
        ? Map<dynamic, dynamic>.from(cartItem['selectedVariation'])
        : {};

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(HkSizes.sm),
          decoration: BoxDecoration(
            color: dark ? HkColors.darkerGrey : HkColors.light,
            borderRadius: BorderRadius.circular(8),
          ),
          child: isNetwork && imagePath.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(HkImages.shoeIcon),
          )
              : Image.asset(
            imagePath.isNotEmpty ? imagePath : HkImages.shoeIcon,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: HkSizes.spaceBtwItems),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HkBrandTitleWithVerifyIcon(title: cartItem['brandName'] ?? ''),
                ],
              ),
              HkProductTitleText(title: cartItem['title'] ?? '', maxLines: 1),

              if (showAttributes && attributes.isNotEmpty) ...[
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: attributes.entries.map((entry) {
                      return TextSpan(
                        children: [
                          TextSpan(
                            text: "${entry.key}: ",
                            style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0XFF939393)
                            ),
                          ),
                          TextSpan(
                            text: "${entry.value}   ",
                            style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: dark ? HkColors.white : HkColors.black
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        )
      ],
    );
  }
}
