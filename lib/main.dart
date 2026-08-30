import 'package:flutter/material.dart';
import 'package:rituals/app.dart';
import 'package:rituals/core/database/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await AppDatabase.open();

  runApp(App(database: database));
}
