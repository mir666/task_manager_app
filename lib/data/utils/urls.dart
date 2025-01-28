class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static const String registrationUrl = '$_baseUrl/registration';
  static const String loginUrl = '$_baseUrl/login';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskCountByStatusUrl = '$_baseUrl/taskStatusCount';
  static const String resetPass = '$_baseUrl/RecoverResetPass';

  static String emailVerify(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';

  static String otpVerify(String email, String otp) =>
      '$_baseUrl/RecoverVerifyOTP/$email/$otp';

  static String deleteUrl(String id) => '$_baseUrl/deleteTask/$id';
  static String UpgradeTask(String sid, String status) =>
      '$_baseUrl/updateTaskStatus/$sid/$status';

  static String taskListByStatusUrl(String status) =>
      '$_baseUrl/listTaskByStatus/$status';

  static const String updateProfile = '$_baseUrl/profileUpdate';
}