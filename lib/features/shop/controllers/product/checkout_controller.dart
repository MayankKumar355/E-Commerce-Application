import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/features/shop/screens/checkout/widgets/payment_tile.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();


  final Rx<dynamic> selectedPaymentMethod = Rx<dynamic>({
    'name': 'Paypal',
    'image': HkImages.paypal
  });

  void selectPayment(dynamic paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
    Get.back();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(HkSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HkSectionHeading(title: 'Select Payment Method'),
              const SizedBox(height: HkSizes.spaceBtwSections),

              InkWell(
                onTap: () => selectPayment({'name': 'Cash on delivery', 'image': HkImages.successfulPaymentIcon}),
                child: HkPaymentTile(paymentMethod: {'name': 'Cash on delivery', 'image': HkImages.successfulPaymentIcon}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),
              InkWell(
                onTap: () => selectPayment({'name': 'Paypal', 'image': HkImages.paypal}),
                child: HkPaymentTile(paymentMethod: {'name': 'Paypal', 'image': HkImages.paypal}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              InkWell(
                onTap: () => selectPayment({'name': 'Google Pay', 'image': HkImages.googlePay}),
                child: HkPaymentTile(paymentMethod: {'name': 'Google Pay', 'image': HkImages.googlePay}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              InkWell(
                onTap: () => selectPayment({'name': 'Apple Pay', 'image': HkImages.applePay}),
                child: HkPaymentTile(paymentMethod: {'name': 'Apple Pay', 'image': HkImages.applePay}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              InkWell(
                onTap: () => selectPayment({'name': 'VISA', 'image': HkImages.visa}),
                child: HkPaymentTile(paymentMethod: {'name': 'VISA', 'image': HkImages.visa}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              InkWell(
                onTap: () => selectPayment({'name': 'Master Card', 'image': HkImages.masterCard}),
                child: HkPaymentTile(paymentMethod: {'name': 'Master Card', 'image': HkImages.masterCard}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              InkWell(
                onTap: () => selectPayment({'name': 'Paytm', 'image': HkImages.paytm}),
                child: HkPaymentTile(paymentMethod: {'name': 'Paytm', 'image': HkImages.paytm}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              InkWell(
                onTap: () => selectPayment({'name': 'Paystack', 'image': HkImages.paystack}),
                child: HkPaymentTile(paymentMethod: {'name': 'Paystack', 'image': HkImages.paystack}),
              ),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),

              InkWell(
                onTap: () => selectPayment({'name': 'Credit Card', 'image': HkImages.creditCard}),
                child: HkPaymentTile(paymentMethod: {'name': 'Credit Card', 'image': HkImages.creditCard}),
              ),
              const SizedBox(height: HkSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}