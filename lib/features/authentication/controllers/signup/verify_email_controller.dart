import 'dart:async';
import 'package:get/get.dart';
import 'package:shopping_store/common/widgets/success_screen/success_screen.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/utils/helpers/network_manager.dart';
import '../../../../data/repositories/userRepositories/authRepositories.dart';
import '../../../../utils/constants/text_strings.dart';


class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  Timer? _timer;
  final AuthRepository _authRepository = AuthRepository();

  late String userEmail;

  @override
  void onInit() {
    // Signup screen se bhejey gaye email parameter ko read karein
    userEmail = Get.arguments ?? '';

    // Pehli baar automatically call notification trigger karne ke liye
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Initial alert message display ke liye
  sendEmailVerification() async {
    try {
      HkHelperFunctions.successSnackBar(
          title: 'Email Sent',
          message: 'Please check your inbox and verify your email.'
      );
    } catch (e) {
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// 🔄 Backend dynamic polling check (Har 5 seconds me user table refresh karega)
  setTimerForAutoRedirect() {
    if (userEmail.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      final response = await _authRepository.resendVerification(email: userEmail);

      if (response != null && response['message'] != null) {
        String msg = response['message'].toString().toLowerCase();

        // Agar backend bolta hai "already verified", toh skip karke success screen par bhejo
        if (msg.contains('already verified') || msg.contains('verified')) {
          timer.cancel();
          _timer?.cancel();
          moveToSuccessScreen();
        }
      }
    });
  }

  /// ⚙️ User Manually "Continue" button dawayega tab ye call hoga (Instant verification check)
  checkEmailVerificationStatus() async {
    try {
      if (userEmail.isEmpty) return;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      final response = await _authRepository.resendVerification(email: userEmail);

      if (response != null && response['message'] != null) {
        String msg = response['message'].toString().toLowerCase();

        if (msg.contains('already verified') || msg.contains('verified')) {
          _timer?.cancel();
          moveToSuccessScreen();
        } else {
          HkHelperFunctions.errorSnackBar(
              title: 'Not Verified Yet',
              message: 'Please check your email and click the verification link.'
          );
        }
      }
    } catch (e) {
      HkHelperFunctions.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// 📨 Resend link trigger karne ke liye (Teesri screen ka manual resend link text click)
  resendVerificationEmailManual() async {
    try {
      if (userEmail.isEmpty) return;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      final response = await _authRepository.resendVerification(email: userEmail);

      if (response != null && response['message'] != null) {
        HkHelperFunctions.successSnackBar(
            title: 'Email Sent',
            message: 'A fresh verification link has been sent to your email.'.tr
        );
      }
    } catch (e) {
      HkHelperFunctions.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void moveToSuccessScreen() {
    Get.off(() => SuccessScreen(
        image: HkImages.successfulPaymentIcon,
        title: HkTexts.yourAccountCreatedTitle,
        subtitle: HkTexts.yourAccountCreatedSubTitle,
        onPress: () {
          // Success hone par cleanly user ko back to login router par drop karein
          Get.offAllNamed('/login');
        }
    ));
  }
}
