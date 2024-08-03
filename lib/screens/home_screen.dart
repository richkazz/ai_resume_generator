// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/screens/job_description_screen.dart';
import 'package:myapp/screens/preview_screen.dart';
import 'package:myapp/screens/resume_input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Builder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ResumeInputScreen())),
              child: const Text('Input Resume'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const JobDescriptionScreen())),
              child: const Text('Enter Job Description'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PreviewScreen())),
              child: const Text('Preview Resume'),
            ),
          ],
        ),
      ),
    );
  }
}
