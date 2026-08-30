import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/features/tasks/data/models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final void Function(bool isCompleted) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.46,
          children: [
            _SlideAction(
              icon: CupertinoIcons.pencil,
              label: 'Edit',
              color: AppColors.moss,
              onPressed: onEdit,
            ),
            _SlideAction(
              icon: CupertinoIcons.trash,
              label: 'Delete',
              color: AppColors.clay,
              onPressed: onDelete,
            ),
          ],
        ),
        child: _TaskCard(task: task, onToggle: onToggle),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.onToggle});

  final Task task;
  final void Function(bool isCompleted) onToggle;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.surface.withValues(alpha: 0.65)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => onToggle(!isCompleted),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 26,
              height: 26,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.moss : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.moss
                      : AppColors.inkMuted.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      CupertinoIcons.check_mark,
                      size: 15,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTypography.taskTitle.copyWith(
                    color: isCompleted ? AppColors.inkMuted : AppColors.ink,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppColors.inkMuted,
                  ),
                ),

                if (task.note case final note?) ...[
                  const SizedBox(height: 4),
                  Text(
                    note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.toggleSubtitle,
                  ),
                ],

                if (task.isRepeating || task.hasAlarm) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (task.isRepeating)
                        const _Tag(
                          icon: CupertinoIcons.repeat,
                          color: AppColors.moss,
                          label: 'Daily',
                        ),
                      if (task.isRepeating && task.hasAlarm)
                        const SizedBox(width: 8),
                      if (task.hasAlarm)
                        _Tag(
                          icon: CupertinoIcons.alarm,
                          color: AppColors.clay,
                          label: TimeOfDay(
                            hour: task.alarmHour,
                            minute: task.alarmMinute,
                          ).format(context),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideAction extends StatelessWidget {
  const _SlideAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.parchment),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.tag.copyWith(color: AppColors.parchment),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.color, required this.label});

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.tag.copyWith(color: color)),
        ],
      ),
    );
  }
}
