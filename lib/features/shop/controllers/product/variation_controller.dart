import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping_store/common/widgets/products/product_price_text.dart';
import 'package:shopping_store/common/widgets/texts/product_title.dart';
import 'package:shopping_store/common/widgets/texts/section_heading.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';
import 'package:shopping_store/utils/constants/colors.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

import 'cart_controller.dart';
import 'images_controller.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  RxMap<String, String> selectedAttributes = <String, String>{}.obs;
  RxString variationStockStatus = ''.obs;
  final Rx<dynamic> selectedVariation = Rx<dynamic>(null);

  void onAttributeSelected(ProductModel product, String attributeName, String attributeValue) {
    try {
      selectedAttributes[attributeName] = attributeValue;
      final variations = product.productVariations ?? [];
      if (variations.isEmpty) return;
      dynamic foundVariation;
      for (var variation in variations) {
        final Map<String, dynamic> attributeValues = variation.attributeValues;
        if (_isSameAttributeValues(attributeValues, selectedAttributes)) {
          foundVariation = variation;
          break;
        }
      }
      if (foundVariation != null) {
        selectedVariation.value = foundVariation;
        final String variationImage = foundVariation.image ?? '';
        if (variationImage.isNotEmpty) {
          ImagesController.instance.selectedProductImage.value = variationImage;
        }
        final String variationId = foundVariation.id ?? '';
        if (variationId.isNotEmpty) {
          try {
            final cartController = CartController.instance;
            cartController.productQuantityInCart.value = cartController.getVariationQuantityInCart(product.id, variationId);
          } catch (e) {
            print('Error updating cart: $e');
          }
        }
        getProductVariationStockStatus();
      } else {
        selectedVariation.value = null;
        variationStockStatus.value = 'Select all attributes';
      }
    } catch (e) {
      print('Error in onAttributeSelected: $e');
      selectedVariation.value = null;
    }
  }

  bool _isSameAttributeValues(Map<String, dynamic> variationAttributes, Map<String, String> selectedAttrs) {
    try {
      if (variationAttributes.length != selectedAttrs.length) return false;
      for (final key in variationAttributes.keys) {
        if (!selectedAttrs.containsKey(key)) return false;
        final v1Value = variationAttributes[key];
        final v2Value = selectedAttrs[key];
        if (v1Value == null || v2Value == null) return false;
        String v1 = v1Value.toString().toLowerCase().replaceAll('gb', '').trim();
        String v2 = v2Value.toString().toLowerCase().replaceAll('gb', '').trim();
        if (v1 != v2) return false;
      }
      return true;
    } catch (e) {
      print('Error comparing attributes: $e');
      return false;
    }
  }

  Set<String?> getAttributesAvailabilityInVariation(List<dynamic> variations, String attributeName) {
    try {
      return variations.where((variation) {
        try {
          final Map<String, dynamic> attrs = variation.attributeValues;
          final val = attrs[attributeName]?.toString() ?? '';
          final int stock = variation.stock ?? 0;
          return val.isNotEmpty && stock > 0;
        } catch (e) {
          return false;
        }
      }).map((variation) {
        try {
          return variation.attributeValues[attributeName]?.toString();
        } catch (e) {
          return null;
        }
      }).toSet();
    } catch (e) {
      print('Error getting attributes availability: $e');
      return {};
    }
  }

  String getVariationPrice() {
    if (selectedVariation.value == null) return '';
    try {
      final double salePrice = (selectedVariation.value.salePrice ?? 0.0).toDouble();
      final double price = (selectedVariation.value.price ?? 0.0).toDouble();
      final double finalPrice = salePrice > 0 ? salePrice : price;
      return finalPrice > 0 ? finalPrice.toStringAsFixed(0) : '';
    } catch (e) {
      print('Error getting variation price: $e');
      return '';
    }
  }

  String getActualPrice() {
    if (selectedVariation.value == null) return '';
    try {
      final double price = (selectedVariation.value.price ?? 0.0).toDouble();
      return price > 0 ? price.toStringAsFixed(0) : '';
    } catch (e) {
      print('Error getting actual price: $e');
      return '';
    }
  }

  void getProductVariationStockStatus() {
    try {
      if (selectedVariation.value == null) {
        variationStockStatus.value = 'Select variation';
        return;
      }
      final int stock = selectedVariation.value.stock ?? 0;
      variationStockStatus.value = stock > 0 ? 'In Stock' : 'Out of Stock';
    } catch (e) {
      print('Error getting product variation stock status: $e');
      variationStockStatus.value = 'N/A';
    }
  }

  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = null;
  }
}