import 'package:flutter/material.dart';
import 'package:rituals/core/services/alarm_service.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/features/tasks/data/models/task.dart';
import 'package:rituals/features/tasks/data/task_repository.dart';
import 'package:rituals/features/tasks/presentation/pages/task_form_sheet.dart';
import 'package:rituals/features/tasks/presentation/widgets/task_fab.dart';
import 'package:rituals/features/tasks/presentation/widgets/task_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({
    super.key,
    required this.repository,
    this.alarmService = const AlarmService(),
  });

  final TaskRepository repository;
  final AlarmService alarmService;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with WidgetsBindingObserver {
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = dayOf(DateTime.now());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshDay();
  }

  Future<void> _refreshDay() async {
    final now = dayOf(DateTime.now());
    if (now == _today) return;
    await widget.repository.rollOverInto(now);
    if (!mounted) return;
    setState(() => _today = now);
  }

  Future<void> _createTask() async {
    final draft = await TaskFormSheet.show(context);
    if (draft == null) return;

    await widget.repository.create(
      title: draft.title,
      note: draft.note,
      isRepeating: draft.isRepeating,
      hasAlarm: draft.hasAlarm,
      alarmMinutes: draft.alarmMinutes,
      day: _today,
    );

    if (draft.hasAlarm) {
      await _sendToClockApp(
        draft.title,
        draft.alarmMinutes!,
        draft.isRepeating,
      );
    }
  }

  Future<void> _editTask(Task task) async {
    final draft = await TaskFormSheet.show(context, task: task);
    if (draft == null) return;

    final alarmChanged =
        draft.hasAlarm &&
        (!task.hasAlarm || draft.alarmMinutes != task.alarmMinutes);

    task
      ..title = draft.title
      ..note = draft.note
      ..isRepeating = draft.isRepeating
      ..hasAlarm = draft.hasAlarm
      ..alarmMinutes = draft.alarmMinutes;
    await widget.repository.update(task);

    if (alarmChanged) {
      await _sendToClockApp(
        draft.title,
        draft.alarmMinutes!,
        draft.isRepeating,
      );
    }
  }

  Future<void> _deleteTask(Task task) async {
    await widget.repository.delete(task.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Deleted “${task.title}”'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppColors.parchment,
            onPressed: () => widget.repository.restore(task),
          ),
        ),
      );
  }

  Future<void> _sendToClockApp(String title, int minutes, bool daily) async {
    final result = await widget.alarmService.setAlarm(
      hour: minutes ~/ 60,
      minute: minutes % 60,
      label: title,
      daily: daily,
    );
    if (!mounted || result == AlarmResult.set) return;

    final message = switch (result) {
      AlarmResult.noClockApp => 'No clock app on this device to set the alarm.',
      _ => 'Could not set the alarm in your clock app.',
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: StreamBuilder<List<Task>>(
          stream: widget.repository.watchDay(_today),
          builder: (context, snapshot) {
            final tasks = snapshot.data ?? const <Task>[];
            final kept = tasks.where((task) => task.isCompleted).length;

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDay(_today).toUpperCase(),
                          style: AppTypography.eyebrow,
                        ),
                        const SizedBox(height: 6),
                        const Text('Rituals', style: AppTypography.pageTitle),
                        const SizedBox(height: 4),
                        Text(
                          tasks.isEmpty
                              ? 'Nothing on today’s list yet'
                              : '$kept of ${tasks.length} kept today',
                          style: AppTypography.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),

                if (tasks.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyList(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    sliver: SliverList.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTile(
                          task: task,
                          onToggle: (isCompleted) =>
                              widget.repository.setCompleted(task, isCompleted),
                          onEdit: () => _editTask(task),
                          onDelete: () => _deleteTask(task),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: TaskFab(onPressed: _createTask),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Start with one thing you want to come back to.',
            textAlign: TextAlign.center,
            style: AppTypography.emptyMessage,
          ),
          const SizedBox(height: 8),
          Text(
            'Anything you mark as repeating shows up again tomorrow.',
            textAlign: TextAlign.center,
            style: AppTypography.subtitle,
          ),
        ],
      ),
    );
  }
}

const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String _formatDay(DateTime day) {
  return '${_weekdays[day.weekday - 1]} · ${day.day} ${_months[day.month - 1]}';
}
