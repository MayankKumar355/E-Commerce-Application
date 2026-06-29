import 'package:flutter/material.dart';
import 'package:shopping_store/common/widgets/brands/brand_show_case.dart';
import 'package:shopping_store/common/widgets/shimmer/boxes_shimmer.dart';
import 'package:shopping_store/common/widgets/shimmer/list_tile_shimmer.dart';
import 'package:shopping_store/utils/constants/sizes.dart';
import '../../../../../data/modal/brandModal/brandModal.dart';
import '../../../controllers/product/brand_controller.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});

  final dynamic category;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;

    final String catId = (category is Map)
        ? (category['id'] ?? '').toString()
        : (category?.id ?? '').toString();

    return FutureBuilder<List<BrandModel>>(
      future: controller.getBrandsForCategory(catId),
      builder: (context, snapshot) {
        const loader = Column(
          children: [
            HkListTileShimmer(),
            SizedBox(height: HkSizes.spaceBtwItems),
            HkBoxesShimmer(),
            SizedBox(height: HkSizes.spaceBtwItems),
          ],
        );

        if (snapshot.connectionState == ConnectionState.waiting)
          return loader;
        if (snapshot.hasError)
          return const Center(child: Text('Something went wrong.'));
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Center(child: Text('No Brands Found!'));
        }

        final brands = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];

            return FutureBuilder<List<dynamic>>(
              future: controller.getBrandProducts(
                  brandId: (brand.id ?? '').toString(), limit: 3),
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting)
                  return loader;
                if (productSnapshot.hasError)
                  return const Center(child: Text('Something went wrong.'));
                if (!productSnapshot.hasData ||
                    productSnapshot.data == null ||
                    productSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No Products Found!'));
                }

                final products = productSnapshot.data!;

                // Map to BrandModel
                final brandModel = BrandModel(
                  id: brand.id,
                  name: brand.name ?? '',
                  image: brand.image ?? '',
                  productCount: brand.productCount ?? 0,
                );

                return HkBrandShowcase(
                  brand: brandModel,
                  images: products.map((e) {
                    if (e is Map) {
                      return (e['thumbnail'] ?? '').toString();
                    }
                    return (e?.thumbnail ?? '').toString();
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}