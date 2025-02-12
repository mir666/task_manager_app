import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screen/forget%20password/reset_password_screen.dart';

class OtpVerifyController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyOTP(String email, String otp) async {
    bool isSuccess = false;
    print('$otp $email');
    NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.otpVerify(email, otp));
    _inProgress = true;
    if (response.isSuccess) {
      if (response.responseData!['status'] == "success") {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email');
        await prefs.setString('otp', otp);
        Get.offAllNamed(ResetPasswordScreen.name,);
        print('Email => $email');
        print('OTP => $otp');
      }
      isSuccess = true;
      _errorMessage = null;
      _inProgress = false;
      update();
    } else {
      _errorMessage = response.errorMessage;
    }
    update();
    return isSuccess;
  }
}