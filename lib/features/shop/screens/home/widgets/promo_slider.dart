import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart'; // ✅ Ye import add kiya hai
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/shimmer/shimmer_effect.dart';
import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/banner_controller.dart';

class HkPromoSlider extends StatelessWidget {
  const HkPromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    return Obx(() {
      if (controller.isLoading.value) return const HkShimmerEffect(width: double.infinity, height: 190);

      if (controller.banners.isEmpty) {
        return const Center(child: Text('No Data Found!'));
      } else {
        return Column(
          children: [
            CarouselSlider(
              items: controller.banners.map((banner) {
                final String imgUrl = banner.imageUrl;

                if (imgUrl.isEmpty) {
                  return Container(
                    width: double.infinity,
                    height: 190,
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        'Image Path is Empty!',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                return HkRoundedImage(
                  imageUrl: imgUrl,
                  isNetworkImage: kIsWeb,
                  onPressed: () => Get.toNamed(banner.targetScreen),
                );
              }).toList(),
              options: CarouselOptions(
                height: 190,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                onPageChanged: (index, reason) => controller.updatePageIndicator(index),
              ),
            ),
            const SizedBox(height: HkSizes.spaceBtwItems),
            Center(
              child: Obx(
                    () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < controller.banners.length; i++)
                      HkCircularContainer(
                        width: 20,
                        height: 4,
                        margin: const EdgeInsets.only(right: 10),
                        backgroundColor: (controller.carouselCurrentIndex.value == i)
                            ? HkColors.primary
                            : HkColors.grey,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    });
  }
}
