import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rituals/core/database/app_database.dart';
import 'package:rituals/core/theme/app_theme.dart';
import 'package:rituals/features/tasks/data/task_repository.dart';
import 'package:rituals/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:rituals/features/tasks/presentation/pages/tasks_page.dart';

class App extends StatelessWidget {
  const App({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => TaskRepository(database),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: BlocProvider(
          create: (context) =>
              TasksCubit(repository: context.read<TaskRepository>())..start(),
          child: const TasksPage(),
        ),
      ),
    );
  }
}
