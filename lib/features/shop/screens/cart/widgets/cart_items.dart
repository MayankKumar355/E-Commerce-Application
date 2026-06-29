import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/products/product_price_text.dart';
import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/cart_controller.dart';

class HkCartItems extends StatelessWidget {
  const HkCartItems({
    super.key,
    this.showAddRemoveButtons = true,
    this.isCheckoutScreen = false,
  });

  final bool showAddRemoveButtons;
  final bool isCheckoutScreen;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Obx(() {
      if (cartController.cartItems.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(HkSizes.spaceBtwSections),
            child: Text('Your cart is empty!'),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: HkSizes.spaceBtwSections),
        itemCount: cartController.cartItems.length,
        itemBuilder: (_, index) {
          final item = cartController.cartItems[index];

          return Column(
            children: [
              HkCartItem(
                cartItem: item.toJson(),
                showAttributes: isCheckoutScreen,
              ),
              if (showAddRemoveButtons) ...[
                const SizedBox(height: HkSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 70),
                        HkProductQuantityWithAddRemoveButton(
                          quantity: item.quantity,
                          add: () => cartController.addOneToCart(item),
                          remove: () => cartController.removeOneFromCart(item),
                        ),
                      ],
                    ),
                    HkProductPriceText(
                      price: ((item.price ?? 0.0) * item.quantity).toStringAsFixed(2),
                    ),
                  ],
                )
              ]
            ],
          );
        },
      );
    });
  }
}
