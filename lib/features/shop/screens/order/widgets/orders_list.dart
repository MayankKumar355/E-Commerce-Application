import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping_store/common/widgets/loaders/animation_loader.dart';
import 'package:shopping_store/features/shop/controllers/product/order_controller.dart';
import 'package:shopping_store/navigation_menu.dart';
import 'package:shopping_store/utils/constants/colors.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import '../../../../../data/modal/orderModal/orderModal.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../controllers/product/cart_controller.dart';

class HkOrdersListItems extends StatelessWidget {
  const HkOrdersListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());
    Get.put(CartController());

    return FutureBuilder<List<OrderModel>>(
        future: controller.fetchUserOrders(),
        builder: (context, snapshot) {
          final emptyWidget = HkAnimationLoader(
            text: 'Whoops! No Orders Yet!',
            animation: HkImages.orderCompletedAnimation,
            showAction: true,
            actionText: "Let's fill it",
            onActionPressed: () => Get.off(() => const NavigationMenu()),
          );

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return emptyWidget;
          }

          final orders = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(
              height: HkSizes.spaceBtwItems,
            ),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return HkRoundedContainer(
                padding: const EdgeInsets.all(HkSizes.md),
                showBorder: true,
                backgroundColor: dark ? HkColors.dark : HkColors.light,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.ship),
                        const SizedBox(
                          width: HkSizes.spaceBtwItems / 2,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                order.orderStatusText,
                                style: Theme.of(context).textTheme.bodyLarge!.apply(color: HkColors.primary, fontWeightDelta: 1),
                              ),
                              Text(
                                order.formattedOrderDate,
                                style: Theme.of(context).textTheme.headlineSmall,
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Iconsax.arrow_right_34,
                              size: HkSizes.iconSm,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: HkSizes.spaceBtwItems,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Iconsax.tag),
                              const SizedBox(
                                width: HkSizes.spaceBtwItems / 2,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Order',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                    Text(
                                      order.id,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Iconsax.calendar),
                              const SizedBox(
                                width: HkSizes.spaceBtwItems / 2,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Shipping Date',
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                    Text(
                                      order.formattedDeliveryDate,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
