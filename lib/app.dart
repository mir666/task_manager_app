import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screen/task/add_new_task_screen.dart';
import 'package:task_manager_app/ui/screen/forget%20password/forget_password_verify_email_screen.dart';
import 'package:task_manager_app/ui/screen/forget%20password/forget_password_verify_otp_screen.dart';
import 'package:task_manager_app/ui/screen/main_bottom_nav_screen.dart';
import 'package:task_manager_app/ui/screen/forget%20password/reset_password_screen.dart';
import 'package:task_manager_app/ui/screen/sign_in_screen.dart';
import 'package:task_manager_app/ui/screen/sign_up_screen.dart';
import 'package:task_manager_app/ui/screen/splash_screen.dart';
import 'package:task_manager_app/ui/screen/update_profile_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      onGenerateRoute: (RouteSettings setting) {
        late Widget widget;
        if (setting.name == SplashScreen.name) {
          widget = const SplashScreen();
        } else if (setting.name == SignInScreen.name) {
          widget = const SignInScreen();
        } else if (setting.name == SignUpScreen.name) {
          widget = const SignUpScreen();
        } else if (setting.name == ForgetPasswordVerifyEmailScreen.name) {
          widget = const ForgetPasswordVerifyEmailScreen();
        } else if (setting.name == ForgetPasswordVerifyOtpScreen.name) {
          widget = const ForgetPasswordVerifyOtpScreen();
        } else if (setting.name == ResetPasswordScreen.name) {
          widget = const ResetPasswordScreen();
        } else if (setting.name == MainBottomNavScreen.name) {
          widget = const MainBottomNavScreen();
        } else if (setting.name == AddNewTaskScreen.name) {
          widget = const AddNewTaskScreen();
        } else if (setting.name == UpdateProfileScreen.name) {
          widget = const UpdateProfileScreen();
        }

        return MaterialPageRoute(builder: (ctx) => widget);
      },
    );
  }
}
