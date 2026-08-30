import 'package:rituals/features/tasks/data/models/task.dart';

/// State of the day's task list.
///
/// These states intentionally do not override `==`. [Task] is a mutable Isar
/// object with identity equality, so a value-based comparison here would be
/// unreliable — and a state wrongly judged equal is one bloc drops, leaving
/// the list stale after an edit. Rebuilding on every emit is the safe trade.
sealed class TasksState {
  const TasksState();
}

/// Opening the database and rolling repeating tasks onto today.
class TasksLoading extends TasksState {
  const TasksLoading();
}

class TasksLoaded extends TasksState {
  const TasksLoaded({required this.day, required this.tasks});

  /// The day the list belongs to, at local midnight.
  final DateTime day;
  final List<Task> tasks;

  bool get isEmpty => tasks.isEmpty;
  int get keptCount => tasks.where((task) => task.isCompleted).length;
}

class TasksFailure extends TasksState {
  const TasksFailure(this.message);

  final String message;
}
