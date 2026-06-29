


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/features/shop/screens/searchStore/searchStore.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class HkSearchContainer extends StatelessWidget {
  const HkSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = false,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: HkSizes.defaultSpace)
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => Get.to(SearchStoreScreen()),
      child: Padding(
        padding: padding,
        child: Hero(
          tag: "Search_Animation",
          child: Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.all(HkSizes.md),
              decoration: BoxDecoration(
                  color: showBackground ? dark ? HkColors.dark : HkColors.light : Colors.transparent ,
                  borderRadius: BorderRadius.circular(HkSizes.borderRadiusLg),
                  border: showBorder ? Border.all(color: HkColors.grey) : null,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.3,
                      color: Colors.grey
              )
                  ]
              ),
              child: Row(
                children: [
                  Icon(icon,color: HkColors.darkerGrey,),
                  const SizedBox(width: HkSizes.spaceBtwItems,),
                  Text(text, style: Theme.of(context).textTheme.bodySmall,)
          
                ],
              )
          ),
        ),
      ),
    );
  }
}