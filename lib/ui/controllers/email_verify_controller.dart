import 'package:get/get.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screen/forget%20password/forget_password_verify_otp_screen.dart';

class EmailVerifyController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyEmail(String email) async {
    bool isSuccess = false;
    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.emailVerify(email));
    _inProgress = true;
    update();
    if (response.isSuccess) {
      if (response.responseData!['status'] == 'fail') {
      } else {
        Get.offAllNamed(ForgetPasswordVerifyOtpScreen.name);
      }
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}