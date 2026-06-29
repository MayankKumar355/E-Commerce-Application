import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/features/shop/controllers/product/images_controller.dart';
import 'package:shopping_store/features/shop/controllers/product/variation_controller.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';

import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class HkProductImageSlider extends StatelessWidget {
  const HkProductImageSlider({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final imagesController = Get.put(ImagesController());
    final variationController = VariationController.instance;

    return Stack(
      children: [
        Obx(() {
          final selectedImage = imagesController.selectedProductImage.value;
          final imagePath = selectedImage.isNotEmpty
              ? selectedImage
              : (variationController.selectedVariation.value != null
              ? (variationController.selectedVariation.value.image ?? product.thumbnail)
              : product.thumbnail);

          return GestureDetector(
            onLongPress: () => imagesController.showEnlargedImage(imagePath),
            child: Container(
              height: 400,
              padding: const EdgeInsets.all(HkSizes.productImageRadius),
              color: HkColors.white,
              child: Center(
                // ✅ FIXED: Puraane Image widget ko HkRoundedImage se replace kiya kIsWeb ke sath
                child: HkRoundedImage(
                  height: 400,
                  imageUrl: imagePath,
                  isNetworkImage: kIsWeb,
                  applyImageRadius: false,
                ),
              ),
            ),
          );
        }),
        Positioned(
          top: 20,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          left: HkSizes.defaultSpace,
          bottom: 20,
          child: SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: product.images?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(width: HkSizes.spaceBtwItems),
              itemBuilder: (_, index) {
                final image = product.images?[index] ?? '';
                return Obx(() {
                  final isSelected = imagesController.selectedProductImage.value == image;
                  return Container(
                    decoration: BoxDecoration(
                      color: HkHelperFunctions.isDarkMode(context)
                          ? Colors.white
                          : HkColors.light,
                      borderRadius: BorderRadius.circular(HkSizes.md),
                      border: Border.all(
                        color: isSelected ? HkColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: HkRoundedImage(
                      width: 80,
                      padding: const EdgeInsets.all(HkSizes.sm),
                      isNetworkImage: kIsWeb,
                      imageUrl: image,
                      onPressed: () => imagesController.selectedProductImage.value = image,
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
