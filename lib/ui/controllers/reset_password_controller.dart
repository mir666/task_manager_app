import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screen/sign_in_screen.dart';

class ResetPasswordController extends GetxController{
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> recoveryPassword(String email, String otp, String password) async {
    bool isSuccess = false;
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    otp = prefs.getString('otp') ?? '';
    print('Email: $email');
    print('OTP: $otp');

    Map<String, dynamic> responseBody = {
      "email": email,
      "OTP": otp,
      "password": password,
    };
    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPass, body: responseBody);
    if (response.isSuccess) {
      final responseData = response.responseData!;
      if (responseData['status'] == 'success') {
        Get.offAllNamed(SignInScreen.name,);
      }
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }
}