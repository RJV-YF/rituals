import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rituals/core/theme/app_colors.dart';

class TaskFab extends StatelessWidget {
  const TaskFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.ink,
      foregroundColor: AppColors.parchment,
      elevation: 2,
      shape: const CircleBorder(),
      onPressed: onPressed,
      tooltip: 'New ritual',
      heroTag: 'add_task_button',
      child: const Icon(CupertinoIcons.add, size: 26),
    );
  }
}
