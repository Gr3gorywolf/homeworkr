import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  Function(String) validator;
  String label;
  String initialValue;
  Widget prefixIcon;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  String placeholder;
  Function(String) onChanged;
  int maxLength;
  int maxLines;
  int minLines;
  CustomFormField(
      {this.validator,
      this.label,
      this.prefixIcon,
      this.onChanged,
      this.keyboardType,
      this.placeholder,
      this.maxLength,
      this.maxLines,
      this.minLines,
      this.textInputAction,
      this.initialValue});
  static InputDecoration decorator(String label, {Widget prefixIcon,String placeholder}) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(),
      hintText:placeholder,
      prefixIcon: prefixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
        maxLength: maxLength,
        onChanged: onChanged,
        initialValue: initialValue,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: decorator(label,placeholder: placeholder));
  }
}
