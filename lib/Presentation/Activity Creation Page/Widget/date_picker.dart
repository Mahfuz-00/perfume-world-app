import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class DatePickerFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function(DateTime) onDateSelected;

  DatePickerFormField({
    required this.controller,
    required this.label,
    required this.onDateSelected,
  });

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  bool isDateSelected = false;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2025);
    DateTime lastDate = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        widget.controller.text = DateFormat('dd-MM-yyyy').format(picked);
        //widget.controller.text = "${picked.toLocal()}".split(' ')[0]; // Format date as YYYY-MM-DD
        isDateSelected = true;
      });
      widget.onDateSelected(picked); // Notify the parent widget with the selected date
    }

   /* if (picked != null && picked != initialDate) {
      controller.text = "${picked.toLocal()}".split(' ')[0]; // Format date as YYYY-MM-DD
      onDateSelected(picked); // Notify the parent widget with the selected date
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
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
              suffixIcon: isDateSelected ? null: Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 24,), // Calendar icon
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            readOnly: true, // Make the field non-editable, the date will be picked
          ),
        ),
      ),
    );
  }
}
