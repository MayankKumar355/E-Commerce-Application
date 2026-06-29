import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_store/features/shop/controllers/product/variation_controller.dart';
import 'package:shopping_store/utils/constants/enums.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/local_storage/storage_utility.dart';

import '../../../../connection/apiConnetion.dart';
import '../../../../data/modal/cartModal/cartModal.dart';
import '../../../../data/modal/productModal/productModal.dart';


class CartController extends GetxController {
  static CartController get instance => Get.find();

  final String cartItemsKey = 'CartItems';

  final RxList<CartModal> cartItems = <CartModal>[].obs;

  final RxInt noOfCartItem = 0.obs;
  final RxDouble totalCartPrice = 0.0.obs;
  final RxInt productQuantityInCart = 0.obs;
  final RxBool isLoading = false.obs;

  final RxList<dynamic> popularProducts = <dynamic>[].obs;
  final RxList<dynamic> filteredProducts = <dynamic>[].obs;

  final variationController = VariationController.instance;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
    fetchPopularProductsFromServer();
  }

  // उत्पाद को फिल्टर करने का फ़ंक्शन
  void filterProductsByCategory(String category) {
    if (category == 'All' || category.isEmpty) {
      filteredProducts.assignAll(popularProducts);
    } else {
      filteredProducts.assignAll(
          popularProducts.where((p) {
            final String brand = (p['brandName'] ?? '').toString().toLowerCase().trim();
            final String cat = category.toLowerCase().trim();

            debugPrint("===> DATABASE BRAND NAME IS: '$brand' | FILTERING FOR: '$cat'");

            if (cat == 'sport') {
              return ["nike", "adidas", "jordan", "sparx", "bata"].contains(brand);
            } else if (cat == 'clothes') {
              return ["puma", "zara"].contains(brand);
            } else if (cat == 'furniture') {
              return ["furniture", "ikea", "hernan-miller","acer"].contains(brand);
            } else if (cat == 'electronics') {
              return ["apple", "sony", "electronics", "iphone", "kenwood"].contains(brand);
            } else if(cat == 'other'){
              return ["apple", "sony", "electronics", "iphone", "kenwood","nike", "adidas", "jordan", "sparx", "bata"].contains(brand);
            }
            return false;
          }).toList()
      );
    }
  }

  Future<List<ProductModel>> AllProduct() async {
    try {
      final response = await http.get(Uri.parse(ApiConnection.productPopularUrl));

      debugPrint("API Response Status: ${response.statusCode}");
      debugPrint("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          return data.map((json) => ProductModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching all products: $e");
    }
    return [];
  }
  int calculateSalePercentage(double originalPrice, double salePrice) {
    if (originalPrice <= 0 || salePrice <= 0 || salePrice >= originalPrice) {
      return 0;
    }
    final discount = ((originalPrice - salePrice) / originalPrice) * 100;
    return discount.round();
  }

  String getProductPrice(ProductModel product) {
    if (product.salePrice > 0 && product.salePrice < product.price) {
      return '- \$${product.salePrice.toStringAsFixed(0)}';
    } else {
      return '\$${product.price.toStringAsFixed(0)}';
    }
  }

  // स्टॉक की स्थिति
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  // सर्वर से लोकप्रिय उत्पाद लाना
  Future<void> fetchPopularProductsFromServer() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(ApiConnection.productPopularUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          popularProducts.assignAll(responseData['data']);
          filterProductsByCategory('Sport');
        }
      }
    } catch (e) {
      debugPrint("Error fetching popular products: $e");
    } finally {
      isLoading(false);
    }
  }

  // सर्वर के साथ कार्ट कीमतें सिंक करना
  Future<void> syncCartPricesWithServer() async {
    if (cartItems.isEmpty) return;
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(ApiConnection.productPopularUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          List<dynamic> serverProducts = responseData['data'];

          for (var cartItem in cartItems) {
            final serverProduct = serverProducts.firstWhereOrNull(
                    (p) => p['_id'] == cartItem.productId || p['id'] == cartItem.productId
            );

            if (serverProduct != null) {
              cartItem.price = (serverProduct['salePrice'] ?? 0.0) > 0.0
                  ? (serverProduct['salePrice'] as num).toDouble()
                  : (serverProduct['price'] as num).toDouble();
              cartItem.title = serverProduct['title'] ?? cartItem.title;
            }
          }
          updateCartTotals();
          saveCartToLocal();
        }
      }
    } catch (e) {
      debugPrint("Error syncing cart with popular products: $e");
    } finally {
      isLoading(false);
    }
  }

  // कार्ट में उत्पाद जोड़ना
  void addToCart(ProductModel product) {
    if (productQuantityInCart.value < 1) {
      HkHelperFunctions.customToast(message: 'Select Quantity');
      return;
    }

    final productId = product.id;
    final rawServerProduct = popularProducts.firstWhereOrNull((p) => p['id'] == productId || p['_id'] == productId);
    final ProductModel liveProduct = rawServerProduct != null ? ProductModel.fromJson(rawServerProduct) : product;

    final isVariable = liveProduct.productType == ProductType.variable.name ||
        liveProduct.productType == ProductType.variable.toString();

    if (isVariable && (variationController.selectedVariation.value?.id ?? '').isEmpty) {
      HkHelperFunctions.customToast(message: 'Select Variation');
      return;
    }

    if (isVariable) {
      if ((variationController.selectedVariation.value?.stock ?? 0) < 1) {
        HkHelperFunctions.warningSnackBar(title: 'Oh Snap!', message: 'Selected variation is out of stock');
        return;
      }
    } else {
      if (liveProduct.stock < 1) {
        HkHelperFunctions.warningSnackBar(title: 'Oh Snap!', message: 'Product is out of stock');
        return;
      }
    }

    final selectedCartItem = convertToCartItem(liveProduct, productQuantityInCart.value);

    final index = cartItems.indexWhere((cartItem) =>
    cartItem.productId == selectedCartItem.productId &&
        cartItem.selectedVariation?['variationId'] == selectedCartItem.selectedVariation?['variationId']
    );

    if (index >= 0) {
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();

    HkHelperFunctions.customToast(message: 'Your product has been added to the Cart');
  }

  // एक आइटम को CART में जोड़ें
  void addOneToCart(CartModal item) {
    final index = cartItems.indexWhere((cartItem) =>
    cartItem.productId == item.productId && cartItem.selectedVariation?['variationId'] ==
        item.selectedVariation?['variationId']); // [] का उपयोग किया क्योंकि यह Map है

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  // एक आइटम को कार्ट से हटाएं
  void removeOneFromCart(CartModal item) {
    final index = cartItems.indexWhere((cartItem) =>
    cartItem.productId == item.productId && cartItem.selectedVariation?['variationId'] == item.selectedVariation?['variationId']);

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
        updateCart();
      } else {
        removeFromCartDialog(index);
      }
    }
  }

  // आइटम को डायलॉग के जरिए हटाना
  void removeFromCartDialog(int index) {
    Get.defaultDialog(
        title: 'Remove Product',
        middleText: 'Are you sure you want to remove this product?',
        onConfirm: () {
          cartItems.removeAt(index);
          updateCart();
          HkHelperFunctions.customToast(message: 'Product removed from the cart');
          Get.back();
        },
        onCancel: () => Get.back());
  }

  CartModal convertToCartItem(ProductModel product, int quantity) {
    final variation = variationController.selectedVariation.value;
    final isVariation = (variation?.id ?? '').isNotEmpty;

    // 🔴 DEBUG PRINTS: यहाँ कंसोल में डेटा प्रिंट होगा
    debugPrint('========== CART DEBUG START ==========');
    debugPrint('Product Title: ${product.title}');
    debugPrint('Is Variation Product: $isVariation');
    if (isVariation) {
      debugPrint('Selected Variation ID: ${variation?.id}');
      debugPrint('Selected Attribute Values: ${variation?.attributeValues}');
    }
    debugPrint('======================================');

    final image = isVariation ? variation?.image : product.thumbnail;
    final price = isVariation
        ? ((variation?.salePrice ?? 0.0) > 0.0 ? variation?.salePrice : variation?.price)
        : (product.salePrice > 0.0 ? product.salePrice : product.price);

    return CartModal(
      productId: product.id,
      quantity: quantity,
      brandName: (product.brandName != null && product.brandName!.isNotEmpty) ? product.brandName! : '',
      title: product.title,
      image: image ?? '',
      price: (price ?? 0.0).toDouble(),
      selectedVariation: isVariation
          ? {
        'variationId': variation?.id ?? '',
        ...variation?.attributeValues ?? {},
      }
          : null,
    );
  }

  // कार्ट अपडेट करना
  void updateCart() {
    updateCartTotals();
    saveCartToLocal();
    cartItems.refresh();
  }

  // कुल कीमत और आइटम की संख्या अपडेट
  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      final double itemPrice = (item.price ?? 0.0).toDouble();
      final int itemQuantity = item.quantity;
      calculatedTotalPrice += itemPrice * itemQuantity;
      calculatedNoOfItems += itemQuantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItem.value = calculatedNoOfItems;
  }

  // लोकल स्टोरेज में सेव करना
  void saveCartToLocal() {
    final cartJsonList = cartItems.map((item) =>  item.toJson()).toList(); // .toList() जोड़ा
    HkLocalStorage.instance().saveData(cartItemsKey, cartJsonList);
  }

  // लोकल से लोड करना
  void loadCartItems() {
    final cartJsonList = HkLocalStorage.instance().readData<List<dynamic>>(cartItemsKey);
    if (cartJsonList != null) {
      cartItems.assignAll(cartJsonList.map((json) => CartModal.fromJson(json)).toList());
      updateCartTotals();
    }
    syncCartPricesWithServer();
  }

  // उत्पाद को कार्ट में पहले से है या नहीं, इसकी मात्रा पता करें
  int getProductQuantityInCart(String productId) {
    return cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previous, item) => previous + item.quantity);
  }

  // वेरिएशन के साथ मात्रा पता करें (firstWhereOrNull का इस्तेमाल करके सुरक्षित किया)
  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhereOrNull(
            (item) => item.productId == productId && item.selectedVariation?['variationId'] == variationId
    );

    return foundItem != null ? foundItem.quantity : 0;
  }

  // पूरे कार्ट को क्लियर करना
  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }

  // पहले से जुड़े उत्पाद की संख्या अपडेट करना (firstWhereOrNull से क्रैश सुरक्षित किया)
  void updateAlreadyAddedProductCount(ProductModel product) {
    try {
      final productId = product.id;
      final rawServerProduct = popularProducts.firstWhereOrNull((p) => p['id'] == productId || p['_id'] == productId);
      final ProductModel liveProduct = rawServerProduct != null ? ProductModel.fromJson(rawServerProduct) : product;

      final isVariable = liveProduct.productType == ProductType.variable.name ||
          liveProduct.productType == ProductType.variable.toString();

      if (isVariable) {
        final variation = variationController.selectedVariation.value;
        if (variation == null) {
          productQuantityInCart.value = 0;
          return;
        }

        final variationId = variation.id ?? '';
        if (variationId.isEmpty) {
          productQuantityInCart.value = 0;
          return;
        }

        final foundItem = cartItems.firstWhereOrNull(
                (item) => item.productId == productId && item.selectedVariation?['variationId'] == variationId
        );
        productQuantityInCart.value = foundItem != null ? foundItem.quantity : 0;
      } else {
        final foundItem = cartItems.firstWhereOrNull(
                (item) => item.productId == productId
        );
        productQuantityInCart.value = foundItem != null ? foundItem.quantity : 0;
      }
    } catch (e) {
      debugPrint('Error updating product count: $e');
      productQuantityInCart.value = 0;
    }
  }
}
