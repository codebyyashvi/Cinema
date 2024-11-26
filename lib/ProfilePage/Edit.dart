import 'package:flutter/material.dart';
class EditableTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;
  final TextInputType keyboardType;

  EditableTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}