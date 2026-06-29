import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/circular_image.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/texts/brand_title_text_with_verify_icon.dart';
import '../../../../data/modal/brandModal/brandModal.dart';
import '../../../../data/modal/productModal/productModal.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';

class AllBrands extends StatelessWidget {
  const AllBrands({
    super.key,
    this.category,
    required this.brand, // Changed to required BrandModel
    this.product,
  });

  final dynamic category;
  final BrandModel? brand; // Changed to BrandModel
  final List<ProductModel>? product;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HkAppBar(
        showBackArrow: true,
        title: Text(
          brand?.name ?? "All Brands",
          style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(HkSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand info section
              GestureDetector(
                onTap: () => print("Brand clicked"),
                child: HkRoundedContainer(
                  showBorder: true,
                  padding: const EdgeInsets.all(HkSizes.sm),
                  backgroundColor: Colors.transparent,
                  child: Row(
                    children: [
                      HkCircularImage(
                        height: 35,
                        width: 35,
                        isNetworkImage: true,
                        image: brand?.image ?? '',
                        backgroundColor: Colors.transparent,
                        overlayColor: dark ? HkColors.light : HkColors.dark,
                      ),
                      const SizedBox(width: HkSizes.spaceBtwItems / 2),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HkBrandTitleWithVerifyIcon(
                              title: brand?.name ?? "Brand",
                              brandTextSize: TextSizes.large,
                              textColor: dark ? HkColors.light : HkColors.dark,
                            ),
                            Text(
                              '${brand?.productCount ?? 0} products',
                              style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: dark ? Colors.white : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Sorting dropdown
              DropdownButtonFormField(
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                items: ['Name', 'Lower Price', 'Higher Price', 'Sale', 'Newest']
                    .map((filter) => DropdownMenuItem(value: filter, child: Text(filter)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: HkSizes.spaceBtwSections),
              // Products grid
              HkGridLayout(
                itemCount: product?.length ?? 0,
                itemBuilder: (context, index) {
                  if (product == null || product!.isEmpty) {
                    return const SizedBox();
                  }
                  final currentProduct = product![index];
                  return HkProductCardVertical(product: currentProduct);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}