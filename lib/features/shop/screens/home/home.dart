import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/layouts/grid_layout.dart';
import 'package:shopping_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/screens/all_products/all_products.dart';
import 'package:shopping_store/features/shop/screens/home/widgets/getAllProductsScreen.dart';
import 'package:shopping_store/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:shopping_store/features/shop/screens/home/widgets/home_categories.dart';
import 'package:shopping_store/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:shopping_store/features/shop/screens/product_details/product_details.dart';
import 'package:shopping_store/utils/constants/colors.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../data/modal/productModal/productModal.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/category_controller.dart';
import '../../../../features/shop/controllers/product/cart_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(CategoryController());

    final cartController = Get.put(CartController());
    final dark = HkHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? HkColors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const HkPrimaryHeaderContainer(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: HkHomeAppBar(),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 31),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Popular Categories',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: HkSizes.spaceBtwItems),
                            HkHomeCategories(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  bottom: -20,
                  left: HkSizes.defaultSpace,
                  right: HkSizes.defaultSpace,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: HkSearchContainer(
                      text: 'Search in Store',
                      showBackground: true,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.all(HkSizes.defaultSpace),
              child: Column(
                children: [
                  HkPromoSlider(),
                  const SizedBox(height: HkSizes.spaceBtwSections),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HkSectionHeading(title: "Popular Products"),
                      GestureDetector(
                        onTap: () {
                          final List<ProductModel> parsedProducts = cartController.popularProducts.map((rawProduct) {
                            return rawProduct is ProductModel
                                ? rawProduct
                                : ProductModel.fromJson(rawProduct);
                          }).toList();

                          Get.to(() => GetAllProductsScreenAllProducts(
                            products: parsedProducts,
                          ));
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            fontSize: 14,
                            color: dark ? HkColors.white : const Color(0XFF0857A0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HkSizes.spaceBtwItems),
                  Obx(() {
                    if (cartController.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(HkSizes.defaultSpace),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (cartController.popularProducts.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Popular Products Found!",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    final catController = Get.find<CategoryController>();
                    for (var cat in catController.allCategories) {
                      debugPrint("======> CATEGORY NAME: ${cat.name} | ID: ${cat.id ?? cat.id.toString()}");
                    }
                    return
                      HkGridLayout(
                        itemCount: cartController.popularProducts.length > 4 ? 4 : cartController.popularProducts.length,
                        itemBuilder: (context, index) {
                          final reversedIndex = cartController.popularProducts.length - 1 - index;
                          final rawProduct = cartController.popularProducts[reversedIndex];

                          final productModel = rawProduct is ProductModel
                              ? rawProduct
                              : ProductModel.fromJson(rawProduct);

                          return InkWell(
                            onTap: () {
                              Get.to(ProductDetailsScreen(product: productModel));
                            },
                            child: HkProductCardVertical(product: productModel),
                          );
                        },
                      );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
