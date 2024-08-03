// services/resume_service.dart
import 'package:flutter/foundation.dart';
import 'package:myapp/models/resume.dart';
import 'package:myapp/services/database_service.dart';
import 'package:myapp/services/gemini_service.dart';

class ResumeService extends ChangeNotifier {
  final DatabaseService _databaseService;
  Resume? _resume;
  Resume? get resume => _resume;
  String? _jobDescription;
  String get jobDescription => _jobDescription!;
  final GeminiService _geminiService;
  ResumeService(this._databaseService, this._geminiService);

  Future<void> loadResume() async {
    _resume = await _databaseService.getResume();
    notifyListeners();
  }

  Future<void> saveResume(Resume resume) async {
    await _databaseService.saveResume(resume);
    _resume = resume;
    notifyListeners();
  }

  Future<void> setJobDescription(String description) async {
    _jobDescription = description;
    notifyListeners();
  }

  Future<Resume?> generateResume() async {
    _resume = await _databaseService.getResume();
    if (_resume == null || _jobDescription == null) return null;

    final generatedResume =
        await _geminiService.generateResume(_resume!, _jobDescription!);

    return generatedResume;
  }

  Future<void> generateCoverLetter() async {
    // if (_resume == null || _jobDescription == null) return;

    // final geminiService = GeminiService();
    // final coverLetter =
    //     await geminiService.generateCoverLetter(_resume!, _jobDescription!);

    // Save or update cover letter
  }
}
