import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/bindings/general_bindings.dart';
import 'package:shopping_store/features/personalization/screens/profile/person.dart';
import 'package:shopping_store/features/shop/screens/brand/brand_products.dart';
import 'package:shopping_store/features/shop/screens/home/home.dart';
import 'package:shopping_store/features/shop/screens/order/order.dart';
import 'package:shopping_store/features/shop/screens/store/store.dart';
import 'package:shopping_store/navigation_menu.dart';
import 'package:shopping_store/routes/app_routes.dart';
import 'package:shopping_store/routes/routes.dart';
import 'package:shopping_store/utils/theme/theme.dart';

import 'features/personalization/screens/address/address.dart';
import 'features/shop/screens/searchStore/searchStore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: HkAppTheme.lightTheme,
        darkTheme: HkAppTheme.darkTheme,
        initialBinding: GeneralBindings(),
        getPages: AppRoutes.pages,
     //   initialRoute: HkRoutes.onBoarding
        home: HomeScreen()
    );
  }
}