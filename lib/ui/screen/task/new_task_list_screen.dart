import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/data/model/task_count_by_statuse_model.dart';
import 'package:task_manager_app/data/model/task_count_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/ui/controllers/count_task_controller.dart';
import 'package:task_manager_app/ui/controllers/delete_task_controller.dart';
import 'package:task_manager_app/ui/controllers/new_task_controller.dart';
import 'package:task_manager_app/ui/controllers/upgrade_status_controller.dart';
import 'package:task_manager_app/ui/screen/task/add_new_task_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widget/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widget/screen_background.dart';
import 'package:task_manager_app/ui/widget/show_snack_bar_message.dart';
import 'package:task_manager_app/ui/widget/task_item_widget.dart';
import 'package:task_manager_app/ui/widget/task_status_summary_counter_widget.dart';
import 'package:task_manager_app/ui/widget/tm_app_bar.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  TaskCountByStatusModel? taskCountByStatusModel;
  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  final CountTaskController _countTaskController = Get.find<CountTaskController>();
  final DeleteTaskController _deleteTaskController = Get.find<DeleteTaskController>();
  final UpgradeStatusController _upgradeStatusController = Get.find<UpgradeStatusController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTaskCountByStatus(true);
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTaskSummaryByStatus(_countTaskController.taskByStatusList),
              _buildNewTaskListview(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name).then(
            (value) {
              if (value == true) {
                _getTaskCountByStatus(true);
                print(value);
              }
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNewTaskListview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GetBuilder<NewTaskController>(builder: (controller) {
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
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          onTabDelete: () {
            _deleteTaskItem(index, taskList);
          },
          onTabChangeStatus: (status) {
            _upgradeStatus(index, status, taskList);
          },
          taskModel: taskList[index],
        );
      },
    );
  }

  Widget _buildTaskSummaryByStatus(List<TaskCountModel> taskByStatusList) {
    return GetBuilder<CountTaskController>(builder: (controller) {
      return Visibility(
        visible: controller.inProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
          child: SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: taskByStatusList.length,
              itemBuilder: (context, index) {
                final TaskCountModel model = taskByStatusList[index];
                return TaskStatusSummaryCounterWidget(
                  title: model.sId ?? '',
                  count: model.sum.toString(),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Future<void> _getTaskCountByStatus(bool _inprogress) async {
    final isSuccess = await _countTaskController.getTaskCountByStatus();
    if (isSuccess) {
      _getNewTaskList();
    } else {
      showSnackBarMessage(context, _countTaskController.errorMessage!, false);
    }
  }

  Future<void> _getNewTaskList() async {
    final isSuccess = await _newTaskController.getTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _newTaskController.errorMessage!, false);
    }
  }

  Future<void> _deleteTaskItem(int index, List<TaskModel> taskList) async {
    final isSuccess =
        await _deleteTaskController.deleteTaskItem(index, taskList);
    showSnackBarMessage(context, "Deleting....", true);
    if (isSuccess) {
      showSnackBarMessage(context, "Task Deleted", true);
      _getTaskCountByStatus(false);
    } else {
      showSnackBarMessage(context, _deleteTaskController.errorMessage!, false);
    }
  }

  Future<void> _upgradeStatus(
      int index, String status, List<TaskModel> taskList) async {
    final isSuccess =
        await _upgradeStatusController.upgradeStatus(index, status, taskList);

    if (status == "New") {
      showSnackBarMessage(context, "You are in 'New status'.", false);
    } else {
      showSnackBarMessage(context, "status updating.....", true);
      if (isSuccess) {
        showSnackBarMessage(context, "Task Update", true);
        _getTaskCountByStatus(false);
      } else {
        showSnackBarMessage(
            context, _upgradeStatusController.errorMessage!, false);
      }
    }
  }
}
