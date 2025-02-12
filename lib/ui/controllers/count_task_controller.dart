
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:task_manager_app/data/model/task_count_by_statuse_model.dart';
import 'package:task_manager_app/data/model/task_count_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class CountTaskController extends GetxController{

  bool _inProgress = false;

  bool get inProgress => _inProgress;

  TaskCountByStatusModel? _taskCountByStatusModel;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskCountModel> get taskByStatusList => _taskCountByStatusModel?.taskByStatusList ?? [];

  Future<bool> getTaskCountByStatus() async {
    _inProgress = true;
    update();
    bool isSuccess  = false;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if (response.isSuccess) {
      _taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(response.responseData!);
      if (_taskCountByStatusModel?.taskByStatusList?.length != 0 && _inProgress == true) {
      }
      isSuccess = true;
      _errorMessage = null;
    } else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}