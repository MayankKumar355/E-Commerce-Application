import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/personalization/controllers/address_controller.dart';
import 'package:shopping_store/utils/constants/sizes.dart';

class HkBillingAddressSection extends StatelessWidget {
  const HkBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HkSectionHeading(
          title: 'Shipping Address',
          showActionButton: true,
          buttonTitle: 'Change',
          onPressed: () => controller.selectNewAddressPopup(context),
        ),
        const SizedBox(height: HkSizes.spaceBtwItems / 2),
        Obx(() {
          final address = controller.selectedAddress.value;

          if (address.id.isEmpty) {
            return const Text('Select Address');
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map ki jagah direct dot (.) lagakar field access kiya
              Text(address.name, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              // Phone Section
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: HkSizes.spaceBtwItems),
                  Text(address.phoneNumber, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey), // Icon ko relevance ke liye change kiya
                  const SizedBox(width: HkSizes.spaceBtwItems),
                  Expanded(
                    child: Text(
                      '${address.street}, ${address.city}, ${address.state}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                    ),
                  ),
                ],
              )
            ],
          );
        })
      ],
    );
  }
}
