import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shopping_store/common/widgets/images/circular_image.dart';
import 'package:shopping_store/common/widgets/list_tile/settings_menu_title.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/personalization/screens/address/add_new_address.dart';
import 'package:shopping_store/features/personalization/screens/address/address.dart';
import 'package:shopping_store/features/personalization/screens/profile/profile.dart';
import 'package:shopping_store/features/shop/screens/cart/cart.dart';
import 'package:shopping_store/features/shop/screens/order/order.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';

import '../../../../data/modal/userModal/authModal.dart';
import '../../controllers/user_controller.dart';

class Person extends StatelessWidget {
  const Person({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                HkPrimaryHeaderContainer(height: 100, child: Container()),
                Positioned(
                    bottom: -50,
                    right: 0,
                    left: 0,
                    child: Center(
                        child: HkCircularImage(
                          image: HkImages.user,
                          height: 100,
                          width: 100,
                        )
                    )
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 25, right: 15),
              child: Obx(() {
                if (controller.profileLoading.value) {
                  return const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Loading Profile..."),
                  );
                }

                final name = controller.user.value.fullName.trim().isEmpty
                    ? "Unknown Pro"
                    : controller.user.value.fullName;

                final email = controller.user.value.email.trim().isEmpty
                    ? "user@example.com"
                    : controller.user.value.email;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    name,
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  subtitle: Text(
                    email,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black54),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        Get.to(() => const ProfileScreen());
                      },
                      icon: const Icon(Iconsax.edit)),
                );
              }),
            ),
            const SizedBox(height: 15,),
            const Padding(
              padding: EdgeInsets.only(left: 25, right: 15),
              child: HkSectionHeading(
                title: "Account Setting",
                showActionButton: false,
              ),
            ),
            const SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 15),
              child: HkSettingsMenuTile(
                  onTap: () => Get.to(const UserAddressScreen()),
                  icon: Iconsax.safe_home,
                  title: "My Addresses",
                  subTitle: "Set shopping delivery addresses"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 15),
              child: HkSettingsMenuTile(
                // 🔥 FIXED: CartScreen par navigate karne ke liye Get.to lagaya
                  onTap: () => Get.to(() => const CartScreen()),
                  icon: Iconsax.shopping_cart,
                  title: "My Cart",
                  subTitle: "Add, remove products and move to checkout"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 15),
              child: HkSettingsMenuTile(
                // 🔥 FIXED: OrdersScreen par navigate karne ke liye Get.to lagaya
                  onTap: () => Get.to(() => const OrdersScreen()),
                  icon: Iconsax.bag_tick,
                  title: "My Orders",
                  subTitle: "In-progress and Completed Orders"),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 15),
              child: SizedBox(
                height: 48,
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      final localStorage = GetStorage();
                      localStorage.remove('TOKEN');
                      localStorage.remove('USER_DATA');
                      controller.user.value = UserModel.empty();
                    },
                    child: const Text("Logout")
                ),
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
