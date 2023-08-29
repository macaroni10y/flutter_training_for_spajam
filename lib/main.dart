import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/env/env.dart';

import 'app.dart';

void main() {
  OpenAI.apiKey = Env.apiKey;
  runApp(const MyApp());
}
