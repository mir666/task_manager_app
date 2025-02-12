import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/controller_binder.dart';
import 'package:task_manager_app/ui/screen/forget%20password/reset_password_screen.dart';
import 'package:task_manager_app/ui/screen/task/add_new_task_screen.dart';
import 'package:task_manager_app/ui/screen/forget%20password/forget_password_verify_email_screen.dart';
import 'package:task_manager_app/ui/screen/forget%20password/forget_password_verify_otp_screen.dart';
import 'package:task_manager_app/ui/screen/main_bottom_nav_screen.dart';
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: navigatorKey,
      initialBinding: ControllerBinder(),
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
      getPages: [
        GetPage(name: SplashScreen.name, page: () => const SplashScreen()),
        GetPage(name: SignInScreen.name, page: () => const SignInScreen()),
        GetPage(name: SignUpScreen.name, page: () => const SignUpScreen()),
        GetPage(
          name: ForgetPasswordVerifyEmailScreen.name,
          page: () => const ForgetPasswordVerifyEmailScreen(),
        ),
        GetPage(
          name: ForgetPasswordVerifyOtpScreen.name,
          page: () => const ForgetPasswordVerifyOtpScreen(email: 'email',),
        ),
        GetPage(
          name: ResetPasswordScreen.name,
          page: () => const ResetPasswordScreen(),
        ),
        GetPage(
            name: MainBottomNavScreen.name,
            page: () => const MainBottomNavScreen()),
        GetPage(
            name: AddNewTaskScreen.name, page: () => const AddNewTaskScreen()),
        GetPage(
            name: UpdateProfileScreen.name,
            page: () => const UpdateProfileScreen()),
      ],
    );
  }
}
