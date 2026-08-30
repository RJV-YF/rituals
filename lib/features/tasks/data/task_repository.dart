import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rituals/features/tasks/data/models/task.dart';

class TaskRepository {
  TaskRepository(this._isar);

  final Isar _isar;

  static Future<TaskRepository> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([TaskSchema], directory: dir.path);
    return TaskRepository(isar);
  }

  /// Live list of the tasks belonging to [day], oldest first.
  Stream<List<Task>> watchDay(DateTime day) {
    return _isar.tasks
        .filter()
        .dateEqualTo(dayOf(day))
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  Future<List<Task>> tasksForDay(DateTime day) {
    return _isar.tasks
        .filter()
        .dateEqualTo(dayOf(day))
        .sortByCreatedAt()
        .findAll();
  }

  Future<Task> create({
    required String title,
    String? note,
    required bool isRepeating,
    required bool hasAlarm,
    int? alarmMinutes,
    DateTime? day,
  }) async {
    final task = Task()
      ..seriesId = 0
      ..title = title
      ..note = note
      ..isRepeating = isRepeating
      ..hasAlarm = hasAlarm
      ..alarmMinutes = alarmMinutes
      ..date = dayOf(day ?? DateTime.now())
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      // A new task starts its own series, identified by its own row id.
      task.id = await _isar.tasks.put(task);
      task.seriesId = task.id;
      await _isar.tasks.put(task);
    });
    return task;
  }

  Future<void> update(Task task) {
    return _isar.writeTxn(() => _isar.tasks.put(task));
  }

  Future<void> setCompleted(Task task, bool isCompleted) {
    task.isCompleted = isCompleted;
    return update(task);
  }

  Future<void> delete(int id) {
    return _isar.writeTxn(() => _isar.tasks.delete(id));
  }

  /// Re-inserts a task keeping its id and series, so an undo restores the row
  /// exactly where it was rather than creating a near-duplicate.
  Future<void> restore(Task task) {
    return _isar.writeTxn(() => _isar.tasks.put(task));
  }

  /// Carries repeating tasks forward onto [today].
  ///
  /// Looks at the most recent instance of each series before today: if that
  /// one still has repeat switched on and the series has nothing on today yet,
  /// a fresh uncompleted copy is added. Turning repeat off on a task is
  /// therefore what ends the series — the next rollover simply skips it.
  ///
  /// Safe to call on every launch; it is a no-op once today is populated.
  Future<int> rollOverInto(DateTime today) async {
    final day = dayOf(today);

    final past = await _isar.tasks.filter().dateLessThan(day).findAll();
    if (past.isEmpty) return 0;

    // Most recent instance per series decides whether the series continues.
    final latest = <int, Task>{};
    for (final task in past) {
      final current = latest[task.seriesId];
      if (current == null || task.date.isAfter(current.date)) {
        latest[task.seriesId] = task;
      }
    }

    final existing = (await _isar.tasks.filter().dateEqualTo(day).findAll())
        .map((task) => task.seriesId)
        .toSet();

    final carried = [
      for (final task in latest.values)
        if (task.isRepeating && !existing.contains(task.seriesId))
          task.copyForDay(day),
    ];
    if (carried.isEmpty) return 0;

    await _isar.writeTxn(() => _isar.tasks.putAll(carried));
    return carried.length;
  }

  Future<void> close() => _isar.close();
}
