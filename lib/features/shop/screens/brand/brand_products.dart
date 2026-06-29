import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/common/widgets/brands/brand_card.dart';
import 'package:shopping_store/common/widgets/layouts/grid_layout.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/controllers/product/brand_controller.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import '../../../../data/modal/productModal/productModal.dart';
import 'all_brands.dart';

// 1. BrandModel ka sahi import add kiya
import '../../../../data/modal/brandModal/brandModal.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({
    super.key,
    this.brand,
  });

  final BrandModel? brand;

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final currentBrand = brand ??
        (brandController.allBrands.isNotEmpty
            ? brandController.allBrands.first
            : null);

    return Scaffold(
      appBar: HkAppBar(
        showBackArrow: true,
        title: Text(
          currentBrand?.name ?? "Brand",
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 28, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HkSectionHeading(title: "Brands", showActionButton: false),
              const SizedBox(height: HkSizes.spaceBtwItems),
              Obx(() {
                if (brandController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (brandController.allBrands.isEmpty) {
                  return const Center(child: Text("No Brands Available"));
                }

                return HkGridLayout(
                  itemCount: brandController.allBrands.length,
                  mainAxisExtent: 60,
                  itemBuilder: (context, index) {
                    final brandItem = brandController.allBrands[index];

                    return HkBrandCard(
                      showBorder: true,
                      onTap: () async {
                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        );

                        try {
                          final List<ProductModel> brandProducts = await brandController.getBrandProducts(
                            brandId: brandItem.id ?? '',
                          );

                          Get.back();

                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllBrands(
                                  brand: brandItem,
                                  product: brandProducts,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          Get.back();
                          print("Error loading products: $e");
                        }
                      },
                      brand: brandItem,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
