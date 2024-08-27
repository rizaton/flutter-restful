import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  await dotenv.load(fileName: ".env");
  runApp(MyApp(
    settingsController: settingsController,
  ));
}
