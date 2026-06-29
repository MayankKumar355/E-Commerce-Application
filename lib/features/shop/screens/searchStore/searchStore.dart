import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/common/widgets/image_text/vertical_image_text.dart';
import 'package:shopping_store/common/widgets/layouts/grid_layout.dart';
import 'package:shopping_store/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/controllers/product/cart_controller.dart';
import 'package:shopping_store/features/shop/screens/all_products/all_products.dart';
import 'package:shopping_store/features/shop/screens/brand/all_brands.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../data/modal/productModal/productModal.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/product/brand_controller.dart';
import '../brand/brand_products.dart';

class SearchStoreScreen extends StatelessWidget {
  const SearchStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxString searchText = ''.obs;
    final controller = Get.put(BrandController());
    final categoryController = Get.put(CategoryController());
    final bool dark = HkHelperFunctions.isDarkMode(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const HkAppBar(
        showBackArrow: true,
        title: Text("Search", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(HkSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "Search_Animation",
              child: Material(
                color: Colors.transparent,
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.search_normal),
                    hintText: 'Search in Store',
                  ),
                  onChanged: ((value) => searchText.value = value.toLowerCase()),
                ),
              ),
            ),
            const SizedBox(height: HkSizes.spaceBtwSections),
            Obx(() {
              if (searchText.value.isEmpty) {
                return Column(
                  children: [
                    HkSectionHeading(
                      title: "Brands",
                      onPressed: () => Get.to(const BrandProducts()),
                    ),
                    const SizedBox(height: HkSizes.spaceBtwItems),
                    Obx(() {
                      if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
                      if (controller.allBrands.isEmpty) return const Center(child: Text('No Brands Found!'));

                      final brands = controller.allBrands.take(10).toList();
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: brands.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: HkSizes.spaceBtwItems,
                          crossAxisSpacing: HkSizes.spaceBtwItems,
                          mainAxisExtent: 95,
                        ),
                        itemBuilder: (context, index) {
                          final brand = brands[index];
                          return GestureDetector(
                            onTap: () async {
                              Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                              try {
                                final List<ProductModel> brandProducts = await controller.getBrandProducts(brandId: brand.id ?? '');
                                Get.back();
                                Get.to(() => AllBrands(brand: brand, product: brandProducts));
                              } catch (e) {
                                Get.back();
                              }
                            },
                            child: HkVerticalImageText(
                              image: brand.image ?? HkImages.nikeLogo,
                              title: brand.name ?? 'Brand',
                              textColor: dark ? HkColors.white : HkColors.black,
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: HkSizes.spaceBtwSections),
                    Obx(() {
                      if (categoryController.isLoading.value) return const Center(child: CircularProgressIndicator());
                      if (categoryController.allCategories.isEmpty) return const Center(child: Text('No Categories Found!'));

                      final categories = categoryController.allCategories.take(20).toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HkSectionHeading(title: 'Categories', onPressed: () {}),
                          const SizedBox(height: HkSizes.spaceBtwItems),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: HkSizes.spaceBtwItems),
                                child: ListTile(
                                  onTap: () async {
                                    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                                    try {
                                      final List<ProductModel> fetchedProducts = await controller.getBrandProducts(brandId: category.id ?? '');
                                      Get.back();
                                      Get.to(() => AllProducts(category: category, products: fetchedProducts));
                                    } catch (e) {
                                      Get.back();
                                    }
                                  },
                                  leading: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.transparent,
                                    child: CachedNetworkImage(
                                      imageUrl: category.image ?? '',
                                      errorWidget: (context, url, error) => Image.asset(HkImages.clothIcon),
                                    ),
                                  ),
                                  title: Text(category.name ?? ''),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }
              // VIEW 2: Search Results
              else {
                return FutureBuilder<List<ProductModel>>(
                  future: CartController.instance.AllProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No products found!"));

                    final filteredProducts = snapshot.data!.where((p) => p.title!.toLowerCase().
                    contains(searchText.value)).toList();
                    if (filteredProducts.isEmpty) return const Center(child: Text("No match found."));

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      itemBuilder: (_, index) => HkProductCardHorizontal(product: filteredProducts[index]),
                    );
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}