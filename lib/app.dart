import 'package:flutter/material.dart';
import 'package:rituals/features/tasks/presentation/pages/tasks_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TasksPage(),
    );
  }
}
