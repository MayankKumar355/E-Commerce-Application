import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/screens/all_products/all_products.dart';
import 'package:shopping_store/features/shop/screens/product_details/product_details.dart'; // इसे इम्पोर्ट किया गया
import 'package:shopping_store/utils/constants/sizes.dart';

import '../../../../data/modal/categoryModal/categoryModal.dart';
import '../../../../data/modal/productModal/productModal.dart';
import '../../controllers/category_controller.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return Scaffold(
      appBar: HkAppBar(
        showBackArrow: true,
        title: Text(
          category.name,
          style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 27, left: 30),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.subCategoriesList.isEmpty) {
              return const Center(child: Text("No Sub Categories Found!"));
            }

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.subCategoriesList.length,
                  itemBuilder: (context, subIndex) {
                    final subCategory = controller.subCategoriesList[subIndex];

                    return FutureBuilder<List<dynamic>>(
                      future: controller.getCategoryProducts(categoryId: subCategory.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final products = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HkSectionHeading(
                              title: subCategory.name,
                              onPressed: () {
                                Get.to(() => AllProducts(
                                  category: subCategory,
                                  products: products,
                                ));
                              },
                              showActionButton: true,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                separatorBuilder: (context, index) => const SizedBox(width: HkSizes.spaceBtwItems / 2),
                                itemBuilder: (context, index) {
                                  final productModel = ProductModel.fromJson(products[index]);

                                  // === बदलाव: यहाँ कार्ड पर क्लिक करने पर डिटेल स्क्रीन ओपन होने का लॉजिक जोड़ा गया है ===
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => ProductDetailsScreen(product: productModel));
                                    },
                                    child: HkProductCardHorizontal(product: productModel),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
