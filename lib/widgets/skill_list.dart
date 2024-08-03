import 'package:flutter/material.dart';

class SkillsListWidget extends StatefulWidget {
  final List<String> skills;
  final Function(List<String>) onSkillsChanged;
  final bool isEditMode;

  const SkillsListWidget({
    super.key,
    required this.skills,
    required this.onSkillsChanged,
    this.isEditMode = true,
  });

  @override
  _SkillsListWidgetState createState() => _SkillsListWidgetState();
}

class _SkillsListWidgetState extends State<SkillsListWidget> {
  bool _isEditMode = false;
  late List<String> _editableSkills;

  @override
  void initState() {
    super.initState();
    _editableSkills = List.from(widget.skills);
  }

  Widget _buildSkillItem(int index, String skill) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _isEditMode
          ? _buildEditableSkill(index, skill)
          : _buildViewableSkill(skill),
    );
  }

  Widget _buildViewableSkill(String skill) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        skill,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEditableSkill(int index, String skill) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextFormField(
              initialValue: skill,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) => _editableSkills[index] = value,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () => setState(() => _editableSkills.removeAt(index)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.isEditMode)
              TextButton.icon(
                icon: Icon(_isEditMode ? Icons.check : Icons.edit),
                label: Text(_isEditMode ? 'Save' : 'Edit'),
                onPressed: () {
                  setState(() {
                    if (_isEditMode) {
                      widget.onSkillsChanged(_editableSkills);
                    } else {
                      _editableSkills = List.from(widget.skills);
                    }
                    _isEditMode = !_isEditMode;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ..._editableSkills
                .asMap()
                .entries
                .map((entry) => _buildSkillItem(entry.key, entry.value)),
          ],
        ),
        if (_isEditMode)
          ElevatedButton(
            child: const Text('Add Skill'),
            onPressed: () => setState(() => _editableSkills.add('')),
          ),
      ],
    );
  }
}
