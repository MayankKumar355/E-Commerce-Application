import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';

import '../../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../../data/modal/productModal/productModal.dart';
import '../../../../../utils/constants/sizes.dart';

class GetAllProductsScreenAllProducts extends StatelessWidget {
  const GetAllProductsScreenAllProducts({super.key, this.products = const <ProductModel>[]});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final RxList<ProductModel> displayedProducts = List<ProductModel>.from(products).obs;
    final RxString selectedFilter = 'Name'.obs;

    void applyFilterAndSort(String filter) {
      selectedFilter.value = filter;

      if (filter == 'Name') {
        displayedProducts.assignAll(products);
        displayedProducts.sort((a, b) => (a.title ?? '').toLowerCase().compareTo((b.title ?? '').toLowerCase()));

      } else if (filter == 'Lower Price') {
        displayedProducts.assignAll(products);
        displayedProducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));

      } else if (filter == 'Higher Price') {
        displayedProducts.assignAll(products);
        displayedProducts.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));

      } else if (filter == 'Sale') {
        final saleItems = products.where((product) => (product.salePrice ?? 0) > 0).toList();

        if (saleItems.isEmpty) {
          displayedProducts.assignAll(products);
          displayedProducts.sort((a, b) => (b.salePrice ?? 0).compareTo(a.salePrice ?? 0));
        } else {
          displayedProducts.assignAll(saleItems);
        }

      } else if (filter == 'Newest') {
        displayedProducts.assignAll(products);
        displayedProducts.sort((a, b) => (b.id ?? '').compareTo(a.id ?? ''));
      }
    }

    applyFilterAndSort('Name');

    return Scaffold(
      appBar: HkAppBar(
        showBackArrow: true,
        title: Text(
          "Popular Products",
          style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 27, left: 30, right: 27),
          child: Column(
            children: [
              Obx(() => DropdownButtonFormField<String>(
                value: selectedFilter.value,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.sort),
                ),
                items: ['Name', 'Lower Price', 'Higher Price', 'Sale', 'Newest']
                    .map((filter) {
                  return DropdownMenuItem<String>(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    applyFilterAndSort(value);
                  }
                },
              )),
              const SizedBox(height: HkSizes.spaceBtwItems),

              Obx(() {
                if (displayedProducts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "No products found for this filter!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }

                return HkGridLayout(
                  itemCount: displayedProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayedProducts[index];
                    return HkProductCardVertical(product: product);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
