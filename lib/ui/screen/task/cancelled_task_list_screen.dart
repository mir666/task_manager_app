import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/task_list_by_status_model.dart';
import 'package:task_manager_app/data/services/network_callers.dart';
import 'package:task_manager_app/data/utils/urls.dart';
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
  bool _getCanceledTaskListInProgress = false;
  TaskListByStatusModel? canceledTaskListModel;

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
      child: Visibility(
          visible: _getCanceledTaskListInProgress == false,
          replacement: const CenteredCircularProgressIndicator(),
          child: _buildTaskListView()),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      itemCount: canceledTaskListModel?.taskList?.length ?? 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return TaskItemWidget(
          onTabChangeStatus: (status) {
            _upgradeStatus(index, status);
          },
          onTabDelete: () {
            _deleteTaskItem(index);
          },
          taskModel: canceledTaskListModel!.taskList![index],
        );
      },
    );
  }

  Future<void> _getCanceledTaskList() async {
    _getCanceledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Cancel'));
    if (response.isSuccess) {
      canceledTaskListModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
    _getCanceledTaskListInProgress = false;
    setState(() {});
  }

  Future<void> _deleteTaskItem(int index) async {
    final String? _taskId = canceledTaskListModel!.taskList![index].sId;
    showSnackBarMessage(context, "Deleting....", true);

    NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.deleteUrl(_taskId!));
    if (response.isSuccess) {
      showSnackBarMessage(context, "Task Deleted", true);
      canceledTaskListModel?.taskList?.removeAt(index);
      setState(() {});
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
  }

  Future<void> _upgradeStatus(int index, String status) async {
    if (status == "Cancel") {
      showSnackBarMessage(context, "You are in 'Cancel status'.", false);
    } else {
      showSnackBarMessage(context, "status updating.....", true);
      final String? _taskId = canceledTaskListModel!.taskList![index].sId;

      NetworkResponse response = await NetworkCaller.getRequest(
          url: Urls.UpgradeTask(_taskId!, status));
      if (response.isSuccess) {
        showSnackBarMessage(context, "Task Update", true);
        canceledTaskListModel?.taskList?.removeAt(index);
        setState(() {});
      } else {
        showSnackBarMessage(context, response.errorMessage, false);
      }
    }
  }
}
