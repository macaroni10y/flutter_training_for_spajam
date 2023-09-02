import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/env/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OpenAI.apiKey = Env.apiKey;
  runApp(const MyApp());
}
