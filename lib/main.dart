import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prompt_app/app.dart';

const String apiKey = String.fromEnvironment('API_KEY');
late PackageInfo packageInfo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();

  runApp(PromptApp());
}
