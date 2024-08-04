import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:myapp/models/resume.dart';

class GeminiService {
  final Gemini _gemini;

  GeminiService({required Gemini gemini}) : _gemini = gemini;

  Future<Resume?> generateResume(
      Resume currentResume, String jobDescription) async {
    final jsonResult = await readJsonFromAssets('jsons/prompt.json');
    var prompt = jsonResult['resume_generation']['prompt'] as String;
    prompt =
        prompt.replaceFirst('resume_json', json.encode(currentResume.toJson()));
    prompt = prompt.replaceFirst('job_description', jobDescription);
    final expectedOutPut =
        json.encode(jsonResult['resume_generation']['expected_output']);
    final response =
        await _gemini.text('$prompt\n\nOutput Format: $expectedOutPut');

    if (response?.output == null) {
      return null;
    }
    final indexOpenBracket = response!.output!.indexOf('{');
    final indexCloseBracket = response.output!.lastIndexOf('}');
    final formattedOutput =
        response.output!.substring(indexOpenBracket, indexCloseBracket + 1);
    log(formattedOutput);
    final resume = Resume.fromJson(formattedOutput);
    return resume;
  }

  Future<String> generateCoverLetter(
      Resume resume, String jobDescription) async {
    final prompt =
        "Based on the following resume and job description, generate a professional cover letter. Resume: ${resume.toJson()}. Job Description: $jobDescription";

    final response = await _gemini.text(prompt);
    return response?.output ?? '';
  }

// Mocked method for extracting resume information from text
  Future<Resume?> extractResume(String text) async {
    final jsonResult = await readJsonFromAssets('jsons/prompt.json');
    var prompt = jsonResult['resume_extraction']['prompt'] as String;
    prompt = prompt.replaceFirst('resume_text', text);
    final expectedOutPut =
        json.encode(jsonResult['resume_extraction']['expected_output']);
    final response =
        await _gemini.text('$prompt\n\nExpected Output: $expectedOutPut');

    if (response?.output == null) {
      return null;
    }
    final indexOpenBracket = response!.output!.indexOf('{');
    final indexCloseBracket = response.output!.lastIndexOf('}');
    final formattedOutput =
        response.output!.substring(indexOpenBracket, indexCloseBracket + 1);
    log(formattedOutput);
    final resume = Resume.fromJson(formattedOutput);
    return resume;
  }
}

Future<Map<String, dynamic>> readJsonFromAssets(String filePath) async {
  try {
    final jsonString = await rootBundle.loadString('assets/$filePath');
    log(jsonString);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  } catch (e) {
    log('Error reading JSON file: $e');
    return {};
  }
}
