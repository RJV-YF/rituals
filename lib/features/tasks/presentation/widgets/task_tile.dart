import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    this.onChanged,
    required this.taskTitle,
    required this.isCompleted,
    required this.isRepeating,
    required this.isAlarm,
  });

  final void Function(bool?)? onChanged;
  final String taskTitle;
  final bool isCompleted;
  final bool isRepeating;
  final bool isAlarm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              shape: const CircleBorder(),
              value: isCompleted,
              onChanged: onChanged,
              side: BorderSide(color: Colors.grey.shade400, width: 2),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(CupertinoIcons.repeat, size: 18),

                      const SizedBox(width: 12),

                      const Icon(CupertinoIcons.alarm, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
