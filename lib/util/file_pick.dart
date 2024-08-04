import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:myapp/models/resume.dart';
import 'package:myapp/services/gemini_service.dart';
import 'package:myapp/services/resume_service.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class FilePickerUtil {
  static Future<void> pickAndParseResumeProfile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result == null) {
        // User canceled the picker
        return;
      }
      final resumeService = Provider.of<ResumeService>(context, listen: false);
      File file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final jsonString = utf8.decode(bytes);
      final resume = Resume.fromJson(jsonString);
      // Save the resume using ResumeService
      resumeService.saveResume(resume);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume successfully parsed and saved!')),
      );
    } catch (e) {
      // Handle errors appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick and parse resume: $e')),
      );
    }
  }

  static Future<void> pickAndParseResume(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileExtension = result.files.single.extension!.toLowerCase();
        String text = await _parseFile(file, fileExtension);

        // Use GeminiService to extract resume information
        final geminiService = GeminiService(gemini: Gemini.instance);
        final resumeService =
            Provider.of<ResumeService>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Extracting resume information...')),
        );
        // Assuming GeminiService has a method to extract resume information
        final resume = await geminiService.extractResume(text);
        if (resume == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to parse resume')),
          );
          return;
        }
        // Save the resume using ResumeService
        resumeService.saveResume(resume);

        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Resume successfully parsed and saved!')),
        );
      }
    } catch (e) {
      // Handle errors appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick and parse resume: $e')),
      );
    }
  }

  static Future<String> _parseFile(File file, String extension) async {
    switch (extension) {
      case 'pdf':
      case 'doc':
      case 'docx':
        return _parseDoc(file);
      default:
        throw UnsupportedError('Unsupported file format: $extension');
    }
  }

  // static Future<String> _parsePdf(File file) async {
  //   PDFDoc doc = await PDFDoc.fromFile(file);
  //   String text = await doc.text;
  //   return text;
  // }

  static Future<String> _parseDoc(File file) async {
    final bytes = await file.readAsBytes();
    final text = docxToText(bytes);
    return text;
  }
}
