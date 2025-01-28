import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/task_list_by_status_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
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
  bool _getCompletedTaskListInProgress = false;
  TaskListByStatusModel? completedTaskListModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: _buildCompletedTaskListview(),
      ),
    );
  }

  Widget _buildCompletedTaskListview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Visibility(
          visible: _getCompletedTaskListInProgress == false,
          replacement: const CenteredCircularProgressIndicator(),
          child: _buildTaskListView()),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: completedTaskListModel?.taskList?.length ?? 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return TaskItemWidget(
          onTabDelete: () {
            _deleteTaskItem(index);
          },
          onTabChangeStatus: (status) {
            print(status);
            _upgradeStatus(index, status);
          },
          taskModel: completedTaskListModel!.taskList![index],
        );
      },
    );
  }

  Future<void> _getCompletedTaskList() async {
    _getCompletedTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Complete'));
    if (response.isSuccess) {
      completedTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
    _getCompletedTaskListInProgress = false;
    setState(() {});
  }

  Future<void> _deleteTaskItem(int index) async {
    final String? _taskId = completedTaskListModel!.taskList![index].sId;
    showSnackBarMessage(context, "Deleting....", true);

    NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.deleteUrl(_taskId!));
    if (response.isSuccess) {
      showSnackBarMessage(context, "Task Deleted", true);
      completedTaskListModel?.taskList?.removeAt(index);
      setState(() {});
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
  }

  Future<void> _upgradeStatus(int index, String status) async {
    if (status == "Complete") {
      showSnackBarMessage(context, "You are in 'Complete status'.", false);
    } else {
      showSnackBarMessage(context, "status updating.....", true);
      final String? _taskId = completedTaskListModel!.taskList![index].sId;

      NetworkResponse response = await NetworkCaller.getRequest(
          url: Urls.UpgradeTask(_taskId!, status));
      if (response.isSuccess) {
        showSnackBarMessage(context, "Task Update", true);
        completedTaskListModel?.taskList?.removeAt(index);
        setState(() {});
      } else {
        showSnackBarMessage(context, response.errorMessage, false);
      }
    }
  }
}
