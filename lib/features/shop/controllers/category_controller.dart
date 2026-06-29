import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_store/connection/apiConnetion.dart';
import 'package:shopping_store/features/shop/screens/sub_category/sub_categories.dart';

import '../../../data/modal/categoryModal/categoryModal.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  var isLoading = false.obs;
  var allCategories = <CategoryModel>[].obs;
  var featuredCategories = <CategoryModel>[].obs;
  var subCategoriesList = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchFeaturedCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiConnection.categoryAllUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> data = responseData['data'];
          allCategories.assignAll(
              data.map((json) => CategoryModel.fromJson(json)).toList()
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load all categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFeaturedCategories() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiConnection.categoryFeaturedUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> data = responseData['data'];
          featuredCategories.assignAll(
              data.map((json) => CategoryModel.fromJson(json)).toList()
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load featured categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<dynamic>> getCategoryProducts({required String categoryId}) async {
    try {
      final response = await http.get(Uri.parse("${ApiConnection.subCategoryProductsUrl}$categoryId"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'] ?? [];
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final filteredList = allCategories.where((cat) {
        if (cat.parentId == null) return false;
        return cat.parentId.toString() == categoryId.toString();
      }).toList();

      return filteredList;
    } catch (e) {
      return [];
    }
  }

  Future<void> fetchSubCategoriesAndGo(CategoryModel category) async {
    try {
      subCategoriesList.clear();

      if (Get.context != null) {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => SubCategoriesScreen(category: category)),
        );
      }

      isLoading.value = true;
      final subs = await getSubCategories(category.dbId);
      subCategoriesList.assignAll(subs);

    } catch (e) {
      print("[DEBUG] Navigation Catch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
