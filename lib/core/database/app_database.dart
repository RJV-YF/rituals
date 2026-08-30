import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rituals/features/tasks/data/models/task.dart';

/// Owns the app's single Isar instance.
///
/// Everything Isar needs to come up — where the file lives, which schemas are
/// registered — lives here, so features receive an open [Isar] and never deal
/// with opening one themselves.
class AppDatabase {
  const AppDatabase(this.isar);

  final Isar isar;

  /// Every collection in the app. New collections get added here.
  static const _schemas = [TaskSchema];

  static Future<AppDatabase> open() async {
    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(_schemas, directory: directory.path);
    return AppDatabase(isar);
  }

  Future<void> close() => isar.close();
}
