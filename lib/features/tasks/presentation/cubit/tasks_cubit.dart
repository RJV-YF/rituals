import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rituals/core/services/alarm_service.dart';
import 'package:rituals/features/tasks/data/models/task.dart';
import 'package:rituals/features/tasks/data/models/task_draft.dart';
import 'package:rituals/features/tasks/data/task_repository.dart';
import 'package:rituals/features/tasks/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required TaskRepository repository,
    AlarmService alarmService = const AlarmService(),
  }) : _repo = repository,
       _alarms = alarmService,
       super(const TasksLoading());

  final TaskRepository _repo;
  final AlarmService _alarms;

  StreamSubscription<List<Task>>? _subscription;
  DateTime _day = dayOf(DateTime.now());

  /// The day currently on screen. Read by the header while still loading.
  DateTime get day => _day;

  /// Rolls repeating tasks onto today, then follows the day's list.
  Future<void> start() => _openDay(dayOf(DateTime.now()));

  /// Re-checks the date — the app is usually still open when midnight passes,
  /// so this runs on resume as well as at launch.
  Future<void> refreshDay() async {
    final today = dayOf(DateTime.now());
    if (today == _day) return;
    await _openDay(today);
  }

  Future<void> _openDay(DateTime day) async {
    _day = day;
    try {
      await _repo.rollOverInto(day);
    } catch (_) {
      if (!isClosed) {
        emit(const TasksFailure('Could not carry your rituals into today.'));
      }
      return;
    }
    if (isClosed) return;

    await _subscription?.cancel();
    _subscription = _repo
        .watchDay(day)
        .listen(
          (tasks) => emit(TasksLoaded(day: day, tasks: tasks)),
          onError: (_) =>
              emit(const TasksFailure('Could not read your rituals.')),
        );
  }

  /// Saves a new task. Returns how the alarm handoff went, or null when the
  /// task has no alarm — the caller decides whether to report a failure.
  Future<AlarmResult?> createTask(TaskDraft draft) async {
    await _repo.create(
      title: draft.title,
      note: draft.note,
      isRepeating: draft.isRepeating,
      hasAlarm: draft.hasAlarm,
      alarmMinutes: draft.alarmMinutes,
      day: _day,
    );
    if (!draft.hasAlarm) return null;
    return _setAlarm(draft);
  }

  /// Applies [draft] to [task]. The clock app is only touched when the alarm
  /// is new or has moved, so re-saving an unchanged task stays silent.
  Future<AlarmResult?> editTask(Task task, TaskDraft draft) async {
    final alarmChanged =
        draft.hasAlarm &&
        (!task.hasAlarm || draft.alarmMinutes != task.alarmMinutes);

    task
      ..title = draft.title
      ..note = draft.note
      ..isRepeating = draft.isRepeating
      ..hasAlarm = draft.hasAlarm
      ..alarmMinutes = draft.alarmMinutes;
    await _repo.update(task);

    if (!alarmChanged) return null;
    return _setAlarm(draft);
  }

  Future<void> setCompleted(Task task, bool isCompleted) {
    return _repo.setCompleted(task, isCompleted);
  }

  Future<void> deleteTask(Task task) => _repo.delete(task.id);

  /// Puts a deleted task back with its original id, so undo restores the row
  /// rather than creating a near-duplicate.
  Future<void> restoreTask(Task task) => _repo.restore(task);

  Future<AlarmResult> _setAlarm(TaskDraft draft) {
    final minutes = draft.alarmMinutes!;
    return _alarms.setAlarm(
      hour: minutes ~/ 60,
      minute: minutes % 60,
      label: draft.title,
      daily: draft.isRepeating,
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
