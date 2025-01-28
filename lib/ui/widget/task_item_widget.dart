import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel taskModel;
  final VoidCallback onTabDelete;
  final ValueChanged onTabChangeStatus;

  TaskItemWidget({
    super.key,
    required this.taskModel,
    required this.onTabDelete,
    required this.onTabChangeStatus,
  });

  final List<String> dropdownItems = [
    'New',
    'Progress',
    'Cancel',
    'Complete',
  ];
  final List<Color> dropdownItemsColor = [
    Colors.lightBlueAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    AppColors.themeColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListTile(
          title: Text(
            taskModel.title ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                taskModel.description ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                taskModel.createdDate ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xff3d3d3d),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: dropdownItemsColor[
                          _getStatusColor(taskModel.status!)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        taskModel.status!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.note_alt_outlined,
                          size: 20,
                          color: Colors.green,
                        ),
                        items: List.generate(
                          dropdownItems.length,
                          (index) {
                            return DropdownMenuItem<String>(
                              value: dropdownItems[index],
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: dropdownItemsColor[index],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: Text(
                                    dropdownItems[index],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        onChanged: onTabChangeStatus,
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: onTabDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<dynamic> buildPopupMenuItem(_title, _color) {
    return PopupMenuItem(
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: _color,
          ),
          const SizedBox(width: 6),
          Text(_title),
        ],
      ),
    );
  }

  int _getStatusColor(String status) {
    if (status == 'New') {
      return 0;
    } else if (status == 'Progress') {
      return 1;
    } else if (status == 'Cancel') {
      return 2;
    } else {
      return 3;
    }
  }
}
