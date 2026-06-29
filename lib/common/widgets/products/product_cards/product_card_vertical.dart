import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/styles/shadows.dart';
import 'package:shopping_store/common/widgets/images/rounded_image.dart';
import 'package:shopping_store/common/widgets/texts/brand_title_text_with_verify_icon.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';

import '../../../../features/shop/controllers/product/cart_controller.dart';
import '../../../../features/shop/screens/product_details/product_details.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../custom_shapes/containers/rounded_container.dart';

// FavouriteController ko import kiya
import '../../../../features/shop/controllers/product/favourite_controller.dart';

class HkProductCardVertical extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const HkProductCardVertical({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final favoriteController =
        Get.put(FavouriteController()); // FavouriteController instance
    final dark = HkHelperFunctions.isDarkMode(context);

    int discountPercentage = 0;
    final double originalPrice = product.price;
    final double salePrice = product.salePrice;

    if (originalPrice > 0 && salePrice > 0) {
      discountPercentage =
          (((originalPrice - salePrice) / originalPrice) * 100).round();
    }

    final String thumbnailUrl =
        product.thumbnail.isNotEmpty ? product.thumbnail : HkImages.Iphone;
    final bool isNetwork = kIsWeb || product.thumbnail.startsWith('http');
    final String brandName =
        (product.brandName != null && product.brandName!.isNotEmpty)
            ? product.brandName!
            : 'Brand';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [HkShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(HkSizes.productImageRadius),
          color: dark ? HkColors.darkerGrey : Colors.blue.shade50,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(HkSizes.sm),
                decoration: BoxDecoration(
                  color: dark ? HkColors.dark : HkColors.white,
                  borderRadius:
                      BorderRadius.circular(HkSizes.productImageRadius - 4),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: HkRoundedImage(
                        height: 128,
                        width: 100,
                        imageUrl: thumbnailUrl,
                        applyImageRadius: true,
                        isNetworkImage: isNetwork,
                      ),
                    ),
                    if (salePrice > 0.0)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: HkRoundedContainer(
                          radius: HkSizes.sm,
                          backgroundColor: const Color(0xFFFFE599),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            '$discountPercentage%',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: HkColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Obx(() {
                        final isFav =
                            favoriteController.isFavourite(product.id);
                        return GestureDetector(
                          onTap: () {
                            favoriteController
                                .toggleFavouriteProduct(product.id);
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                dark ? HkColors.grey : HkColors.white,
                            child: Icon(
                              isFav ? Iconsax.heart5 : Iconsax.heart,
                              color: isFav ? Colors.red : HkColors.black,
                              size: 22,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 3),
              Padding(
                padding: const EdgeInsets.only(left: HkSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product.title.isNotEmpty
                            ? product.title
                            : 'IPhone 11 64GB',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: dark ? HkColors.white : HkColors.black,
                        ),
                      ),
                    ),
                    HkBrandTitleWithVerifyIcon(
                      title: brandName,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          if (salePrice > 0.0)
                            Padding(
                              padding: const EdgeInsets.only(left: HkSizes.sm),
                              child: Text(
                                '\$${product.price}',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(left: HkSizes.sm),
                            child: Text(
                              salePrice > 0.0
                                  ? salePrice.toString()
                                  : originalPrice.toString(),
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    final int productQuantity =
                    cartController.getProductQuantityInCart(product.id);
                    final isVariableProduct = product.productType ==
                        ProductType.variable.name ||
                        product.productType == ProductType.variable.toString();

                    return GestureDetector(
                      onTap: () {
                        if (isVariableProduct) {
                          Get.to(() => ProductDetailsScreen(product: product));
                        } else {
                          if (productQuantity > 0) {
                            final index = cartController.cartItems.indexWhere(
                                    (item) => item.productId == product.id);
                            if (index >= 0) {
                              cartController.cartItems[index].quantity += 1;
                              cartController.updateCart();
                            }
                          } else {
                            cartController.productQuantityInCart.value = 1;
                            cartController.addToCart(product);
                          }
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: HkColors.dark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(HkSizes.cardRadiusMd),
                            bottomRight:
                            Radius.circular(HkSizes.productImageRadius),
                          ),
                        ),
                        child: SizedBox(
                          width: HkSizes.iconMd * 1.2,
                          height: HkSizes.iconMd * 1.2,
                          child: Center(
                            child: (productQuantity > 0 && !isVariableProduct)
                                ? Text(
                              '$productQuantity',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                color: HkColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : const Icon(Icons.add, color: HkColors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
