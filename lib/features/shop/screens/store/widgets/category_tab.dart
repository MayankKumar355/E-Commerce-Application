import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/layouts/grid_layout.dart';
import 'package:shopping_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/controllers/category_controller.dart';
import 'package:shopping_store/features/shop/screens/store/widgets/category_brands.dart';
import '../../../../../utils/constants/sizes.dart';

class HkCategoryTab extends StatelessWidget {
  const HkCategoryTab({super.key, required this.category});

  final dynamic category;

  @override

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(HkSizes.defaultSpace),
        child: Column(
          children: [
            /// Brands
            CategoryBrands(category: category),
            const SizedBox(height: HkSizes.spaceBtwItems,),

            /// Products (FutureBuilder)
            FutureBuilder(
                future: controller.getCategoryProducts(categoryId: category['id']?.toString() ?? ''),
                builder: (context, snapshot) {

                  if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text('No Data Found!'));
                  }

                  final products = snapshot.data as List;
                  return Column(
                    children: [
                      HkSectionHeading(
                        title: 'You might like',
                        showActionButton: true,
                        onPressed: () => Get.to(() => {}
                        ), // Yahan sahi screen name dein
                      ),
                      const SizedBox(height: HkSizes.spaceBtwItems,),

                      HkGridLayout(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return HkProductCardVertical(product: products[index]);
                        },
                      ),
                      const SizedBox(height: HkSizes.spaceBtwSections,),
                    ],
                  );
                }
            ),
          ],
        ),
      ),
    );
  }}