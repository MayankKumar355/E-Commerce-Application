import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart'; // इसे इम्पोर्ट करें
import 'package:shopping_store/features/shop/screens/sub_category/sub_categories.dart';
import 'package:shopping_store/utils/constants/colors.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import '../../../controllers/category_controller.dart';

class HkHomeCategories extends StatelessWidget {
  const HkHomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    final controller = Get.put(CategoryController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator(color: HkColors.white)),
        );
      }
      if (controller.featuredCategories.isEmpty) {
        return SizedBox(
          height: 80,
          child: Center(
            child: Text(
              'No Categories Found',
              style: Theme.of(context).textTheme.labelMedium!.apply(color: HkColors.white),
            ),
          ),
        );
      }
      return SizedBox(
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.featuredCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final category = controller.featuredCategories[index];

            return GestureDetector(
              onTap: () {
                controller.fetchSubCategoriesAndGo(category);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: HkSizes.spaceBtwItems),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(HkSizes.sm),
                      decoration: BoxDecoration(
                        color: dark ? HkColors.dark : HkColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: category.image,
                          fit: BoxFit.cover,
                          // color: dark ? HkColors.white : HkColors.dark,
                          placeholder: (context, url) => const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) {
                            return Icon(
                              Icons.category,
                              color: dark ? HkColors.white : HkColors.dark,
                              size: 20,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: HkSizes.spaceBtwItems / 2),
                    SizedBox(
                      width: 56,
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium!.apply(
                          color: HkColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
