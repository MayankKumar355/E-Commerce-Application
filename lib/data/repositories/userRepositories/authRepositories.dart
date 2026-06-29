import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../connection/apiConnetion.dart';

class AuthRepository {

  // 1. REGISTER API CALL
  Future<Map<String, dynamic>?> registerUser({
    required String name,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnection.registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "username": username,
          "phoneNumber": phoneNumber,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Register Repo Error: $e");
      return null;
    }
  }

  // 2. LOGIN API CALL
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnection.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Login Repo Error: $e");
      return null;
    }
  }

  // 3. FORGET PASSWORD
  Future<Map<String, dynamic>?> forgetPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnection.forgetPasswordUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Forget Password Repo Error: $e");
      return null;
    }
  }

  // 4. RESET PASSWORD
  Future<Map<String, dynamic>?> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final String fullUrl = "${ApiConnection.resetPasswordUrl}/$token";
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"password": newPassword}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Reset Password Repo Error: $e");
      return null;
    }
  }

  // 5. RESEND VERIFICATION EMAIL
  Future<Map<String, dynamic>?> resendVerification({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnection.resendVerificationUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Resend Verification Repo Error: $e");
      return null;
    }
  }

  // 6. VERIFY EMAIL VIA TOKEN
  Future<Map<String, dynamic>?> verifyEmail({required String token}) async {
    try {
      final String fullUrl = "${ApiConnection.verifyEmailUrl}/$token";
      final response = await http.get(Uri.parse(fullUrl));
      return jsonDecode(response.body);
    } catch (e) {
      print("Verify Email Repo Error: $e");
      return null;
    }
  }
}
