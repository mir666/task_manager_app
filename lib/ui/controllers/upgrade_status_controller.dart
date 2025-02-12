import 'package:get/get.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class UpgradeStatusController extends GetxController{

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> upgradeStatus(int index, String status, List<TaskModel> taskList) async {
    bool isSuccess = false;
    final String? _taskId = taskList[index].sId;

      NetworkResponse response = await NetworkCaller.getRequest(
          url: Urls.UpgradeTask(_taskId!, status));
      if (response.isSuccess) {
        taskList.removeAt(index);
        isSuccess = true;
        _errorMessage = null;
        update();
      } else{
        _errorMessage = response.errorMessage;
      }

    return isSuccess;
  }
}