import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping_store/common/widgets/images/circular_image.dart';
import 'package:shopping_store/common/widgets/products/product_price_text.dart';
import 'package:shopping_store/common/widgets/texts/brand_title_text_with_verify_icon.dart';
import 'package:shopping_store/common/widgets/texts/product_title.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';
import 'package:shopping_store/features/shop/controllers/product/cart_controller.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';

class HkProductMetaData extends StatelessWidget {
  const HkProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    final controller = CartController.instance;

    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final String brandName =
        (product.brandName != null && product.brandName!.isNotEmpty)
            ? product.brandName!
            : 'Brand';
    final String brandImage =
        product.images.isNotEmpty ? product.images.first : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            /// Sale Tag
            if (salePercentage != null) ...[
              HkRoundedContainer(
                radius: HkSizes.sm,
                backgroundColor: HkColors.secondary.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                    horizontal: HkSizes.sm, vertical: HkSizes.xs),
                child: Text(
                  '$salePercentage%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: HkColors.black),
                ),
              ),
            ],
            const SizedBox(width: HkSizes.spaceBtwItems),
            // if (product.productType == ProductType.single.toString() && product.salePrice > 0)
            Text(
              '\$${product.price.toStringAsFixed(0)}',
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.black,
                decorationThickness: 1,
              ),
            ),
            Text(
              controller.getProductPrice(product),
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Share options
            const SizedBox(width: 90),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.share,
                  size: 18, color: dark ? Colors.white : Colors.black),
            ),
          ],
        ),
        const SizedBox(height: HkSizes.spaceBtwItems / 1.5),

        /// Title
        Text(
          product.title,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: HkSizes.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            const HkProductTitleText(title: 'Status'),
            const SizedBox(width: HkSizes.spaceBtwItems),
            Text(controller.getProductStockStatus(product.stock),
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: HkSizes.spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            HkCircularImage(
              image: brandImage,
              width: 32,
              height: 32,
              isNetworkImage: brandImage.startsWith('http'),
              overlayColor: dark ? HkColors.white : HkColors.black,
            ),
            HkBrandTitleWithVerifyIcon(
              title: brandName,
              brandTextSize: TextSizes.medium,
              textColor: dark ? Colors.white : Colors.black,
            ),
          ],
        )
      ],
    );
  }
}
