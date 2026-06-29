


import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shopping_store/features/shop/controllers/product/cart_controller.dart';
import 'package:shopping_store/features/shop/screens/order/widgets/orders_list.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../personalization/controllers/user_controller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Scaffold(

      /// AppBar
      appBar: HkAppBar(
        showBackArrow: true,
        title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall)
      ),
      body: const Padding(
        padding: EdgeInsets.all(HkSizes.defaultSpace),

        /// Orders
        child: HkOrdersListItems()
      )
    );
  }
}
