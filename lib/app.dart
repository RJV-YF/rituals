import 'package:flutter/material.dart';
import 'package:rituals/core/theme/app_theme.dart';
import 'package:rituals/features/tasks/data/task_repository.dart';
import 'package:rituals/features/tasks/presentation/pages/tasks_page.dart';

class App extends StatelessWidget {
  const App({super.key, required this.repository});

  final TaskRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: TasksPage(repository: repository),
    );
  }
}
