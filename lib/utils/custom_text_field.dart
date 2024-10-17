import 'package:flutter/material.dart';
import 'package:graduation_app/utils/app_colors.dart';

class CustomTextfield extends StatelessWidget {
  // String? hintText;
  TextEditingController controller; // to save what the user write
  TextInputType keyboardType; // optional in constructor
  bool obscureText; // input is visible or not, false => visible
  // MyValidator validator; // make sure all fields are written in it
  // OR String? Function(String?) validator;
  // Widget? suffixIcon;
  String labelText;
  // String text2;
  TextStyle? style;

  CustomTextfield(
      {
      // this.hintText = null,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.labelText = '',
      // this.text2 = '',
      // required this.validator,
      // this.suffixIcon = null,
      this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: AppColors.mediumBlue, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: AppColors.mediumBlue, width: 1.5)),
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
