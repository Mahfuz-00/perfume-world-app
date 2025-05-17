import 'package:flutter/material.dart';

import '../../Core/Config/Theme/app_colors.dart';

class TextEditor extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function()? onTap;

  const TextEditor({
    Key? key,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.obscureText = false,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obscureText,
      style: textStyle ?? const TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? const TextStyle(color: AppColors.textGrey, fontFamily: 'Roboto', fontWeight: FontWeight.w400, fontSize: 20),
        border: border ?? OutlineInputBorder(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
