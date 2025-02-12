import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/model/user_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controllers/auth_controller.dart';

class ProfileUpdateController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  XFile? _pickedImage;
  TextEditingController? _passwordTEController;
  TextEditingController? get passwordTEController => _passwordTEController;

  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }
    if (_passwordTEController!.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController!.text;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.updateProfile, body: requestBody);
    _inProgress = false;
    update();
    if (response.isSuccess) {
      if (requestBody['photo'] == null) {
        requestBody['photo'] = AuthController.userModel?.photo;
      }
      AuthController.updateUserData(UserModel.fromJson(requestBody));
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }
}