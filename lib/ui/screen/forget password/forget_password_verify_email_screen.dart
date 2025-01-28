import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screen/forget%20password/forget_password_verify_otp_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widget/screen_background.dart';
import 'package:task_manager_app/ui/widget/show_snack_bar_message.dart';

class ForgetPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgetPasswordVerifyEmailScreen({super.key});

  static const String name = '/forget-password/verify-email';

  @override
  State<ForgetPasswordVerifyEmailScreen> createState() =>
      _ForgetPasswordVerifyEmailScreenState();
}

class _ForgetPasswordVerifyEmailScreenState
    extends State<ForgetPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _InProgress = true;

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
                    'Your Email Address',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits verification pin will sent to your email address',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _InProgress == true ? _verifyEmailButton : null,
                    child: _InProgress == true
                        ? const Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.white,
                            size: 24,
                          )
                        : const CircularProgressIndicator(
                            color: AppColors.themeColor,
                          ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        _buildSignInSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Have account? ",
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }

  void _verifyEmailButton() {
    if (_formKey.currentState!.validate()) {
      _InProgress = false;
      setState(() {});
      _verifyEmail();
    }
  }

  Future<void> _verifyEmail() async {
    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.emailVerify(_emailTEController.text.trim()));
    _InProgress = true;
    if (response.isSuccess) {
      if (response.responseData!['status'] == 'fail') {
        showSnackBarMessage(context, "No User Found", false);
      } else {
        Navigator.pushReplacementNamed(
          context,
          ForgetPasswordVerifyOtpScreen.name,
          arguments: _emailTEController.text.trim(),
        );
      }
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
