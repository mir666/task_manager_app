import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/task_list_by_status_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/widget/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widget/screen_background.dart';
import 'package:task_manager_app/ui/widget/show_snack_bar_message.dart';
import 'package:task_manager_app/ui/widget/task_item_widget.dart';
import 'package:task_manager_app/ui/widget/tm_app_bar.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getProgressTaskListInProgress = false;
  TaskListByStatusModel? progressTaskListModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: _buildProgressTaskListview(),
      ),
    );
  }

  _buildProgressTaskListview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Visibility(
          visible: _getProgressTaskListInProgress == false,
          replacement: const CenteredCircularProgressIndicator(),
          child: _buildTaskListView()),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      itemCount: progressTaskListModel?.taskList?.length ?? 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return TaskItemWidget(
          onTabChangeStatus: (status) {
            _upgradeStatus(index, status);
          },
          onTabDelete: () {
            _deleteTaskItem(index);
          },
          taskModel: progressTaskListModel!.taskList![index],
        );
      },
    );
  }

  Future<void> _getProgressTaskList() async {
    _getProgressTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Progress'));
    if (response.isSuccess) {
      progressTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
    _getProgressTaskListInProgress = false;
    setState(() {});
  }

  Future<void> _deleteTaskItem(int index) async {
    final String? _taskId = progressTaskListModel!.taskList![index].sId;
    showSnackBarMessage(context, "Deleting....", true);

    NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.deleteUrl(_taskId!));
    if (response.isSuccess) {
      showSnackBarMessage(context, "Task Deleted", true);
      progressTaskListModel?.taskList?.removeAt(index);
      setState(() {});
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
  }

  Future<void> _upgradeStatus(int index, String status) async {
    if (status == "Progress") {
      showSnackBarMessage(context, "You are in 'Progress status'.", false);
    } else {
      showSnackBarMessage(context, "status updating.....", true);
      final String? _taskId = progressTaskListModel!.taskList![index].sId;

      NetworkResponse response = await NetworkCaller.getRequest(
          url: Urls.UpgradeTask(_taskId!, status));
      if (response.isSuccess) {
        showSnackBarMessage(context, "Task Update", true);
        progressTaskListModel?.taskList?.removeAt(index);
        setState(() {});
      } else {
        showSnackBarMessage(context, response.errorMessage, false);
      }
    }
  }
}
