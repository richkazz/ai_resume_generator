import 'package:flutter/material.dart';
import 'package:myapp/screens/preview_screen.dart';
import 'package:myapp/services/resume_service.dart';
import 'package:provider/provider.dart';

class JobDescriptionScreen extends StatefulWidget {
  const JobDescriptionScreen({super.key, required this.noResume});
  final VoidCallback noResume;
  @override
  _JobDescriptionScreenState createState() => _JobDescriptionScreenState();
}

class _JobDescriptionScreenState extends State<JobDescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _jobDescription = '';

  @override
  Widget build(BuildContext context) {
    final _resume = context.watch<ResumeService>().resume;
    if (_resume == null) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.upload_file),
          onPressed: widget.noResume,
          label: const Text('Add Resume'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Job Description')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the job description and requirements:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: 'Paste the job description here...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the job description' : null,
                onSaved: (value) => _jobDescription = value!,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveJobDescription,
                  child: const Text('Save and Generate Resume'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveJobDescription() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final resumeService = Provider.of<ResumeService>(context, listen: false);
      resumeService.setJobDescription(_jobDescription);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generating resume')),
      );
      resumeService.generateResume().then((resume) {
        if (resume == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error generating resume')),
          );
          return;
        }
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ResumePreview(
              resume: resume,
            );
          },
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating resume: $error')),
        );
      });
    }
  }
}
