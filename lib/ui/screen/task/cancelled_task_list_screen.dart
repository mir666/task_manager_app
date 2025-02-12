import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/data/model/task_list_by_status_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager_app/ui/controllers/delete_task_controller.dart';
import 'package:task_manager_app/ui/controllers/upgrade_status_controller.dart';
import 'package:task_manager_app/ui/widget/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widget/screen_background.dart';
import 'package:task_manager_app/ui/widget/show_snack_bar_message.dart';
import 'package:task_manager_app/ui/widget/task_item_widget.dart';
import 'package:task_manager_app/ui/widget/tm_app_bar.dart';

class CanceledTaskListScreen extends StatefulWidget {
  const CanceledTaskListScreen({super.key});

  @override
  State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
}

class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {
  TaskListByStatusModel? canceledTaskListModel;
  final CancelledTaskController _cancelledTaskController = Get.find<CancelledTaskController>();
  final DeleteTaskController _deleteTaskController = Get.find<DeleteTaskController>();
  final UpgradeStatusController _upgradeStatusController = Get.find<UpgradeStatusController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCanceledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: _buildCanceledTaskListview(),
      ),
    );
  }

  Widget _buildCanceledTaskListview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GetBuilder<CancelledTaskController>(
        builder: (controller) {
          return Visibility(
              visible: controller.inProgress == false,
              replacement: const CenteredCircularProgressIndicator(),
              child: _buildTaskListView(controller.taskList));
        }
      ),
    );
  }

  Widget _buildTaskListView(List<TaskModel> taskList) {
    return ListView.builder(
      itemCount: taskList.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return TaskItemWidget(
          onTabChangeStatus: (status) {
            _upgradeStatus(index, status, taskList);
          },
          onTabDelete: () {
            _deleteTaskItem(index, taskList);
          },
          taskModel: taskList[index],
        );
      },
    );
  }

  Future<void> _getCanceledTaskList() async {
    final isSuccess = await _cancelledTaskController.getCanceledTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _cancelledTaskController.errorMessage!, false);
    }
  }

  Future<void> _deleteTaskItem(int index, List<TaskModel> taskList) async {
    final isSuccess = await _deleteTaskController.deleteTaskItem(index, taskList);
    showSnackBarMessage(context, "Deleting....", true);
    if (isSuccess) {
      showSnackBarMessage(context, "Task Deleted", true);
    } else {
      showSnackBarMessage(context, _deleteTaskController.errorMessage!, false);
    }
  }

  Future<void> _upgradeStatus(int index, String status, List<TaskModel> taskList) async {
    final isSuccess = await _upgradeStatusController.upgradeStatus(index, status, taskList);
    if (status == "Cancel") {
      showSnackBarMessage(context, "You are in 'Cancel status'.", false);
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
