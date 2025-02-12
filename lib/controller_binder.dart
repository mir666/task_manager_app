import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_app/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager_app/ui/controllers/complete_task_controller.dart';
import 'package:task_manager_app/ui/controllers/count_task_controller.dart';
import 'package:task_manager_app/ui/controllers/delete_task_controller.dart';
import 'package:task_manager_app/ui/controllers/email_verify_controller.dart';
import 'package:task_manager_app/ui/controllers/new_task_controller.dart';
import 'package:task_manager_app/ui/controllers/otp_verify_controller.dart';
import 'package:task_manager_app/ui/controllers/profile_update_controller.dart';
import 'package:task_manager_app/ui/controllers/progress_task_controller.dart';
import 'package:task_manager_app/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_app/ui/controllers/sign_in_controller.dart';
import 'package:task_manager_app/ui/controllers/sign_up_controller.dart';
import 'package:task_manager_app/ui/controllers/upgrade_status_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignUpController());
    Get.put(AddNewTaskController());
    Get.put(NewTaskController());
    Get.put(CountTaskController());
    Get.put(DeleteTaskController());
    Get.put(UpgradeStatusController());
    Get.put(ProgressTaskController());
    Get.put(CompleteTaskController());
    Get.put(CancelledTaskController());
    Get.lazyPut(() => ProfileUpdateController());
    Get.lazyPut(() => EmailVerifyController());
    Get.lazyPut(() => OtpVerifyController());
    Get.lazyPut(() => ResetPasswordController());
  }
}