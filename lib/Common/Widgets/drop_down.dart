import 'package:flutter/material.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class Dropdown extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hinttext;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixicon;
  final BoxConstraints? prefixconstraint;

  Dropdown({
    required this.controller,
    required this.label,
    required this.hinttext,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.validator,
    this.prefixicon,
    this.prefixconstraint,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Check for duplicate values in the options list
    assert(options.toSet().length == options.length,
        'Options list contains duplicate values');

    // Ensure the selectedValue is valid (either null or an item from options)
    String? validSelectedValue =
        options.contains(selectedValue) ? selectedValue : null;

    return DropdownButtonFormField<String>(
      value: validSelectedValue,
      // Use the validSelectedValue here
      onChanged: onChanged,
      validator: validator,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.primary, /* size: 24,*/
      ),
      iconSize: 24,
      iconEnabledColor: AppColors.labelGrey,
      iconDisabledColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.labelGrey,
          fontFamily: 'Roboto',
        ),
        hintText: hinttext,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.labelGrey,
          fontFamily: 'Roboto',
        ),
        prefixIcon: prefixicon,
        prefixIconConstraints: prefixconstraint,
        /* suffixIcon: Icon(Icons.arrow_drop_down),*/
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.labelGrey,
        fontFamily: 'Roboto',
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }
}
