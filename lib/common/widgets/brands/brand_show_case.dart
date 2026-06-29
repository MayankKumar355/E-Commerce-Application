import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/shimmer/shimmer_effect.dart';
import 'package:shopping_store/features/shop/screens/brand/all_brands.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_card.dart';

import '../../../data/modal/brandModal/brandModal.dart';
import '../../../features/shop/controllers/product/brand_controller.dart';

class HkBrandShowcase extends StatelessWidget {
  const HkBrandShowcase({
    super.key,
    required this.images,
    required this.brand,
  });

  final List<String> images;
  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final dark = HkHelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: () async {
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        try {
          final brandProducts = await brandController.getBrandProducts(
            brandId: brand.id ?? '',
          );

          Get.back();

          Get.to(() => AllBrands(
            brand: brand,
            product: brandProducts,
          ));

        } catch (e) {
          Get.back();
          print("Error: $e");
        }
      },
      child: HkRoundedContainer(
        height: 184,
        width: 320,
        showBorder: true,
        borderColor: const Color(0XFFBEBEBE),
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.only(bottom: HkSizes.spaceBtwItems),
        padding: const EdgeInsets.all(HkSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HkBrandCard(
              showBorder: false,
              brand: brand,
            ),
            const SizedBox(height: 8),
            Row(
              children: images
                  .map((image) => brandTopProductImageWidget(dark, image))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget brandTopProductImageWidget(bool dark, String image) {
    return Expanded(
      child: HkRoundedContainer(
        height: 81,
        width: 100,
        backgroundColor: dark ? HkColors.darkerGrey : HkColors.light,
        margin: const EdgeInsets.only(right: HkSizes.sm),
        padding: const EdgeInsets.all(HkSizes.md),
        child: image.startsWith('http')
            ? CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: image,
          progressIndicatorBuilder: (context, url, progress) =>
          const HkShimmerEffect(width: 100, height: 100),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )
            : Image.network(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
