import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping_store/common/widgets/texts/brand_title_text_with_verify_icon.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

import '../../../../data/modal/productModal/productModal.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/image_strings.dart';

class HkProductCardHorizontal extends StatelessWidget {
  const HkProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);

    String rawThumbnail = product.thumbnail.isNotEmpty ? product.thumbnail : HkImages.Iphone;
    if (rawThumbnail.startsWith('assets/assets/')) {
      rawThumbnail = rawThumbnail.replaceFirst('assets/assets/', 'assets/');
    }

    final String thumbnailUrl = rawThumbnail;
    final bool isNetwork = kIsWeb || thumbnailUrl.startsWith('http://') || thumbnailUrl.startsWith('https://');
    final discount = product.discountPercentage;

    return Container(
      width: 310,
      height: 125,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HkSizes.productImageRadius),
          color: dark ? HkColors.darkerGrey : HkColors.lightContainer),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Thumbnail Image Layout
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: HkRoundedContainer(
              height: 120,
              width: 120,
              padding: const EdgeInsets.all(HkSizes.sm),
              backgroundColor: dark ? HkColors.dark : Colors.white,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(HkSizes.productImageRadius),
                      child: isNetwork
                          ? CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (context, url, error) => Icon(
                          Icons.shopping_bag_outlined,
                          color: dark ? HkColors.white : HkColors.dark,
                          size: 32,
                        ),
                      )
                          : Image.asset(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.shopping_bag_outlined,
                          color: dark ? HkColors.white : HkColors.dark,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  if (discount > 0)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: HkRoundedContainer(
                        radius: HkSizes.sm,
                        backgroundColor: HkColors.secondary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(horizontal: HkSizes.sm, vertical: HkSizes.xs),
                        child: Text('$discount%', style: const TextStyle(color: HkColors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),

                  const Positioned(
                    right: 4,
                    top: 4,
                    child: Icon(Iconsax.heart, color: Colors.black, size: 20),
                  )
                ],
              ),
            ),
          ),

          /// Details Content Frame
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: HkSizes.md, vertical: HkSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.title,
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: HkSizes.spaceBtwItems / 4),
                      HkBrandTitleWithVerifyIcon(title: product.brandName ?? 'Brand'),
                    ],
                  ),
                  Row(
                    children: [
                      // Dynamic Price Section
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.salePrice > 0) ...[
                              Text(
                                '\$${product.salePrice} ',
                                style: GoogleFonts.nunito(fontSize: 14, color: dark ? HkColors.white : HkColors.black, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '\$${product.price}',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ] else
                              Text(
                                '\$${product.price}',
                                style: GoogleFonts.nunito(fontSize: 14,
                                    color: dark ? HkColors.white : HkColors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: HkColors.dark,
                          borderRadius: BorderRadius.only(
                            topLeft:  Radius.circular(HkSizes.cardRadiusMd),
                            bottomRight: Radius.circular(HkSizes.productImageRadius),
                          ),
                        ),
                        child: const SizedBox(
                          width: HkSizes.iconLg * 1.5,
                          height: HkSizes.iconLg * 1.5,
                          child: Center(
                            child: Icon(Iconsax.add, color: HkColors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
