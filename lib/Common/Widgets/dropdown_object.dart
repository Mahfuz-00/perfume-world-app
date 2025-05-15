import 'package:flutter/material.dart';

import '../../Core/Config/Theme/app_colors.dart';

class DropdownWithObject extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hinttext;
  final List<Map<String, Object>> options; // List of maps with 'name' and 'id'
  final String? selectedValue; // Store the selected ID
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixicon;
  final BoxConstraints? prefixconstraint;

  DropdownWithObject({
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

    // Check for duplicate values in the options list based on 'id'
    assert(options.toSet().length == options.length,
    'Options list contains duplicate values');

    // Ensure the selectedValue is valid (either null or an item from options)
    String? validSelectedValue =
    options.any((option) => option['id'] == selectedValue) ? selectedValue : null;

    return DropdownButtonFormField<String>(
      value: validSelectedValue,
      // Use the validSelectedValue here
      onChanged: onChanged,
      validator: validator,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.primary,
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
      items: options.map((Map<String, Object> option) {
        return DropdownMenuItem<String>(
          value: option['id'].toString(),  // Use the 'id' as the value
          child: Text(option['name'].toString()), // Display the 'name' in the UI
        );
      }).toList(),
    );
  }
}
