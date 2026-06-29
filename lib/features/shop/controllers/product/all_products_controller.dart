import 'package:get/get.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

class AllProductsController extends GetxController{
  static AllProductsController get instance => Get.find();

  final RxString selectedSortOption = 'Name'.obs;

  // 🔥 ProductModel remove karke generic RxList<dynamic> declare kiya hai
  final RxList<dynamic> products = <dynamic>[].obs;

  // 🔥 Return type List<dynamic> kiya hai bina structures chhedte hue
  Future<List<dynamic>> fetchProductsByQuery(dynamic query) async{
    try{
      if(query == null) return [];

      final List<dynamic> fetchedProducts = [];

      return fetchedProducts;

    }catch(e){
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption){
    selectedSortOption.value = sortOption;

    // 🔥 Aapke exact parameters ko dynamic keys ('title', 'price', 'date', 'salePrice') me map kiya hai
    switch(selectedSortOption.value){
      case 'Name':
        products.sort((a, b) => (a['title'] ?? '').toString().compareTo((b['title'] ?? '').toString()));
        break;
      case 'Higher Price':
        products.sort((a, b) => (b['price'] ?? 0.0).compareTo(a['price'] ?? 0.0));
        break;
      case 'Lower Price':
        products.sort((a, b) => (a['price'] ?? 0.0).compareTo(b['price'] ?? 0.0));
        break;
      case 'Newest':
        products.sort((a, b) {
          final dateA = a['date'] != null ? DateTime.parse(a['date'].toString()) : DateTime.now();
          final dateB = b['date'] != null ? DateTime.parse(b['date'].toString()) : DateTime.now();
          return dateA.compareTo(dateB);
        });
        break;
      case 'Sale':
        products.sort((a, b) {
          final double salePriceA = (a['salePrice'] ?? 0.0).toDouble();
          final double salePriceB = (b['salePrice'] ?? 0.0).toDouble();
          if(salePriceB > 0){
            return salePriceB.compareTo(salePriceA);
          }else if(salePriceA > 0){
            return -1;
          }else{
            return 1;
          }
        });
        break;
      default:
        products.sort((a, b) => (a['title'] ?? '').toString().compareTo((b['title'] ?? '').toString()));
    }
  }

  // 🔥 Type List<dynamic> accept karne ke liye assign method update kiya hai
  void assignProducts(List<dynamic> products){
    this.products.assignAll(products);
    sortProducts('Name');
  }
}