


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shopping_store/common/widgets/list_tile/settings_menu_title.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/screens/order/order.dart';

import '../../../../common/widgets/images/circular_image.dart';
import '../../../../common/widgets/list_tile/user_profile_tile.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../shop/controllers/category_controller.dart';
import '../../controllers/user_controller.dart';
import '../address/address.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

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
              padding: const EdgeInsets.only(top: 40,left: 25,right: 15),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Mayank Kumar",
                  style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                subtitle: Text(
                  "MayankKumar123@gmail.com",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black),
                ),
                trailing: IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
                }, icon: Icon(Iconsax.edit)),
              ),
            ),

            //body
            Padding(
              padding: const EdgeInsets.all(HkSizes.defaultSpace),
              child: Column(
                children: [
                  /// Account Settings
                  const HkSectionHeading(title: 'Account Settings'),
                  const SizedBox(height: HkSizes.spaceBtwItems,),

                  HkSettingsMenuTile(icon: Iconsax.safe_home, title: 'My Addresses',
                    subTitle: 'Set shopping delivery address',onTap: ()=> Get.to(()=> const UserAddressScreen()),),
                  HkSettingsMenuTile(icon: Iconsax.shopping_cart, title: 'My Cart', subTitle: 'Add, remove products and move to checkout',onTap: (){},),
                  HkSettingsMenuTile(icon: Iconsax.bag_tick, title: 'My Orders', subTitle: 'In-progress and Completed Orders',onTap: ()=> Get.to(()=> const OrdersScreen()),),
                  // const SizedBox(height: HkSizes.spaceBtwItems,),
                  // HkSettingsMenuTile(icon: Iconsax.document_upload, title: 'Load Data', subTitle: 'Upload Data to your Cloud Firebase',onTap: (){},),
                  // HkSettingsMenuTile(icon: Iconsax.location, title: 'Geolocation', subTitle: 'Set recommendation based on location',onTap: (){},
                  //   trailing: Switch(value: true, onChanged: (value) {},),),
                  // HkSettingsMenuTile(icon: Iconsax.security_user, title: 'Safe Mode', subTitle: 'Search result is safe for all ages',onTap: (){},
                  //   trailing: Switch(value: false, onChanged: (value) {},),),
                  // HkSettingsMenuTile(icon: Iconsax.image, title: 'HD Image Quality', subTitle: 'Set image quality to be seen',onTap: (){},
                  //   trailing: Switch(value: false, onChanged: (value) {},),),
                  const SizedBox(height: HkSizes.spaceBtwSections,),

                  /// Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(onPressed: () {}, child: const Text('Logout'),),
                  ),
                  const SizedBox(height: HkSizes.spaceBtwSections ,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


