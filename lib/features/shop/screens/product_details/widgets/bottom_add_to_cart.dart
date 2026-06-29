import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/icons/circular_icon.dart';
import 'package:shopping_store/features/shop/controllers/product/cart_controller.dart';
import 'package:shopping_store/utils/constants/colors.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';

class HkBottomAddToCart extends StatelessWidget {
  const HkBottomAddToCart({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    final controller = CartController.instance;

    if (product.id.isNotEmpty) {
      controller.updateAlreadyAddedProductCount(product);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: HkSizes.defaultSpace, vertical: HkSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? HkColors.darkerGrey : HkColors.light,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(HkSizes.cardRadiusLg), topRight: Radius.circular(HkSizes.cardRadiusLg)),
      ),
      child: Obx(
            () {
          // कंडीशन चेक करें कि क्वांटिटी 0 है या उससे ज़्यादा
          final bool isQuantityZero = controller.productQuantityInCart.value == 0;

          // डायनामिक कलर्स तय करें (0 होने पर बैकग्राउंड White और टेक्स्ट Black, बढ़ने पर बैकग्राउंड Black और टेक्स्ट White)
          final Color buttonBgColor = isQuantityZero ? HkColors.white : HkColors.black;
          final Color buttonTextColor = isQuantityZero ? HkColors.black : HkColors.white;
          final Color buttonBorderColor = isQuantityZero ? HkColors.darkGrey : HkColors.black;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HkCircularIcon(
                    icon: Iconsax.minus,
                    backgroundColor: HkColors.darkGrey,
                    height: 40,
                    width: 40,
                    color: HkColors.white,
                    onPressed: () => controller.productQuantityInCart.value < 1 ? null : controller.productQuantityInCart.value -= 1,
                  ),
                  const SizedBox(
                    width: HkSizes.spaceBtwItems,
                  ),
                  Text(
                    controller.productQuantityInCart.value.toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    width: HkSizes.spaceBtwItems,
                  ),
                  HkCircularIcon(
                    icon: Iconsax.add,
                    width: 40,
                    height: 40,
                    backgroundColor: HkColors.black,
                    color: HkColors.white,
                    onPressed: () => controller.productQuantityInCart.value += 1,
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  controller.addToCart(product);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(HkSizes.md),
                    backgroundColor: buttonBgColor,
                    side: BorderSide(color: buttonBorderColor)),
                child: Row(
                  children: [
                    Icon(Iconsax.shopping_bag, size: 18, color: buttonTextColor),
                    const SizedBox(width: 8),
                    Text(
                      'Add to Cart',
                      style: TextStyle(color: buttonTextColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
