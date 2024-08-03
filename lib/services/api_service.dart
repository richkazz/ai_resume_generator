import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:myapp/models/resume.dart';

class ResumeApiService {
  final String baseUrl;
  final http.Client _httpClient;

  ResumeApiService({required this.baseUrl, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<Uint8List> generateResume(Resume resume) async {
    final url = Uri.parse('$baseUrl/api/resume');

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(resume.toJson()),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw ApiException(
            'Failed to generate resume. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error generating resume: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
