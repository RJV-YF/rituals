import 'package:flutter/material.dart';
import 'package:rituals/features/tasks/presentation/widgets/task_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  void toggleCheckbox(bool? value, int index) {
    setState(() {
      taskList[index][1] = value!;
    });
  }

  final taskList = [
    ["Morning Run", false, false, false],
    ["Yoga", true, false, false],
    ["Drink Water", false, true, false],
    ["Read a Book", true, false, true],
    ["Meditation", false, true, true],
    ["Write Journal", true, false, false],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            final task = taskList[index];
            return TaskTile(
              taskTitle: task[0] as String,
              isCompleted: task[1] as bool,
              isRepeating: task[2] as bool,
              isAlarm: task[3] as bool,
              onChanged: (value) => toggleCheckbox(value, index),
            );
          },
        ),
      ),
    );
  }
}
