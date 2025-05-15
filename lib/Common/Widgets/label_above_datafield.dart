import 'package:flutter/material.dart';

import '../../Core/Config/Theme/app_colors.dart';

class LabelWidget extends StatelessWidget {
  final String labelText;

  const LabelWidget({
    Key? key,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0), // Adjust spacing as needed
      child: Text(
        labelText,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: AppColors.labelGrey,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
