import 'package:get/get.dart';
import '../../../data/modal/bannerModal/bannerModal.dart';
import '../../../data/repositories/userRepositories/bannerRepositories.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  final BannerRepository _repository = BannerRepository();

  final carouselCurrentIndex = 0.obs;
  final isLoading = false.obs;

  final banners = <BannerModel>[].obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  void updatePageIndicator(int index) {
    carouselCurrentIndex.value = index;
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;

      final fetchedBanners = await _repository.fetchActiveBanners();

      print("🎯 FETCHED BANNERS COUNT: ${fetchedBanners.length}");

      if (fetchedBanners.isNotEmpty) {
        this.banners.assignAll(fetchedBanners);
      } else {
        print("⚠️ WARNING: Backend ne success return kiya, par banners ki list empty [] mili.");
      }
    } catch (e) {
      print("❌ CRITICAL ERROR IN BANNER CONTROLLER: $e");

      HkHelperFunctions.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString().replaceAll('Exception:', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
