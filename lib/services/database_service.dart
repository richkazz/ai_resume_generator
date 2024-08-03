// services/database_service.dart
import 'package:hive/hive.dart';
import 'package:myapp/models/resume.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static const String _resumeBoxName = 'resumeBox2';
  late Box<Resume> _resumeBox;

  static Future<DatabaseService> initialize() async {
    Hive.registerAdapter(ResumeAdapter());
    Hive.registerAdapter(WorkExperienceAdapter());
    Hive.registerAdapter(EducationAdapter());
    Hive.registerAdapter(ProjectAdapter());
    Hive.registerAdapter(ContactInformationAdapter());
    Hive.registerAdapter(CertificationAdapter());
    final instance = DatabaseService();
    await instance._openBox();
    return instance;
  }

  Future<void> _openBox() async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    _resumeBox =
        await Hive.openBox<Resume>(_resumeBoxName, path: appDocumentsDir.path);
  }

  Future<void> saveResume(Resume resume) async {
    await _resumeBox.put('currentResume', resume);
  }

  Future<Resume?> getResume() async {
    return _resumeBox.get('currentResume');
  }
}
