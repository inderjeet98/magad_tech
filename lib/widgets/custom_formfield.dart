import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormFields extends StatelessWidget {
  const CustomFormFields({Key? key, required this.hintText, this.inputFormaters, this.validator, this.keyboradType, this.readOnly, this.controller}) : super(key: key);
  final String hintText;
  final List<TextInputFormatter>? inputFormaters;
  final String? Function(String?)? validator;
  final TextInputType? keyboradType;
  final bool? readOnly;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        keyboardType: keyboradType,
        inputFormatters: inputFormaters,
        validator: validator,
        decoration: InputDecoration(hintText: hintText),
      ),
    );
  }
}
