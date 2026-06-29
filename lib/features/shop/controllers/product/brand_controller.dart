import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import '../../../../data/modal/brandModal/brandModal.dart';
import '../../../../data/modal/productModal/productModal.dart';
import '../../../../data/repositories/userRepositories/brandRepositories.dart';
import 'cart_controller.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  final BrandRepository _brandRepository = BrandRepository();

  RxBool isLoading = false.obs;
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  RxList<BrandModel> featuredBrands = <BrandModel>[].obs;

  RxBool isBrandsLoading = false.obs;
  RxList<BrandModel> categorySpecificBrands = <BrandModel>[].obs;

  @override
  void onInit() {
    fetchBrands();
    super.onInit();
  }

  Future<void> fetchBrands() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _brandRepository.fetchAllBrands(),
        _brandRepository.fetchFeaturedBrands(),
      ]);

      final brands = results[0];
      final featured = results[1];

      if (brands.isNotEmpty) {
        allBrands.assignAll(brands);
      }

      if (featured.isNotEmpty) {
        featuredBrands.assignAll(featured);
      }

    } catch (e) {
      HkHelperFunctions.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString().replaceAll('Exception:', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<BrandModel>> getBrandsForCategory(String categoryName) async {
    try {
      isBrandsLoading.value = true;
      categorySpecificBrands.clear();

      final brands = await _brandRepository.getBrandsForCategory(categoryName, allBrands);
      final List<BrandModel> sourceList = brands.isNotEmpty ? brands : allBrands;

      if (sourceList.isNotEmpty) {
        final List<BrandModel> localFiltered = sourceList.where((brandObj) {
          final String bName = (brandObj.name ?? '').toString().toLowerCase().trim();
          final String cat = categoryName.toLowerCase().trim();

          if (cat == 'sport') {
            return ["nike", "adidas", "jordan", "jorden", "sparx", "bata"].contains(bName);
          } else if (cat == 'clothes') {
            return ["puma", "zara"].contains(bName);
          } else if (cat == 'furniture') {
            return ["furniture", "wood", "ikea", "herman-miller"].contains(bName);
          } else if (cat == 'electronics') {
            return ["apple", "samsung", "sony", "acer", "kenwood", "iphone"].contains(bName);
          }
          return false;
        }).toList();

        categorySpecificBrands.assignAll(localFiltered);
        featuredBrands.assignAll(localFiltered);
      }

      return categorySpecificBrands;
    } catch (e) {
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    } finally {
      isBrandsLoading.value = false;
    }
  }

  @override
  Future<List<ProductModel>> getBrandProducts({required String brandId, int limit = -1}) async {
    try {
      final cartController = Get.find<CartController>();
      final List<ProductModel> products = [];

      final selectedBrand = allBrands.firstWhereOrNull((b) => b.id == brandId);
      final String targetBrandName = (selectedBrand?.name ?? '').toLowerCase().trim();

      for (var rawProduct in cartController.popularProducts) {
        if (rawProduct is Map<String, dynamic>) {
          String productBrandName = '';

          if (rawProduct['Brand'] != null && rawProduct['Brand'] is Map) {
            productBrandName = (rawProduct['Brand']['Name'] ?? rawProduct['Brand']['name'] ?? '').toString();
          } else if (rawProduct['brand'] != null && rawProduct['brand'] is Map) {
            productBrandName = (rawProduct['brand']['name'] ?? rawProduct['brand']['Name'] ?? '').toString();
          } else if (rawProduct['brandName'] != null) {
            productBrandName = rawProduct['brandName'].toString();
          } else if (rawProduct['brand_name'] != null) {
            productBrandName = rawProduct['brand_name'].toString();
          } else if (rawProduct['brand'] != null && rawProduct['brand'] is String) {
            productBrandName = rawProduct['brand'].toString();
          }

          productBrandName = productBrandName.toLowerCase().trim();

          if (productBrandName == targetBrandName && targetBrandName.isNotEmpty) {
            products.add(ProductModel.fromJson(rawProduct));
          }
        }
      }

      if (limit > 0 && products.length > limit) {
        return products.sublist(0, limit);
      }

      return products;

    } catch (e) {
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }
}
