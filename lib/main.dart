// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:myapp/consts/environment_variables.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/services/database_service.dart';
import 'package:myapp/services/gemini_service.dart';
import 'package:myapp/services/resume_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: EnvironmentVariables.geminiKey);
  final databaseService = await DatabaseService.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ResumeService(
                databaseService, GeminiService(gemini: Gemini.instance))),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
