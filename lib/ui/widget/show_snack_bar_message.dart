import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';

void showSnackBarMessage(BuildContext context, String message, bool status) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: status == true ? AppColors.themeColor : Colors.redAccent,
      duration: const Duration(seconds: 1),
      content: Text(message),
    ),
  );
}
