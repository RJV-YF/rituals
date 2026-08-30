import 'package:flutter/material.dart';
import 'package:rituals/app.dart';
import 'package:rituals/features/tasks/data/task_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = await TaskRepository.open();
  await repository.rollOverInto(DateTime.now());

  runApp(App(repository: repository));
}
