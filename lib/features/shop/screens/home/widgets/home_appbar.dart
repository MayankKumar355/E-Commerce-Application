import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/features/personalization/controllers/user_controller.dart';
import 'package:shopping_store/features/shop/controllers/product/cart_controller.dart'; // CartController इम्पोर्ट किया
import 'package:shopping_store/features/shop/screens/cart/cart.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class HkHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HkHomeAppBar({super.key});

  String getGreetingText() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning,";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon,";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening,";
    } else {
      return "Good Night,";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());

    final cartController = CartController.instance;

    final dark = HkHelperFunctions.isDarkMode(context);

    return HkAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getGreetingText(),
            style: Theme.of(context).textTheme.labelMedium!.apply(color: HkColors.grey),
          ),
          Obx((){
            if(controller.profileLoading.value){
              return Text(
                "Loading...",
                style: Theme.of(context).textTheme.headlineSmall!.apply(color: HkColors.white),
              );
            } else {
              final name = controller.user.value.fullName.trim().isEmpty
                  ? "Unknown Pro"
                  : controller.user.value.fullName;

              return Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall!.apply(color: HkColors.white),
              );
            }
          })
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => const CartScreen());
              },
              icon: const Icon(Icons.shopping_bag_outlined, color: HkColors.white, size: 28),
            ),
            Obx(() => Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: dark ? HkColors.black : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                    '${cartController.noOfCartItem.value}',
                    style: TextStyle(
                        color: dark ? HkColors.white : HkColors.dark,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
            ))
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
