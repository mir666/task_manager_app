import 'package:get/get.dart';
import 'package:task_manager_app/data/model/task_list_by_status_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class CompleteTaskController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TaskListByStatusModel? _completedTaskListModel;

  List<TaskModel> get taskList => _completedTaskListModel?.taskList ?? [];

  Future<bool> getCompletedTaskList() async {
    _inProgress = true;
    update();
    bool isSuccess = false;
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Complete'));
    if (response.isSuccess) {
      _completedTaskListModel =
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