import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/modal/userModal/authModal.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final localStorage = GetStorage();

  var user = UserModel(
    firstName: 'Unknown',
    lastName: 'Pro',
    email: 'user@example.com',
    phoneNumber: '1234567890',
    id: '12345',
    username: 'unknown_pro',
    name: '',
    profilePic: '',
    isVerified: false,
  ).obs;

  var imageUploading = false.obs;
  var profileLoading = false.obs;

  final hidePassword = true.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final userData = localStorage.read('USER_DATA');

      if (userData != null) {
        Map<String, dynamic> userMap = Map<String, dynamic>.from(userData);
        user.value = UserModel.fromJson(userMap);
      }
    } catch (e) {
      debugPrint("Storage Error: ${e.toString()}");
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      if (!reAuthFormKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      print("Email: ${verifyEmail.text.trim()}");
      print("Password: ${verifyPassword.text.trim()}");
      Get.snackbar("Success", "User Re-authenticated successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void uploadUserProfilePicture() async {
    try {
      imageUploading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar("Success", "Profile picture updated!");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
    } finally {
      imageUploading.value = false;
    }
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(20),
      title: 'Delete Account',
      middleText: 'Are you sure you want to delete your account permanently? This action is not reversible.',
      confirm: ElevatedButton(
        onPressed: () {
          localStorage.erase();
          user.value = UserModel.empty();
          Get.back();

          Get.snackbar(
            "Account Deleted",
            "Your account information has been wiped successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
          );
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('Delete'),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }

  @override
  void onClose() {
    verifyEmail.dispose();
    verifyPassword.dispose();
    super.onClose();
  }
}
