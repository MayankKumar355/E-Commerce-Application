import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';
import 'package:shopping_store/common/widgets/loaders/animation_loader.dart';
import 'package:shopping_store/features/personalization/controllers/address_controller.dart';
import 'package:shopping_store/features/personalization/screens/address/add_new_address.dart';
import 'package:shopping_store/features/personalization/screens/address/widgets/single_address.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import '../../../../common/widgets/loader/circular_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());

    return Scaffold(
      appBar: HkAppBar(
        showBackArrow: true,
        title: Text(
          'Addresses',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(HkSizes.defaultSpace),
          child: Obx(
                () => FutureBuilder(
              key: Key(controller.refreshData.value.toString()),
              future: controller.getAllUserAddresses(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: HkCircularLoader());
                }

                if (!snapshot.hasData || snapshot.data == null || (snapshot.data as List).isEmpty) {
                  return  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: HkAnimationLoader(text: "'No Address Found! Please add a new address.'",
                          animation:HkImages.pencilAnimation)
                    ),
                  );
                }
                final addresses = snapshot.data!;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: HkSizes.spaceBtwItems),
                  itemBuilder: (context, index) {
                    final currentAddress = addresses[index];
                    return HkSingleAddress(
                      address: currentAddress,
                      onTap: () => controller.selectAddress(currentAddress),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        backgroundColor: HkColors.primary,
        child: const Icon(
          Iconsax.add,
          color: HkColors.white,
        ),
      ),
    );
  }
}
