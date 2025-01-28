import 'package:flutter/material.dart';

class TaskStatusSummaryCounterWidget extends StatelessWidget {
  const TaskStatusSummaryCounterWidget({
    super.key,
    required this.count,
    required this.title,
  });

  final String count;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textThem = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: textThem.titleLarge,
            ),
            Text(
              title,
              style: textThem.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
