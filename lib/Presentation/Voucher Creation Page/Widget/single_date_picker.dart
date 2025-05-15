import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class SingleDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function(DateTime) onDateSelected;

  const SingleDatePicker({
    required this.controller,
    required this.label,
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<SingleDatePicker> createState() => _SingleDatePickerState();
}

class _SingleDatePickerState extends State<SingleDatePicker> {
  bool isDateSelected = false;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to the current date
      firstDate: DateTime(2024), // Allow dates from 1900
      lastDate: DateTime(2100), // Allow dates up to 2100
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('dd-MM-yyyy').format(picked); // Format date
        isDateSelected = true;
      });
      widget.onDateSelected(picked); // Notify the parent widget with the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context), // Trigger date picker on tap
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.labelGrey,
              fontFamily: 'Roboto',
            ),
            suffixIcon: isDateSelected
                ? null
                : Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primary,
              size: 24,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          readOnly: true, // Make the field non-editable, date is picked via the date picker
        ),
      ),
    );
  }
}
