import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/screens/product_details/widgets/bottom_add_to_cart.dart';
import 'package:shopping_store/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:shopping_store/features/shop/screens/product_details/widgets/product_details_image_slider.dart';
import 'package:shopping_store/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/cart_controller.dart';
import '../checkout/checkout.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    cartController.updateAlreadyAddedProductCount(product);

    return Scaffold(
      bottomNavigationBar: SafeArea(child: HkBottomAddToCart(product: product)),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            HkProductImageSlider(product: product),
            Padding(
              padding: const EdgeInsets.all(HkSizes.defaultSpace),
              child: Column(
                children: [
                  HkProductMetaData(product: product),
                  const SizedBox(height: 8),
                  HkProductAttributes(product: product),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const CheckoutScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("CheckOut",
                          style: GoogleFonts.nunito(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const HkSectionHeading(
                      title: "Description", showActionButton: false),
                  const SizedBox(height: 9),
                  ReadMoreText(
                    product.description.isNotEmpty
                        ? product.description
                        : "No description available for this product.",
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'show more',
                    trimExpandedText: "less",
                    moreStyle: GoogleFonts.nunito(
                        fontWeight: FontWeight.w400, fontSize: 14),
                    lessStyle: GoogleFonts.nunito(
                        fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
