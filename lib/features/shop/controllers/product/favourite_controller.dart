import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shopping_store/data/modal/productModal/productModal.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/local_storage/storage_utility.dart';

import 'cart_controller.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  final favourites = <String, bool>{}.obs;
  final favouriteProductsList = <ProductModel>[].obs;

  // CartController se popularProducts access kar rahe hain
  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    initFavourites();
  }

  Future<void> initFavourites() async {
    final json = await HkLocalStorage.instance().readData('favourites');
    if (json != null) {
      final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
      favourites.assignAll(
        storedFavourites.map((key, value) => MapEntry(key, value as bool)),
      );
    }
    loadFavouriteProducts();
  }

  bool isFavourite(String productId) {
    return favourites[productId] ?? false;
  }

  Future<void> toggleFavouriteProduct(String productId) async {
    if (!favourites.containsKey(productId)) {
      favourites[productId] = true;
      HkHelperFunctions.customToast(message: 'Product added to Wishlist ❤️');
    } else {
      favourites.remove(productId);
      HkHelperFunctions.customToast(message: 'Product removed from Wishlist');
    }

    await saveFavouritesToStorage();
    loadFavouriteProducts();
  }

  Future<void> saveFavouritesToStorage() async {
    final encodedFavourites = jsonEncode(favourites);
    await HkLocalStorage.instance().saveData('favourites', encodedFavourites);
  }

  // 🔥 Dynamic Products from CartController
  void loadFavouriteProducts() {
    if (favourites.isEmpty) {
      favouriteProductsList.clear();
      return;
    }

    final List<ProductModel> filteredProducts = [];

    for (var item in cartController.popularProducts) {
      final String productId = (item['_id'] ?? item['id'] ?? '').toString();

      if (favourites.containsKey(productId)) {
        try {
          final product = ProductModel.fromJson(item);
          filteredProducts.add(product);
        } catch (e) {
          debugPrint("Error converting product: $e");
        }
      }
    }

    favouriteProductsList.assignAll(filteredProducts);
  }

  void refreshFavourites() {
    loadFavouriteProducts();
  }
}