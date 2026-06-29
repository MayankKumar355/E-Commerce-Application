import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:shopping_store/navigation_menu.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/helpers/network_manager.dart';
import 'package:shopping_store/utils/popups/full_screen_loader.dart';

import 'package:shopping_store/connection/apiConnetion.dart';
import '../../../../utils/constants/image_strings.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final localStorage = GetStorage();

  // Form Field Controllers
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  /// -- SIGNUP METHOD
  Future<void> signup() async {
    try {
      if (!signupFormKey.currentState!.validate()) {
        return;
      }

      // 2. Privacy Policy Check
      if (!privacyPolicy.value) {
        HkHelperFunctions.errorSnackBar(
            title: 'Privacy Policy',
            message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.'
        );
        return;
      }

      // 3. Start Loading Animation
      HkFullScreenLoader.openLoadingDialog('Creating your account...', HkImages.docerAnimation);

      // 4. Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        HkFullScreenLoader.stopLoading();
        return;
      }

      String fullName = "${firstName.text.trim()} ${lastName.text.trim()}";

      // 🔥 BACKEND INTEGRATION WITH USERNAME & PHONE NUMBER
      final response = await http.post(
        Uri.parse(ApiConnection.registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": fullName,
          "firstName": firstName.text.trim(),
          "lastName": lastName.text.trim(),
          "email": email.text.trim(),
          "password": password.text.trim(),
          "username": username.text.trim(),
          "phoneNumber": phoneNumber.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      HkFullScreenLoader.stopLoading();

      if (response.statusCode == 201 && data['token'] != null) {
        localStorage.write('TOKEN', data['token']);
        localStorage.write('USER_DATA', data['user']); // Isme username aur phone number bhi save ho jayenge

        // Show Success Message
        HkHelperFunctions.successSnackBar(
            title: 'Congratulations',
            message: 'Your account has been created!'
        );

        // Move to Dashboard Directly
        Get.offAll(() => const NavigationMenu());
      } else {
        HkHelperFunctions.errorSnackBar(
            title: 'Oh Snap!',
            message: data['message'] ?? 'Registration failed.'
        );
      }

    } catch (e) {
      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
