import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/resume.dart';
import 'package:myapp/services/resume_service.dart';
import 'package:myapp/util/file_pick.dart';
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
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Resume (PDF/DOC)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection('Personal Information', [
                  _buildTextField('Full Name', _resume.name,
                      (value) => _resume.name = value),
                  _buildTextField(
                      'Email', _resume.email, (value) => _resume.email = value),
                  _buildTextField('Phone Number', _resume.phoneNumber,
                      (value) => _resume.phoneNumber = value),
                  _buildTextField('Address', _resume.address,
                      (value) => _resume.address = value),
                  _buildTextField(
                      'LinkedIn',
                      _resume.contactInformation?.linkedin,
                      (value) => _resume.contactInformation =
                          ContactInformation(linkedin: value)),
                ]),
                _buildTextField('Objective', _resume.objective,
                    (value) => _resume.objective = value,
                    maxLines: 3),
                _buildTextField('Profile', _resume.profile,
                    (value) => _resume.profile = value,
                    maxLines: 3),
                const SizedBox(height: 16),
                ChipInput(
                  label: 'Skills',
                  initialValues: _resume.skills,
                  onChanged: (values) => _resume.skills = values,
                ),
                const HeightTextFieldSpacer(),
                _buildSection('Work Experience', [
                  if (_resume.workExperience.isNotEmpty)
                    WorkExperienceWidget(_resume),
                  ElevatedButton.icon(
                    onPressed: _addWorkExperience,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Work Experience'),
                  ),
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
                  ..._buildCertificationList(),
                  ElevatedButton.icon(
                    onPressed: _addCertification,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Certification'),
                  ),
                ]),
                _buildTextField('Referee', _resume.referee,
                    (value) => _resume.referee = value),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saveResume,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Resume'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                  ),
                ),
              ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
        onSaved: onSaved,
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
      Navigator.pop(context);
    }
  }

  Future<void> _pickFile() async {
    await FilePickerUtil.pickAndParseResume(context);
  }

  List<Widget> _buildProjectList() {
    return _resume.projects.map((project) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: project.name,
                decoration: const InputDecoration(labelText: 'Project Name'),
                onSaved: (value) => project.name = value,
              ),
              const HeightTextFieldSpacer(),
              TextFormField(
                initialValue: project.description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => project.description = value,
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
              TextFormField(
                initialValue: cert.date?.toString(),
                decoration: const InputDecoration(labelText: 'Date'),
                onSaved: (value) => cert.date = DateTime.tryParse(value ?? ''),
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

  void _addCertification() {
    setState(() => _resume.certifications.add(Certification()));
  }

  void _addSkill() {
    setState(() => _resume.skills.add(''));
  }

  void _addWorkExperience() {
    setState(() => _resume.workExperience.add(WorkExperience(
          company: '',
          position: '',
          startDate: DateTime.now(),
          responsibilities: [],
        )));
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

class ChipInput extends StatefulWidget {
  final String label;
  final List<String> initialValues;
  final Function(List<String>) onChanged;

  const ChipInput({
    Key? key,
    required this.label,
    required this.initialValues,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ChipInputState createState() => _ChipInputState();
}

class _ChipInputState extends State<ChipInput> {
  late List<String> _values;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _values = List.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        Wrap(
          spacing: 8,
          children: _values
              .map((value) => Chip(
                    label: Text(value),
                    onDeleted: () {
                      setState(() {
                        _values.remove(value);
                        widget.onChanged(_values);
                      });
                    },
                  ))
              .toList(),
        ),
        const HeightTextFieldSpacer(),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Add ${widget.label}',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addValue,
            ),
          ),
          onSubmitted: (_) => _addValue(),
        ),
      ],
    );
  }

  void _addValue() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _values.add(_controller.text);
        widget.onChanged(_values);
        _controller.clear();
      });
    }
  }
}

class WorkExperienceWidget extends StatefulWidget {
  final Resume _resume;

  const WorkExperienceWidget(this._resume, {super.key});

  @override
  _WorkExperienceState createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperienceWidget> {
  final List<TextEditingController> _positionControllers = [];
  final List<TextEditingController> _companyControllers = [];
  final List<TextEditingController> _startDateControllers = [];
  final List<TextEditingController> _endDateControllers = [];
  final List<List<TextEditingController>> _responsibilityControllers = [];

  @override
  void initState() {
    super.initState();
    for (var workExperience in widget._resume.workExperience) {
      _positionControllers
          .add(TextEditingController(text: workExperience.position));
      _companyControllers
          .add(TextEditingController(text: workExperience.company));
      _startDateControllers.add(TextEditingController(
        text: workExperience.startDate != null
            ? DateFormat('MMM yyyy').format(workExperience.startDate!)
            : '',
      ));
      _endDateControllers.add(TextEditingController(
        text: workExperience.endDate != null
            ? DateFormat('MMM yyyy').format(workExperience.endDate!)
            : 'Present',
      ));
      _responsibilityControllers.add(workExperience.responsibilities
          .map((resp) => TextEditingController(text: resp))
          .toList());
    }
  }

  @override
  void dispose() {
    for (var controller in _positionControllers) {
      controller.dispose();
    }
    for (var controller in _companyControllers) {
      controller.dispose();
    }
    for (var controller in _startDateControllers) {
      controller.dispose();
    }
    for (var controller in _endDateControllers) {
      controller.dispose();
    }
    for (var controllers in _responsibilityControllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  List<Widget> _buildWorkExperienceList() {
    return List<Widget>.generate(widget._resume.workExperience.length, (index) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _positionControllers[index],
                decoration: const InputDecoration(
                  labelText: 'Position',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _companyControllers[index],
                decoration: InputDecoration(
                  labelText: 'Company',
                  icon: Icon(Icons.business, color: Colors.grey[600]),
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        icon: Icon(Icons.date_range, color: Colors.grey[600]),
                      ),
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateControllers[index],
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        icon: Icon(Icons.date_range, color: Colors.grey[600]),
                      ),
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Responsibilities:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              ChipInput(
                label: 'Responsibilities',
                 initialValues: widget._resume.workExperience[index].responsibilities,
                  onChanged: (p0) => widget._resume.workExperience[index].responsibilities = p0,)
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildWorkExperienceList(),
    );
  }
}
