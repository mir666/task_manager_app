import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/data/model/task_list_by_status_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/ui/controllers/complete_task_controller.dart';
import 'package:task_manager_app/ui/controllers/delete_task_controller.dart';
import 'package:task_manager_app/ui/controllers/upgrade_status_controller.dart';
import 'package:task_manager_app/ui/widget/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widget/screen_background.dart';
import 'package:task_manager_app/ui/widget/show_snack_bar_message.dart';
import 'package:task_manager_app/ui/widget/task_item_widget.dart';
import 'package:task_manager_app/ui/widget/tm_app_bar.dart';

class CompleteTaskListScreen extends StatefulWidget {
  const CompleteTaskListScreen({super.key});

  @override
  State<CompleteTaskListScreen> createState() => _CompleteTaskListScreenState();
}

class _CompleteTaskListScreenState extends State<CompleteTaskListScreen> {
  TaskListByStatusModel? completedTaskListModel;
  final CompleteTaskController _completeTaskController =
      Get.find<CompleteTaskController>();
  final DeleteTaskController _deleteTaskController =
      Get.find<DeleteTaskController>();
  final UpgradeStatusController _upgradeStatusController =
      Get.find<UpgradeStatusController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: _buildCompletedTaskListview(),
      ),
    );
  }

  Widget _buildCompletedTaskListview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GetBuilder<CompleteTaskController>(builder: (controller) {
        return Visibility(
            visible: controller.inProgress == false,
            replacement: const CenteredCircularProgressIndicator(),
            child: _buildTaskListView(controller.taskList));
      }),
    );
  }

  Widget _buildTaskListView(List<TaskModel> taskList) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: taskList.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return TaskItemWidget(
          onTabDelete: () {
            _deleteTaskItem(index, taskList);
          },
          onTabChangeStatus: (status) {
            if (kDebugMode) {
              print(status);
            }
            _upgradeStatus(index, status, taskList);
          },
          taskModel: taskList[index],
        );
      },
    );
  }

  Future<void> _getCompletedTaskList() async {
    final isSuccess = await _completeTaskController.getCompletedTaskList();
    if (isSuccess) {
      showSnackBarMessage(
          context, _completeTaskController.errorMessage!, false);
    }
  }

  Future<void> _deleteTaskItem(int index, List<TaskModel> taskList) async {
    final isSuccess =
        await _deleteTaskController.deleteTaskItem(index, taskList);
    showSnackBarMessage(context, "Deleting....", true);

    if (isSuccess) {
      showSnackBarMessage(context, "Task Deleted", true);
    } else {
      showSnackBarMessage(context, _deleteTaskController.errorMessage!, false);
    }
  }

  Future<void> _upgradeStatus(int index, String status, List<TaskModel> taskList) async {
    final isSuccess = await _upgradeStatusController.upgradeStatus(index, status, taskList);
    if (status == "Complete") {
      showSnackBarMessage(context, "You are in 'Complete status'.", false);
    } else {
      showSnackBarMessage(context, "status updating.....", true);
      if (isSuccess) {
        showSnackBarMessage(context, "Task Update", true);
      } else {
        showSnackBarMessage(context, _upgradeStatusController.errorMessage!, false);
      }
    }
  }
}
