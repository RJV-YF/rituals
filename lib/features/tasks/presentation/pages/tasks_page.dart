import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rituals/core/services/alarm_service.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/core/utils/date_labels.dart';
import 'package:rituals/features/heatmaps/presentation/pages/heatmap_page.dart';
import 'package:rituals/features/tasks/data/models/task.dart';
import 'package:rituals/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:rituals/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:rituals/features/tasks/presentation/pages/task_form_sheet.dart';
import 'package:rituals/features/tasks/presentation/widgets/task_fab.dart';
import 'package:rituals/features/tasks/presentation/widgets/task_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TasksCubit>().refreshDay();
    }
  }

  void _openHeatmap() => Navigator.of(context).push(HeatmapPage.route());

  Future<void> _createTask() async {
    final cubit = context.read<TasksCubit>();
    final draft = await TaskFormSheet.show(context);
    if (draft == null) return;

    _reportAlarm(await cubit.createTask(draft));
  }

  Future<void> _editTask(Task task) async {
    final cubit = context.read<TasksCubit>();
    final draft = await TaskFormSheet.show(context, task: task);
    if (draft == null) return;

    _reportAlarm(await cubit.editTask(task, draft));
  }

  Future<void> _deleteTask(Task task) async {
    final cubit = context.read<TasksCubit>();
    await cubit.deleteTask(task);
    if (!mounted) return;

    _showMessage(
      'Deleted “${task.title}”',
      action: SnackBarAction(
        label: 'Undo',
        textColor: AppColors.parchment,
        onPressed: () => cubit.restoreTask(task),
      ),
    );
  }

  void _reportAlarm(AlarmResult? result) {
    if (!mounted || result == null || result == AlarmResult.set) return;

    _showMessage(switch (result) {
      AlarmResult.noClockApp => 'No clock app on this device to set the alarm.',
      _ => 'Could not set the alarm in your clock app.',
    });
  }

  void _showMessage(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          action: action,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            // The header stays put across states so the day and title don't
            // flash in and out while the list loads.
            final day = switch (state) {
              TasksLoaded(:final day) => day,
              _ => context.read<TasksCubit>().day,
            };

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 14, 8),
                  sliver: SliverToBoxAdapter(
                    child: _Header(
                      day: day,
                      state: state,
                      onHeatmapPressed: _openHeatmap,
                    ),
                  ),
                ),
                _body(state),
              ],
            );
          },
        ),
      ),
      floatingActionButton: TaskFab(onPressed: _createTask),
    );
  }

  Widget _body(TasksState state) {
    switch (state) {
      case TasksLoading():
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.moss),
          ),
        );

      case TasksFailure(:final message):
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _CenteredNotice(title: message),
        );

      case TasksLoaded(:final tasks) when tasks.isEmpty:
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: _CenteredNotice(
            title: 'Start with one thing you want to come back to.',
            detail: 'Anything you mark as repeating shows up again tomorrow.',
          ),
        );

      case TasksLoaded(:final tasks):
        return SliverPadding(
          padding: const EdgeInsets.only(top: 8, bottom: 100),
          sliver: SliverList.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(
                task: task,
                onToggle: (isCompleted) =>
                    context.read<TasksCubit>().setCompleted(task, isCompleted),
                onEdit: () => _editTask(task),
                onDelete: () => _deleteTask(task),
              );
            },
          ),
        );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.day,
    required this.state,
    required this.onHeatmapPressed,
  });

  final DateTime day;
  final TasksState state;
  final VoidCallback onHeatmapPressed;

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (state) {
      TasksLoaded(:final isEmpty, :final keptCount, :final tasks) =>
        isEmpty
            ? 'Nothing on today’s list yet'
            : '$keptCount of ${tasks.length} kept today',
      TasksFailure() => 'Something went wrong',
      TasksLoading() => 'Gathering today’s list…',
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateLabels.dayLine(day).toUpperCase(),
                style: AppTypography.eyebrow,
              ),
              const SizedBox(height: 6),
              const Text('Rituals', style: AppTypography.pageTitle),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTypography.subtitle),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _HeatmapButton(onPressed: onHeatmapPressed),
      ],
    );
  }
}

class _CenteredNotice extends StatelessWidget {
  const _CenteredNotice({required this.title, this.detail});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.emptyMessage,
          ),
          if (detail case final detail?) ...[
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: AppTypography.subtitle,
            ),
          ],
        ],
      ),
    );
  }
}

/// Opens the consistency grid. Sits at the top right of the day's header,
/// where it is reachable without competing with the list itself.
class _HeatmapButton extends StatelessWidget {
  const _HeatmapButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Consistency',
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              CupertinoIcons.square_grid_3x2_fill,
              size: 20,
              color: AppColors.moss,
            ),
          ),
        ),
      ),
    );
  }
}
