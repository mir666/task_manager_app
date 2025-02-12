import 'package:get/get.dart';
import 'package:task_manager_app/data/model/task_list_by_status_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class ProgressTaskController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  TaskListByStatusModel? _progressTaskListModel;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel> get taskList => _progressTaskListModel?.taskList ?? [];

  Future<bool> getProgressTaskList() async {
    _inProgress = true;
    update();
    bool isSuccess = false;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Progress'));
    if (response.isSuccess) {
      _progressTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}