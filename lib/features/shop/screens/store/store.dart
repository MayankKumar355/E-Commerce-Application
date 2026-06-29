import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/common/widgets/appbar/tabbar.dart';
import 'package:shopping_store/common/widgets/brands/brand_card.dart';
import 'package:shopping_store/common/widgets/brands/brand_show_case.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:shopping_store/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:shopping_store/features/shop/controllers/product/brand_controller.dart';
import 'package:shopping_store/features/shop/controllers/product/cart_controller.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../data/modal/brandModal/brandModal.dart';
import '../../../../data/modal/productModal/productModal.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../brand/brand_products.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    final brandController = Get.put(BrandController());
    final cartController = Get.put(CartController());

    final List<String> tabCategories = ["Sport", "Furniture", "Electronics", "Clothes", "Other"];

    brandController.getBrandsForCategory(tabCategories.first);
    cartController.filterProductsByCategory(tabCategories.first);

    return DefaultTabController(
      length: tabCategories.length,
      child: Scaffold(
        backgroundColor: dark ? HkColors.black : HkColors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 300,
                pinned: true,
                floating: true,
                backgroundColor: dark ? HkColors.black : HkColors.white,
                flexibleSpace: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          HkPrimaryHeaderContainer(
                            height: 135,
                            child: HkAppBar(
                              title: Text("Store",
                                  style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              actions: const [HkCartCounterIcon()],
                            ),
                          ),
                          const Positioned(
                            bottom: -20,
                            left: HkSizes.defaultSpace,
                            right: HkSizes.defaultSpace,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: HkSearchContainer(
                                  text: 'Search in Store',
                                  showBackground: true,
                                  padding: EdgeInsets.zero),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: HkSizes.defaultSpace,
                            right: HkSizes.defaultSpace,
                            top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Brands",
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: dark ? HkColors.white : Colors.black)),
                            GestureDetector(
                              onTap: () => Get.to(BrandProducts()),
                              child: Text("View All",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: const Color(0XFF0857A0))),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 22),
                        child: SizedBox(
                          height: 70.0,
                          child: Obx(() {
                            if (brandController.isBrandsLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (brandController.categorySpecificBrands.isEmpty) {
                              return const Center(child: Text("No Brands Found"));
                            }
                            return ListView.separated(
                              separatorBuilder: (context, index) => const SizedBox(width: HkSizes.spaceBtwItems),
                              shrinkWrap: true,
                              itemCount: brandController.categorySpecificBrands.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final brand = brandController.categorySpecificBrands[index];

                                // Convert Map to BrandModel
                                final brandModel = BrandModel(
                                  id: brand.id,
                                  name: brand.name ?? '',
                                  image: brand.image ?? '',
                                  productCount: brand.productCount ?? 0,
                                );

                                return HkBrandCard(
                                  showBorder: true,
                                  onTap: () => print("${brand.name} clicked!"),
                                  brand: brandModel,
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: HkTabBar(
                  tabs: tabCategories.map((category) => Tab(child: Text(category))).toList(),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              final TabController tabController = DefaultTabController.of(context)!;
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  String selectedCategory = tabCategories[tabController.index];
                  brandController.getBrandsForCategory(selectedCategory);
                  cartController.filterProductsByCategory(selectedCategory);
                  cartController.filteredProducts.refresh();
                }
              });
              return TabBarView(
                physics: const BouncingScrollPhysics(),
                children: tabCategories.map((category) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 7, right: 7),
                      child: Obx(() {
                        if (brandController.isBrandsLoading.value) {
                          return const Center(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: CircularProgressIndicator()));
                        }
                        return Column(
                          children: [
                            ...brandController.categorySpecificBrands.take(2).map((brand) {
                              return FutureBuilder(
                                future: brandController.getBrandProducts(brandId: brand.id ?? '', limit: 3),
                                builder: (context, snapshot) {
                                  List<String> productImages = [];
                                  if (snapshot.hasData && snapshot.data != null) {
                                    productImages = snapshot.data!
                                        .map((product) => product.thumbnail ?? '')
                                        .where((img) => img.isNotEmpty)
                                        .toList()
                                        .take(3)
                                        .toList();
                                  }
                                  final brandModel = BrandModel(
                                    id: brand.id,
                                    name: brand.name ?? '',
                                    image: brand.image ?? '',
                                    productCount: brand.productCount ?? 0,
                                  );
                                  return HkBrandShowcase(
                                    images: productImages,
                                    brand: brandModel,
                                  );
                                },
                              );
                            }).toList(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  HkSectionHeading(title: 'You might like', onPressed: () {}),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text("view All",
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: const Color(0XFF0857A0)))),
                                ],
                              ),
                            ),
                            Obx(() {
                              if (cartController.filteredProducts.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Center(child: Text("No products in this category")),
                                );
                              }
                              return HkGridLayout(
                                itemCount: cartController.filteredProducts.length > 4
                                    ? 4
                                    : cartController.filteredProducts.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisExtent: 250,
                                itemBuilder: (_, index) {
                                  final product = ProductModel.fromJson(cartController.filteredProducts[index]);
                                  return HkProductCardVertical(product: product);
                                },
                              );
                            }),
                          ],
                        );
                      }),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}