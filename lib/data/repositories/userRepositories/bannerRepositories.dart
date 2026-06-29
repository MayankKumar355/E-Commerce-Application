import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_store/connection/apiConnetion.dart';
import '../../modal/bannerModal/bannerModal.dart';

class BannerRepository {

  Future<List<BannerModel>> fetchActiveBanners() async {
    try {
      final response = await http.get(Uri.parse(ApiConnection.bannerActiveUrl));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> bannerList = [];

        if (decodedData is List) {
          bannerList = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          bannerList = decodedData['data'] ?? [];
        }

        List<BannerModel> correctBanners = [];
        for (var item in bannerList) {
          try {
            if (item != null) {
              correctBanners.add(BannerModel.fromJson(item));
            }
          } catch (parseError) {
            print("⚠️ Ek banner item skip hua parsing error ki wajah se: $parseError");
          }
        }

        return correctBanners;
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Repository Network/Parsing Error: $e");
      throw Exception('नेटवर्क कनेक्टिविटी समस्या: $e');
    }
  }
}
