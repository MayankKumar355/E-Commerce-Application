import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_store/connection/apiConnetion.dart';
import 'package:shopping_store/navigation_menu.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/helpers/network_manager.dart';
import 'package:shopping_store/utils/popups/full_screen_loader.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/controllers/user_controller.dart';

class LoginController extends GetxController{
  static LoginController get instance => Get.find();

  /// Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs; // Default me password hidden rahega
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    // Agar credentials pehle se save hain to checkbox ko auto tick karein
    if (email.text.isNotEmpty) {
      rememberMe.value = true;
    }
    super.onInit();
  }

  /// Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      print("🚀 [DEBUG] Sign-In Button Clicked!");

      if (!loginFormKey.currentState!.validate()) {
        print("❌ [DEBUG] Form validation failed!");
        return;
      }

      // Start Loading Animation
      HkFullScreenLoader.openLoadingDialog('Logging you in...', HkImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      print("🌐 [DEBUG] Internet Connected Status: $isConnected");

      if (!isConnected) {
        print("❌ [DEBUG] NetworkManager blocked the request due to no connection!");
        HkFullScreenLoader.stopLoading();
        return;
      }

      // Save data if remember me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      print("📦 [DEBUG] Request Body Data: email=${email.text.trim()}");

      // Backend ko request bhejein
      final response = await http.post(
        Uri.parse(ApiConnection.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.text.trim(),
          "password": password.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      print("📥 [DEBUG] Server Response Status Code: ${response.statusCode}");
      print("💬 [DEBUG] Server Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      HkFullScreenLoader.stopLoading();

      if (response.statusCode == 200 && data['token'] != null) {
        // Token aur Complete User details save karein
        localStorage.write('TOKEN', data['token']);
        localStorage.write('USER_DATA', data['user']);
        print("✅ [DEBUG] Login successful! Saved USER_DATA: ${data['user']}");

        // Isse data instantly UserController ke paas chala jayega aur AppBar update ho jayega
        if (Get.isRegistered<UserController>()) {
          await Get.find<UserController>().fetchUserRecord();
        } else {
          final userController = Get.put(UserController());
          await userController.fetchUserRecord();
        }

        // Redirect to Main Dashboard Menu
        Get.offAll(() => const NavigationMenu());
      } else {
        HkHelperFunctions.errorSnackBar(
            title: 'Oh Snap!',
            message: data['message'] ?? 'Invalid Email or Password.'
        );
      }

    } catch (e) {
      print("💥 [DEBUG] Exception Caught during login process: $e");
      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Google Sign in Authentication
  Future<void> googleSignIn() async{
    try{
      HkFullScreenLoader.openLoadingDialog('Logging you in...', HkImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        HkFullScreenLoader.stopLoading();
        return;
      }
      HkFullScreenLoader.stopLoading();
      Get.offAll(() => const NavigationMenu());
    }catch(e){
      HkFullScreenLoader.stopLoading();
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
