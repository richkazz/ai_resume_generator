import 'package:flutter/material.dart';
import 'package:myapp/spacing/app_spacing.dart';
import 'package:myapp/themes/themes.dart';

class ChipInput extends StatefulWidget {
  final String label;
  final bool useAsLabel;
  final List<String> initialValues;
  final Function(List<String>) onChanged;

  const ChipInput({
    super.key,
    required this.label,
    this.useAsLabel = true,
    required this.initialValues,
    required this.onChanged,
  });

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
    if (_values.isEmpty && widget.initialValues.isNotEmpty) {
      _values = List.from(widget.initialValues);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.useAsLabel)
          Text(widget.label!, style: Theme.of(context).textTheme.titleSmall),
        if (!widget.useAsLabel)
          const SizedBox(
            height: AppSpacing.md,
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
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
        const SizedBox(
          height: AppSpacing.md,
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Add ${widget.label}',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addValue,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.inputTextFieldEnabledBorderColor,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.inputTextFieldEnabledBorderColor,
              ),
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
