import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shopping_store/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/helpers/network_manager.dart';
import 'package:shopping_store/utils/popups/full_screen_loader.dart';

import '../../../../data/repositories/userRepositories/authRepositories.dart';
import '../../../../utils/constants/image_strings.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();

  /// Send Reset Password Email (Screen 1)
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      HkFullScreenLoader.openLoadingDialog('Processing your request...', HkImages.docerAnimation);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        HkFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        HkFullScreenLoader.stopLoading();
        return;
      }

      // 🔥 Real API Call: Send Email to Reset Password
      final response = await _authRepository.forgetPassword(email: email.text.trim());

      // Remove Loader immediately after response
      HkFullScreenLoader.stopLoading();

      if (response != null && response['message'] != null && response['message'].toString().contains('success')) {
        // Show Success Message
        HkHelperFunctions.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr,
        );

        // Redirect to Screen 2
        Get.to(() => ResetPasswordScreen(email: email.text.trim()));
      } else {
        // Handle backend custom error message (e.g., User not found)
        String errMsg = response?['message'] ?? 'Failed to send reset email.';
        HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: errMsg);
      }
    } catch (e) {
      // Remove Loader on crash
      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Resend Reset Password Email (Screen 2 Resend Button)
  resendPasswordResetEmail(String emailStr) async {
    try {
      // Start Loading
      HkFullScreenLoader.openLoadingDialog('Processing your request...', HkImages.docerAnimation);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        HkFullScreenLoader.stopLoading();
        return;
      }

      // 🔥 Real API Call: Resend Email using the repository
      final response = await _authRepository.forgetPassword(email: emailStr.trim());

      // Remove Loader
      HkFullScreenLoader.stopLoading();

      if (response != null && response['message'] != null && response['message'].toString().contains('success')) {
        // Show Success Message
        HkHelperFunctions.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr,
        );
      } else {
        String errMsg = response?['message'] ?? 'Failed to resend reset email.';
        HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: errMsg);
      }
    } catch (e) {
      // Remove Loader on crash
      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
