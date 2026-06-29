import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Local storage update karne ke liye add kiya
import 'package:shopping_store/features/personalization/controllers/user_controller.dart';
import 'package:shopping_store/features/personalization/screens/profile/profile.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/popups/full_screen_loader.dart';

import '../../../../data/modal/userModal/authModal.dart'; // Correct model import link kiya
import '../../../utils/helpers/network_manager.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  /// Variables
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initializeNames();
  }

  /// ⭐️ FIX 1: Names ko alag-alag unki individual property se initialize kiya
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      // Start Loading
      HkFullScreenLoader.openLoadingDialog('We are updating your information...', HkImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        HkFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        HkFullScreenLoader.stopLoading();
        return;
      }

      // ⭐️ FIX 2: Final variables hone ke kaaran direct modify nahi kar sakte, 
      // isliye naya runtime object assign kiya data payload parameters ke sath
      final updatedUser = UserModel(
        id: userController.user.value.id,
        name: "${firstName.text.trim()} ${lastName.text.trim()}",
        email: userController.user.value.email,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: userController.user.value.username,
        phoneNumber: userController.user.value.phoneNumber,
        profilePic: userController.user.value.profilePic,
        isVerified: userController.user.value.isVerified,
      );

      // Rx Value Update karein (Isse Home aur Person screen instantly change ho jayengi)
      userController.user.value = updatedUser;

      // ⭐️ FIX 3: Local Storage Update (Taaki App restart hone par naam vapis purana na ho)
      final localStorage = GetStorage();
      localStorage.write('USER_DATA', updatedUser.toJson());

      // Remove Loading
      HkFullScreenLoader.stopLoading();

      // Show Success Message
      HkHelperFunctions.successSnackBar(title: 'Congratulations', message: 'Your name has been updated');

      // Move to previous screen
      Get.off(() => const ProfileScreen());

    } catch (e) {
      // Stop Loading
      HkFullScreenLoader.stopLoading();
      // Show Error message
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    super.onClose();
  }
}
