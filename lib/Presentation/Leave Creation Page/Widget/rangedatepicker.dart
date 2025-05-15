import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class RangeDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function(DateTime, DateTime) onDateSelected;

  const RangeDatePicker({
    required this.controller,
    required this.label,
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<RangeDatePicker> createState() => _RangeDatePickerState();
}

class _RangeDatePickerState extends State<RangeDatePicker> {
  DateTime? startDate;
  DateTime? endDate;

  // Function to show the date range picker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDateRange: (startDate != null && endDate != null)
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null && picked.start != null && picked.end != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        if (startDate == endDate) {
          // Same day selected for both start and end
          widget.controller.text = DateFormat('dd MMM').format(startDate!); // Format as "20 Nov"
        } else {
          // Different start and end dates
          widget.controller.text =
          '${DateFormat('dd MMM').format(startDate!)} - ${DateFormat('dd MMM').format(endDate!)}'; // Format as "20 Nov - 22 Nov"
        }
      });
      widget.onDateSelected(startDate!, endDate!); // Notify the parent widget with the selected date range
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateRange(context), // Trigger date picker on tap
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
            suffixIcon: (startDate != null && endDate != null)
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
