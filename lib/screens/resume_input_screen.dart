import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/resume.dart';
import 'package:myapp/services/resume_service.dart';
import 'package:myapp/spacing/app_spacing.dart';
import 'package:myapp/themes/themes.dart';
import 'package:myapp/util/file_pick.dart';
import 'package:myapp/widgets/chip_input.dart';
import 'package:myapp/widgets/custom_delete_dialog.dart';
import 'package:myapp/widgets/date_picker_form_field.dart';
import 'package:myapp/widgets/input_text_field.dart';
import 'package:myapp/widgets/work_experience.dart';
import 'package:provider/provider.dart';

class ResumeInputScreen extends StatefulWidget {
  const ResumeInputScreen({super.key});

  @override
  _ResumeInputScreenState createState() => _ResumeInputScreenState();
}

class _ResumeInputScreenState extends State<ResumeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  late Resume _resume;

  @override
  void initState() {
    super.initState();
    Provider.of<ResumeService>(context, listen: false).loadResume();
    _resume =
        Provider.of<ResumeService>(context, listen: false).resume ?? Resume();
  }

  List<Widget> _buildView() {
    return [
      Wrap(
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        children: [
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Resume (DOC)'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _pickProfileFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Json profile'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      BuildSection('Personal Information', [
        _buildTextField(
            'Full Name', _resume.name, (value) => _resume.name = value),
        _buildTextField(
            'Email', _resume.email, (value) => _resume.email = value),
        _buildTextField('Phone Number', _resume.phoneNumber,
            (value) => _resume.phoneNumber = value),
        _buildTextField(
            'Address', _resume.address, (value) => _resume.address = value),
        _buildTextField(
            'LinkedIn',
            _resume.contactInformation?.linkedin,
            (value) => _resume.contactInformation =
                ContactInformation(linkedin: value)),
      ]),
      _buildTextField(
          'Objective', _resume.objective, (value) => _resume.objective = value,
          maxLines: 3),
      _buildTextField(
          'Profile', _resume.profile, (value) => _resume.profile = value,
          maxLines: 3),
      const SizedBox(height: 16),
      BuildSection('Skills', [
        ChipInput(
          label: 'Skill',
          useAsLabel: false,
          initialValues: _resume.skills,
          onChanged: (values) => _resume.skills = values,
        ),
      ]),
      const HeightTextFieldSpacer(),
      _buildSection('Work Experience', [
        WorkExperienceWidget(_resume),
      ]),
      _buildSection('Education', [
        ..._buildEducationList(),
        ElevatedButton.icon(
          onPressed: _addEducation,
          icon: const Icon(Icons.add),
          label: const Text('Add Education'),
        ),
      ]),
      _buildSection('Projects', [
        ..._buildProjectList(),
        ElevatedButton.icon(
          onPressed: _addProject,
          icon: const Icon(Icons.add),
          label: const Text('Add Project'),
        ),
      ]),
      _buildSection('Certifications', [
        CertificationList(
          certifications: _resume.certifications,
        ),
      ]),
      _buildTextField(
          'Referee', _resume.referee, (value) => _resume.referee = value),
      const SizedBox(height: 32),
      Center(
        child: ElevatedButton.icon(
          onPressed: _saveResume,
          icon: const Icon(Icons.save),
          label: const Text('Save Resume'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _resume = context.watch<ResumeService>().resume ?? Resume();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Your Resume'),
        elevation: 0,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField(
      String label, String? initialValue, Function(String?) onSaved,
      {int maxLines = 1}) {
    final controller = TextEditingController(text: initialValue);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppInputTextField(
        controller: controller,
        labelText: label,
        useExternalLabel: false,
        onChanged: onSaved,
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  List<Widget> _buildEducationList() {
    return _resume.education.map((education) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                education.degree ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(education.institution ?? ''),
              const SizedBox(height: 8),
              Text(education.graduationDate == null
                  ? ''
                  : DateFormat('yyyy').format(education.graduationDate!)),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _addEducation() {
    setState(() => _resume.education.add(Education(
          institution: '',
          degree: '',
          graduationDate: DateTime.now(),
        )));
  }

  void _saveResume() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<ResumeService>(context, listen: false).saveResume(_resume);
    }
  }

  Future<void> _pickFile() async {
    await FilePickerUtil.pickAndParseResume(context);
  }

  Future<void> _pickProfileFile() async {
    await FilePickerUtil.pickAndParseResumeProfile(context);
  }

  List<Widget> _buildProjectList() {
    return _resume.projects.map((project) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                'Project Name',
                project.name,
                (value) => project.name = value,
              ),
              const HeightTextFieldSpacer(),
              _buildTextField(
                'Description',
                project.description,
                (value) => project.description = value,
                maxLines: 3,
              ),
              const HeightTextFieldSpacer(),
              ChipInput(
                label: 'Technologies',
                initialValues: project.technologies,
                onChanged: (values) => project.technologies = values,
              ),
              const HeightTextFieldSpacer(),
              ChipInput(
                label: 'Key Features',
                initialValues: project.keyFeatures,
                onChanged: (values) => project.keyFeatures = values,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildCertificationList() {
    return _resume.certifications.map((cert) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.delete_forever)),
              ),
              TextFormField(
                initialValue: cert.name,
                decoration:
                    const InputDecoration(labelText: 'Certification Name'),
                onSaved: (value) => cert.name = value,
              ),
              const HeightTextFieldSpacer(),
              TextFormField(
                initialValue: cert.organization,
                decoration: const InputDecoration(labelText: 'Organization'),
                onSaved: (value) => cert.organization = value,
              ),
              const HeightTextFieldSpacer(),
              DatePickerFormField(
                initialDate: cert.date, // Or any initial DateTime
                labelText: 'Date',
                onSaved: (value) => cert.date = value,
              ),
              const HeightTextFieldSpacer(),
              TextFormField(
                initialValue: cert.verificationLink,
                decoration:
                    const InputDecoration(labelText: 'Verification Link'),
                onSaved: (value) => cert.verificationLink = value,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _addProject() {
    setState(() => _resume.projects.add(Project()));
  }

  void _addSkill() {
    setState(() => _resume.skills.add(''));
  }
}

class BuildSection extends StatelessWidget {
  const BuildSection(this.title, this.children, {super.key});
  final List<Widget> children;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }
}

class CertificationList extends StatefulWidget {
  const CertificationList({super.key, required this.certifications});
  final List<Certification> certifications;

  @override
  State<CertificationList> createState() => _CertificationListState();
}

class _CertificationListState extends State<CertificationList> {
  void _addCertification() {
    setState(() => widget.certifications.add(Certification()));
  }

  void _deleteCertification(Certification cert) {
    showConfirmationDialog(context, "certification", () {
      setState(() {
        widget.certifications.remove(cert);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.certifications.map((cert) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () => _deleteCertification(cert),
                        icon: const Icon(Icons.delete_forever)),
                  ),
                  TextFormField(
                    initialValue: cert.name,
                    decoration:
                        const InputDecoration(labelText: 'Certification Name'),
                    onSaved: (value) => cert.name = value,
                  ),
                  const HeightTextFieldSpacer(),
                  TextFormField(
                    initialValue: cert.organization,
                    decoration:
                        const InputDecoration(labelText: 'Organization'),
                    onSaved: (value) => cert.organization = value,
                  ),
                  const HeightTextFieldSpacer(),
                  DatePickerFormField(
                    initialDate: cert.date, // Or any initial DateTime
                    labelText: 'Date',
                    onSaved: (value) => cert.date = value,
                  ),
                  const HeightTextFieldSpacer(),
                  TextFormField(
                    initialValue: cert.verificationLink,
                    decoration:
                        const InputDecoration(labelText: 'Verification Link'),
                    onSaved: (value) => cert.verificationLink = value,
                  ),
                ],
              ),
            ),
          );
        }),
        ElevatedButton.icon(
          onPressed: _addCertification,
          icon: const Icon(Icons.add),
          label: const Text('Add Certification'),
        ),
      ],
    );
  }
}

class HeightTextFieldSpacer extends StatelessWidget {
  const HeightTextFieldSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}
