import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/common/widgets/icons/circular_icon.dart';
import 'package:shopping_store/common/widgets/layouts/grid_layout.dart';
import 'package:shopping_store/common/widgets/loaders/animation_loader.dart';
import 'package:shopping_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../home/home.dart';
import '../../../../features/shop/controllers/product/favourite_controller.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouriteController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshFavourites();
    });

    return Scaffold(
      appBar: HkAppBar(
        title: Text('Wishlist', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700)),
        actions: [
          HkCircularIcon(
            icon: Iconsax.add,
            onPressed: () => Get.to(() => const HomeScreen()),
          )
        ],
      ),
      body: Obx(() {
        // Agar koi favourite nahi hai
        if (controller.favourites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(HkSizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 HkAnimationLoader(text: "No Items in Wishlist", animation:HkImages.pencilAnimation ),
                  const SizedBox(height: HkSizes.spaceBtwSections),
                  // Text(
                  //   'Your wishlist is currently empty.\nStart adding your favorite products!',
                  //   textAlign: TextAlign.center,
                  //   style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey),
                  // ),
                ],
              ),
            ),
          );
        }

        // Agar favourite products load ho rahe hain
        if (controller.favouriteProductsList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        // Real Dynamic Products
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(HkSizes.defaultSpace),
            child: HkGridLayout(
              itemCount: controller.favouriteProductsList.length,
              itemBuilder: (context, index) {
                final product = controller.favouriteProductsList[index];
                return HkProductCardVertical(product: product);
              },
            ),
          ),
        );
      }),
    );
  }
}