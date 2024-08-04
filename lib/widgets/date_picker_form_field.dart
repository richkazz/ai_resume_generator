import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final DateTime? initialDate;
  final String labelText;
  final ValueChanged<DateTime?> onSaved;

  const DatePickerFormField({
    super.key,
    required this.initialDate,
    required this.labelText,
    required this.onSaved,
  });

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900, 1, 1),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != _selectedDate) {
          setState(() {
            _selectedDate = pickedDate;
          });
          widget.onSaved(_selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: const InputDecoration().fillColor,
          border: Border.all(
            color: Theme.of(context).disabledColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              _selectedDate == null
                  ? 'N/A'
                  : DateFormat('MMM yyyy').format(_selectedDate!),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Spacer(),
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}
