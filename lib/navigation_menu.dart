


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/features/personalization/screens/profile/person.dart';
import 'package:shopping_store/features/shop/screens/store/store.dart';
import 'package:shopping_store/features/shop/screens/wishlist/wishlist.dart';
import 'package:shopping_store/utils/constants/colors.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

import 'features/shop/screens/home/home.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = HkHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        ()=> NavigationBar(
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (value) => controller.selectedIndex.value = value,
          backgroundColor: dark ? HkColors.dark : HkColors.light,
          indicatorColor: dark ? HkColors.light.withOpacity(0.1) : HkColors.dark.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'Store'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'personProfile')
          ],
        ),
      ),
      body: Obx(()=>  controller.screens[controller.selectedIndex.value]),
    );
  }
}


class NavigationController extends GetxController{

  final RxInt selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const FavouriteScreen(),
    const Person()
  ];
}