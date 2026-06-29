import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_store/connection/apiConnetion.dart';
import '../../modal/brandModal/brandModal.dart';

class BrandRepository {

  // 1. FETCH ALL BRANDS FROM DB
  Future<List<BrandModel>> fetchAllBrands() async {
    try {
      final response = await http.get(Uri.parse(ApiConnection.getAllBrandsUrl));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> brandList = [];

        if (decodedData is Map && decodedData.containsKey('data')) {
          brandList = decodedData['data'] ?? [];
        } else if (decodedData is List) {
          brandList = decodedData;
        }

        List<BrandModel> parsedBrands = [];
        for (var item in brandList) {
          try {
            if (item != null) {
              parsedBrands.add(BrandModel.fromJson(item));
            }
          } catch (e) {
            print("⚠️ Skipping 1 brand due to parsing error: $e");
          }
        }
        return parsedBrands;
      } else {
        throw Exception("Failed to load brands. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("All Brands Repo Error: $e");
    }
  }

  // 2. FETCH FEATURED BRANDS FROM DB
  Future<List<BrandModel>> fetchFeaturedBrands() async {
    try {
      final response = await http.get(Uri.parse(ApiConnection.getFeaturedBrandsUrl));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> brandList = [];

        if (decodedData is Map && decodedData.containsKey('data')) {
          brandList = decodedData['data'] ?? [];
        } else if (decodedData is List) {
          brandList = decodedData;
        }

        List<BrandModel> parsedFeaturedBrands = [];
        for (var item in brandList) {
          try {
            if (item != null) {
              parsedFeaturedBrands.add(BrandModel.fromJson(item));
            }
          } catch (e) {
            print("⚠️ Skipping 1 featured brand due to parsing error: $e");
          }
        }
        return parsedFeaturedBrands;
      } else {
        throw Exception("Failed to load featured brands. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Featured Brands Repo Error: $e");
    }
  }

  // 3. ADD BRAND FROM APP (IF NEEDED)
  Future<bool> addBrand(BrandModel brand) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnection.createBrandUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(brand.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("❌ Add Brand Error: $e");
      return false;
    }
  }

  // 🔥 4. FETCH BRANDS BY CATEGORY NAME (बिना बैकएंड मॉडल के फ्रंटएंड फ़िल्टर लॉजिक)
  Future<List<BrandModel>> getBrandsForCategory(String categoryName, List<BrandModel> allDownloadedBrands) async {
    try {
      // अगर आपकी 'allBrands' लिस्ट खाली है, तो पहले उसे डेटाबेस से लोड कर लेते हैं
      List<BrandModel> sourceBrands = allDownloadedBrands;
      if (sourceBrands.isEmpty) {
        sourceBrands = await fetchAllBrands();
      }

      // टैब के नाम (जैसे: 'Sport', 'Furniture') को ब्रांड के नाम या डेटा से मैच करके फ़िल्टर करना
      // यहाँ हम चेक कर रहे हैं कि क्या ब्रांड का नाम कैटेगरी के नाम से मिलता-जुलता है
      final String targetCategory = categoryName.toLowerCase().trim();

      List<BrandModel> filteredBrands = sourceBrands.where((brand) {
        final String brandName = (brand.name ?? '').toLowerCase().trim();

        // उदाहरण लॉजिक: अगर 'Sport' टैब है तो Nike, Adidas, Jordan जैसे ब्रांड्स दिखें
        if (targetCategory == 'sport') {
          return brandName == 'nike' || brandName == 'adidas' || brandName == 'jordan' || brandName == 'bata';
        }
        // अगर 'furniture' टैब है तो उससे जुड़े ब्रांड्स दिखें
        else if (targetCategory == 'furniture') {
          return brandName == 'acer' || brandName == 'ikea'; // अपने ब्रांड्स के नाम अनुसार बदलें
        }
        // अगर 'electronics' टैब है
        else if (targetCategory == 'electronics') {
          return brandName == 'apple' || brandName == 'samsung' || brandName == 'acer';
        }
        // अगर 'clothes' टैब है
        else if (targetCategory == 'clothes') {
          return brandName == 'zara' || brandName == 'nike' || brandName == 'adidas';
        }

        return true;
      }).toList();

      return filteredBrands;
    } catch (e) {
      throw Exception("Category Brands Filter Error: $e");
    }
  }
}
