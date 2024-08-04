import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/resume.dart';
import 'package:myapp/widgets/chip_input.dart';
import 'package:myapp/widgets/custom_delete_dialog.dart';
import 'package:myapp/widgets/date_picker_form_field.dart';

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
    buildTextInitialControllers();
  }

  void buildTextInitialControllers() {
    _buildDisposeControllers();
    _positionControllers.clear();
    _companyControllers.clear();
    _startDateControllers.clear();
    _endDateControllers.clear();
    _responsibilityControllers.clear();
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

  void _buildDisposeControllers() {
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
  }

  @override
  void dispose() {
    _buildDisposeControllers();
    super.dispose();
  }

  void _delete(WorkExperience cert) {
    showConfirmationDialog(context, "certification", () {
      setState(() {
        widget._resume.workExperience.remove(cert);
      });
    });
  }

  List<Widget> _buildWorkExperienceList() {
    if (widget._resume.workExperience.isNotEmpty &&
        _positionControllers.isEmpty) {
      buildTextInitialControllers();
    }
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
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () =>
                        _delete(widget._resume.workExperience[index]),
                    icon: const Icon(Icons.delete_forever)),
              ),
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
                    child: DatePickerFormField(
                      initialDate:
                          widget._resume.workExperience[index].startDate,
                      labelText: 'Start Date',
                      onSaved: (value) {
                        _startDateControllers[index].text =
                            DateFormat('MMM yyyy').format(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DatePickerFormField(
                      initialDate: widget._resume.workExperience[index].endDate,
                      labelText: 'End Date',
                      onSaved: (value) {
                        _startDateControllers[index].text =
                            DateFormat('MMM yyyy').format(value!);
                      },
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
                initialValues:
                    widget._resume.workExperience[index].responsibilities,
                onChanged: (p0) =>
                    widget._resume.workExperience[index].responsibilities = p0,
              )
            ],
          ),
        ),
      );
    });
  }

  void _addWorkExperience() {
    setState(() {
      widget._resume.workExperience.add(WorkExperience(
        company: '',
        position: '',
        startDate: DateTime.now(),
        responsibilities: [],
      ));
      buildTextInitialControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget._resume.workExperience.isNotEmpty)
            ..._buildWorkExperienceList(),
          ElevatedButton.icon(
            onPressed: _addWorkExperience,
            icon: const Icon(Icons.add),
            label: const Text('Add Work Experience'),
          ),
        ]);
  }
}
