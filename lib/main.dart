import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prompt_app/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String apiKey = String.fromEnvironment('API_KEY');
late PackageInfo packageInfo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();

  String supabaseUrl = "";
  String supabaseAnonKey = "";

  try {
    supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
    supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  } catch (e, s) {
    log(
      "Supabase initialization error!",
      name: "main.dart",
      stackTrace: s,
      error: e,
    );
  } finally {
    runApp(const PromptApp());
  }
}
