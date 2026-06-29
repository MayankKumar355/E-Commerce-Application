import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/features/shop/controllers/product/variation_controller.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';

import '../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../common/widgets/products/product_price_text.dart';
import '../../../../../common/widgets/texts/product_title.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class HkProductAttributes extends StatefulWidget {
  const HkProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  State<HkProductAttributes> createState() => _HkProductAttributesState();
}

class _HkProductAttributesState extends State<HkProductAttributes> {
  late VariationController variationController;

  Map<String, String> getStorageDisplayMap() {
    if (widget.product.productVariations != null && widget.product.productVariations!.isNotEmpty) {
      String variationTitle = widget.product.productVariations!.first.name?.toLowerCase() ?? '';
      if (variationTitle.contains('iphone') || variationTitle.contains('mobile')) {
        return {
          '64': '64GB',
          '256': '256GB',
          '512': '512GB',
        };
      }
    }
    String productType = widget.product.title?.toLowerCase() ?? '';
    if (productType.contains('iphone') || productType.contains('mobile')) {
      return {
        '64': '64GB',
        '256': '256GB',
        '512': '512GB',
      };
    } else {
      // अन्य
      return {
        'l': 'L',
        'm': 'M',
        'x': 'X',
      };
    }
  }

  Map<String, String> storageDisplayMap = {};

  @override
  void initState() {
    super.initState();
    variationController = Get.put(VariationController());
    variationController.resetSelectedAttributes();

    // जब भी initState में हो, मैप सेट कर दें
    storageDisplayMap = getStorageDisplayMap();
  }

  String getDisplayValue(String? value, String? attributeName) {
    if (value == null) return '';
    final name = attributeName?.toLowerCase() ?? '';
    if (name == 'storage') {
      final cleanValue = value.toLowerCase().replaceAll('gb', '').replaceAll('mb', '').trim();
      return storageDisplayMap[cleanValue] ?? '${value}';
    }
    return value;
  }

  Color getColorFromName(String name) {
    final colorLower = name.toLowerCase();
    switch (colorLower) {
      case 'white': return Colors.white;
      case 'black': return Colors.black;
      case 'grey': case 'gray': return Colors.grey.shade400;
      case 'red': return Colors.red;
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
      case 'yellow': return Colors.yellow;
      case 'purple': return Colors.purple;
      case 'orange': return Colors.orange;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HkHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HkRoundedContainer(
          backgroundColor: dark ? HkColors.darkerGrey : HkColors.grey,
          padding: const EdgeInsets.all(HkSizes.md),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const HkSectionHeading(title: 'Variation'),
                    const SizedBox(width: HkSizes.spaceBtwItems),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final salePrice = variationController.getVariationPrice();
                          final actualPrice = variationController.getActualPrice();
                          return Row(
                            children: [
                              const HkProductTitleText(title: 'Price : ', smallSize: true),
                              if (actualPrice.isNotEmpty)
                                Text(
                                  '\$$actualPrice',
                                  style: Theme.of(context).textTheme.titleSmall!.apply(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              const SizedBox(width: HkSizes.spaceBtwItems),
                              HkProductPriceText(price: salePrice.isNotEmpty ? salePrice : 'N/A'),
                            ],
                          );
                        }),
                        Obx(() {
                          return Row(
                            children: [
                              const HkProductTitleText(title: 'Stock : ', smallSize: true),
                              Text(
                                variationController.variationStockStatus.value.isEmpty
                                    ? 'Select variation'
                                    : variationController.variationStockStatus.value,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          );
                        }),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.topLeft,
                child: HkProductTitleText(
                  title: widget.product.description.isEmpty
                      ? 'This is a product of ${widget.product.title}'
                      : widget.product.description,
                  smallSize: true,
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: HkSizes.spaceBtwItems),
        ...(widget.product.productAttributes?.map((attribute) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HkSectionHeading(title: attribute.name ?? 'Attribute'),
              const SizedBox(height: HkSizes.spaceBtwItems / 2),
              Obx(() {
                final availableValues = variationController.getAttributesAvailabilityInVariation(
                  widget.product.productVariations ?? [],
                  attribute.name ?? '',
                );
                final isColorAttribute = attribute.name?.toLowerCase() == 'color';
                return Wrap(
                  spacing: 8,
                  children: (attribute.values ?? []).map((value) {
                    final isAvailable = availableValues.contains(value);
                    final isSelected = variationController.selectedAttributes[attribute.name] == value;
                    if (isColorAttribute) {
                      final colorValue = value?.toLowerCase() ?? '';
                      final containerColor = getColorFromName(colorValue);
                      return GestureDetector(
                        onTap: isAvailable
                            ? () {
                          variationController.onAttributeSelected(
                            widget.product,
                            attribute.name ?? '',
                            value ?? '',
                          );
                        }
                            : null,
                        child: Opacity(
                          opacity: isAvailable ? 1.0 : 0.5,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: containerColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? HkColors.primary
                                    : (colorValue == 'white' ? Colors.grey.shade600 : Colors.transparent),
                                width: isSelected ? 3 : (colorValue == 'white' ? 1.5 : 0),
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                              Icons.check,
                              color: colorValue == 'white' ? Colors.black : Colors.white,
                              size: 20,
                            )
                                : null,
                          ),
                        ),
                      );
                    }
                    return HkChoiceChip(
                      text: getDisplayValue(value, attribute.name),
                      selected: isSelected,
                      onSelected: isAvailable
                          ? (selected) {
                        if (selected) {
                          variationController.onAttributeSelected(
                            widget.product,
                            attribute.name ?? '',
                            value ?? '',
                          );
                        }
                      }
                          : null,
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: HkSizes.spaceBtwItems),
            ],
          );
        }).toList() ?? []),
      ],
    );
  }
}