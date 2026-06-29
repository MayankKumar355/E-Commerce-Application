import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  RxString selectedProductImage = ''.obs;

  List<String> getAllProductImages(ProductModel product) {
    Set<String> images = {};
    String thumbnail = product.thumbnail;
    images.add(thumbnail);
    if (selectedProductImage.value.isEmpty) {
      selectedProductImage.value = thumbnail;
    }
    images.addAll(product.images ?? []);
    if (product.productVariations != null && product.productVariations!.isNotEmpty) {
      images.addAll(
        product.productVariations!.map((variation) => (variation.image ?? '').toString()),
      );
    }
    images.removeWhere((url) => url.isEmpty);
    return images.toList();
  }

  void updateSelectedImage(String imageUrl) {
    selectedProductImage.value = imageUrl;
  }

  void showEnlargedImage(String image) {
    Get.to(
      fullscreenDialog: true,
          () => Dialog.fullscreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: HkSizes.defaultSpace * 2,
                  horizontal: HkSizes.defaultSpace),
              child: image.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.red,
                ),
              )
                  : const Icon(Icons.image_not_supported, size: 40),
            ),
            const SizedBox(height: HkSizes.spaceBtwSections),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Close')),
              ),
            )
          ],
        ),
      ),
    );
  }
}