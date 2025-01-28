import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screen/sign_in_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widget/screen_background.dart';
import 'package:task_manager_app/ui/widget/show_snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.emailAndOtp});

  final Map emailAndOtp;

  static const String name = '/forget-password/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = true;

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
                    'Set Password',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Minimum length password 8 character with Letter and Number combination',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _newPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'New Password',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _inProgress == true ? _setPassButton : null,
                    child: _inProgress == true
                        ? const Text('Confirm')
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
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);
              },
          ),
        ],
      ),
    );
  }

  void _setPassButton() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordTEController.text == _confirmPasswordTEController.text) {
        _inProgress = false;
        setState(() {});
        recoveryPassword();
      } else {
        showSnackBarMessage(context, "No Match Password", false);
        _newPasswordTEController.clear();
        _confirmPasswordTEController.clear();
      }
    }
  }

  Future<void> recoveryPassword() async {
    Map<String, dynamic> responseBody = {
      "email": widget.emailAndOtp['gmail'],
      "OTP": widget.emailAndOtp['otp'],
      "password": _confirmPasswordTEController.text
    };
    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPass, body: responseBody);
    if (response.isSuccess) {
      showSnackBarMessage(context, "Password recovery success", true);
      Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.name,
        (route) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
