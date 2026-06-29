import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/circular_image.dart';
import '../texts/brand_title_text_with_verify_icon.dart';

// 1. BrandModel ka import add kiya
import '../../../data/modal/brandModal/brandModal.dart';

class HkBrandCard extends StatelessWidget {
  const HkBrandCard({
    super.key,
    required this.showBorder,
    this.onTap,
    this.brand,
  });

  final bool showBorder;
  final void Function()? onTap;
  final BrandModel? brand;

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);

    final String brandName = brand?.name ?? 'Unknown';
    final String brandImage = brand?.image ?? 'assets/icons/brands/nike.png';
    final String productsCount = (brand?.productCount ?? 0).toString();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 60,
        child: HkRoundedContainer(
            padding: const EdgeInsets.all(HkSizes.sm),
            showBorder: showBorder,
            backgroundColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HkCircularImage(
                  height: 35,
                  width: 35,
                  isNetworkImage: false,
                  image: brandImage,
                  backgroundColor: Colors.transparent,
                  overlayColor: dark ? HkColors.light : HkColors.dark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HkBrandTitleWithVerifyIcon(
                        title: brandName,
                        brandTextSize: TextSizes.large,
                        textColor: dark ? HkColors.light : HkColors.dark,
                      ),
                      Text(
                        '$productsCount products',
                        style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: dark ? Colors.white : Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
