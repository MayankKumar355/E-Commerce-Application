import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping_store/features/shop/controllers/product/checkout_controller.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/colors.dart';

class HkPaymentTile extends StatelessWidget {
  const HkPaymentTile({super.key, required this.paymentMethod});

  final dynamic paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        // 🔥 CheckoutController ke generic map handler me direct map assign hoga
        controller.selectedPaymentMethod.value = paymentMethod;
        Get.back();
      },
      leading: HkRoundedContainer(
        width: 60,
        height: 40,
        backgroundColor: HkHelperFunctions.isDarkMode(context) ? HkColors.light : HkColors.white,
        padding: const EdgeInsets.all(HkSizes.sm),
        // 🔥 Model fields ki jagah clean dynamic Map keys ('image') use ki hai
        child: Image(image: AssetImage((paymentMethod?['image'] ?? '').toString()), fit: BoxFit.contain,),
      ),
      // 🔥 Model fields ki jagah clean dynamic Map keys ('name') use ki hai
      title: Text((paymentMethod?['name'] ?? '').toString()),
      trailing: const Icon(Iconsax.arrow_right_34),
    );
  }
}