// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/screens/job_description_screen.dart';
import 'package:myapp/screens/preview_screen.dart';
import 'package:myapp/screens/resume_input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  void _pageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            PreviewScreen(
              noResume: () {
                _pageChange(1);
              },
            ),
            const ResumeInputScreen(),
            JobDescriptionScreen(
              noResume: () {
                _pageChange(1);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _pageChange,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.preview), label: 'Preview Resume'),
            BottomNavigationBarItem(
                icon: Icon(Icons.upload_file), label: 'Input Resume'),
            BottomNavigationBarItem(
                icon: Icon(Icons.work), label: 'Generate Resume'),
          ]),
    );
  }
}
