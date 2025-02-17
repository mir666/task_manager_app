import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screen/forget%20password/reset_password_screen.dart';
import 'package:task_manager_app/ui/screen/sign_in_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widget/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widget/screen_background.dart';
import 'package:task_manager_app/ui/widget/show_snack_bar_message.dart';

class ForgetPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgetPasswordVerifyOtpScreen({super.key, required this.email});

  final String email;

  static const String name = '/forget-password/verify-otp';

  @override
  State<ForgetPasswordVerifyOtpScreen> createState() =>
      _ForgetPasswordVerifyOtpScreenState();
}

class _ForgetPasswordVerifyOtpScreenState
    extends State<ForgetPasswordVerifyOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 108),
                  Text(
                    'PIN Verification',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digit code has been sent to your email address',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  _buildPinCodeTextField(context),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: _isLoading == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _verifyOTP();
                        }
                      },
                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: _buildLoginSection(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PinCodeTextField _buildPinCodeTextField(BuildContext context) {
    return PinCodeTextField(
      validator: (String? value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Please enter OTP code';
        } else if (value!.length < 6) {
          return 'Please enter valid OTP code';
        }
        return null;
      },
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 45,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: AppColors.themeColor,
        inactiveColor: Colors.blue,
        selectedColor: AppColors.themeColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _otpController,
      appContext: context,
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Have an account? ',
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(
              color: AppColors.themeColor,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInScreen.name,
                  (value) => false,
                );
              },
          ),
        ],
      ),
    );
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.otpVerify(email.toString(), otp),
      );

      if (response.isSuccess) {
        if (response.responseData!['status'] == 'success') {
          //final prefs = await SharedPreferences.getInstance();
          await prefs.setString(email.toString(), otp);

          Navigator.pushNamedAndRemoveUntil(
            context,
            ResetPasswordScreen.name,
            (value) => false,
          );
          debugPrint('Email => $email');
          debugPrint('OTP => $otp');
        } else {
          showSnackBarMessage(context, response.responseData!['status'], false);
        }
      } else {
        showSnackBarMessage(context, response.errorMessage, false);
      }
    } catch (e) {
      showSnackBarMessage(context, e.toString(), true);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
