import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping_store/common/widgets/appbar/appbar.dart';

import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../data/modal/categoryModal/categoryModal.dart'; // CategoryModel का इम्पोर्ट जोड़ा
import '../../../../data/modal/productModal/productModal.dart';
import '../../../../utils/constants/sizes.dart';

class AllProducts extends StatelessWidget {
  // === बदलाव: यहाँ कंस्ट्रक्टर में CategoryModel और प्रॉडक्ट्स लिस्ट को एक्सेप्ट किया गया है ===
  const AllProducts({super.key, required this.category, required this.products});

  final CategoryModel category;
  final List<dynamic> products;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: HkAppBar(
        showBackArrow: true,
        title: Text(category.name, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700),),
      ),
      body: SingleChildScrollView(
          child:Padding(
              padding: const EdgeInsets.only(top: 27,left: 30,right: 27),
              child: Column(
                  children: [
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.sort),
                      ),
                      items: ['Name', 'Lower Price', 'Higher Price', 'Sale', 'Newest'].map((filter){
                        return DropdownMenuItem(
                            value: filter,
                            child: Text(filter));
                      }).toList(),
                      onChanged: (value) {
                        print("Selected: $value");
                      },
                    ),
                    const SizedBox(height: HkSizes.spaceBtwItems),
                    HkGridLayout(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final productModel = ProductModel.fromJson(products[index]);
                          return HkProductCardVertical(product: productModel);
                        })
                  ]
              )
          )
      ),
    );
  }
}
