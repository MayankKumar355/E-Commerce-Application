import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../data/modal/addressModal/addressModal.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class HkSingleAddress extends StatelessWidget {
  const HkSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
  });

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = address.selectedAddress;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(HkSizes.md),
        margin: const EdgeInsets.only(bottom: HkSizes.spaceBtwItems),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HkSizes.cardRadiusLg),
          color: isSelected ? HkColors.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? HkColors.primary : HkColors.grey,
          ),
        ),
        child: Stack(
          children: [
            // Selected Tick Icon
            if (isSelected)
              const Positioned(
                right: 0,
                top: 0,
                child: Icon(Iconsax.tick_circle5, color: HkColors.primary),
              ),

            // Address Details Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. address['name'] ki jagah address.name use karein
                Text(
                  address.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HkSizes.sm / 2),

                // 3. address['phoneNumber'] ki jagah address.phoneNumber
                Text(
                  address.phoneNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HkSizes.sm / 2),

                // 4. Baki saare string fields ko bhi dot (.) se call karein
                Text(
                  '${address.street}, ${address.city}, ${address.state}, ${address.postalCode}, ${address.country}',
                  softWrap: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
